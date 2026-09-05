---
title: "Kubernetes Control Plane Internals: What Actually Happens When You Run kubectl apply?"
published: true
description: "A deep dive into kube-apiserver admission controllers, etcd Raft consensus, kube-scheduler scoring, and kubelet PLEG container lifecycles."
tags: kubernetes, devops, cloud, architecture
canonical_url: "https://github.com/your-username/365-days-of-devops/blob/main/articles/day-031.md"
cover_image: "../assets/day_031/slide_1_hook.jpg"
---

# Kubernetes Control Plane Internals: What Actually Happens When You Run `kubectl apply`?

> **"You type `kubectl apply -f deployment.yaml` and get back `deployment.apps/web created`. But etcd, kube-scheduler, and the kubelet just executed a distributed reconciliation dance across multiple cluster nodes."**

---

## 1. Introduction: Beyond the YAML Abstraction

To most developers, Kubernetes appears to be a declarative YAML interpreter. You submit a desired state, and within seconds, containers start serving traffic on port 8080.

However, when an outage strikes:
- Why is a Pod stuck in `Pending` when nodes appear to have available RAM?
- Why did an etcd leader election timeout trigger cascading node heartbeat failures?
- Why does the API server throw `HTTP 409 Conflict: Operation cannot be fulfilled on deployments.apps: the object has been modified`?

To debug production clusters at scale, you must understand the distributed architecture of the **Kubernetes Control Plane**.

```text
The Kubernetes Control Plane Architecture:
┌─────────────────────────────────────────────────────────────┐
│                       CONTROL PLANE                         │
│                                                             │
│   [kubectl] ──► [kube-apiserver] ◄──► [etcd (Raft DB)]      │
│                        │                                    │
│       ┌────────────────┼────────────────┐                   │
│       ▼                ▼                ▼                   │
│ [kube-scheduler] [controller-mgr] [cloud-controller-mgr]   │
└───────┬─────────────────────────────────────────────────────┘
        │
        │ Watch / Heartbeat via TLS
        ▼
┌─────────────────────────────────────────────────────────────┐
│                        WORKER NODE                          │
│                                                             │
│   [kubelet] ◄──► [containerd / CRI] ──► [Linux Pods]        │
│        ▲                                                    │
│   [kube-proxy] (iptables / IPVS rules)                      │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Step 1: Client-Side Authentication & The API Server Gateway

When you execute `kubectl apply`:
1. **Client Parsing**: `kubectl` validates the YAML schema locally against OpenAPI specifications.
2. **TLS Handshake**: `kubectl` initiates an HTTPS connection to `kube-apiserver` (port 6443) using client certificates, bearer tokens, or OpenID Connect (OIDC).
3. **Authentication (Who are you?)**: `apiserver` authenticates the request via Webhook, X.509 certs, or token reviews.
4. **Authorization (What can you do?)**: Role-Based Access Control (**RBAC**) checks whether the user has `create` verb permission on `deployments` in the target namespace.

---

## 3. Step 2: Admission Controllers (Mutating & Validating)

Before anything is committed to persistent storage, the request passes through two admission phases:

### Mutating Admission Controllers
Modifies the object before persistence:
- Injects default values (e.g., setting `imagePullPolicy: IfNotPresent`).
- Istio / Linkerd sidecar injectors add proxy containers and volume mounts to the Pod spec.

### Validating Admission Controllers
Enforces security constraints and organizational policies:
- Gatekeeper (OPA) or Kyverno checks: Does this container run as root? Are CPU limits defined? Is the image sourced from an approved enterprise container registry?
- If validation fails, the API server rejects the request immediately with an error.

---

## 4. Step 3: Persistence in `etcd` via Raft Consensus

Once validated, `kube-apiserver` serializes the JSON representation of the Deployment into **etcd**, the distributed key-value store.
- `kube-apiserver` is the **only** component in the entire cluster that communicates with `etcd`.
- etcd uses the **Raft consensus algorithm**. The write is only confirmed once a quorum of etcd members ($N/2 + 1$) persist the log entry to write-ahead disk (WAL).
- etcd records the object's `metadata.resourceVersion` to enable optimistic concurrency control.

---

## 5. Step 4: The Controller Manager Reconciliation Loop

The `kube-controller-manager` runs dozens of decoupled control loops:
1. **Deployment Controller**:
   - Watches `kube-apiserver` for new or updated `Deployment` objects.
   - Observes that a Deployment exists with `replicas: 3`, but no matching `ReplicaSet` exists.
   - Creates a `ReplicaSet` object via the API server.
2. **ReplicaSet Controller**:
   - Watches for `ReplicaSet` changes.
   - Observes that 3 Pods are desired, but 0 currently exist.
   - Generates 3 unbound `Pod` objects with `spec.nodeName: ""` (unscheduled).

---

## 6. Step 5: `kube-scheduler`: The Placement Decision

The `kube-scheduler` watches for Pods where `nodeName` is empty. It assigns each Pod to the optimal worker node in two distinct phases:

### 1. Filtering (Predicates)
Disqualifies nodes that cannot run the Pod:
- `NodeResourcesFit`: Does the node have sufficient unallocated CPU and RAM requests?
- `NodeName` & `NodeSelector`: Do node labels match?
- `Tolerations`: Does the Pod tolerate the node's taints?

### 2. Scoring (Priorities)
Ranks surviving candidate nodes on a scale of 0–100:
- `ImageLocality`: Nodes with the container image already cached receive higher scores.
- `PodTopologySpread`: Spreads Pods evenly across failure zones (e.g. AWS availability zones `us-east-1a`, `us-east-1b`).
- The node with the highest score is selected. The scheduler executes a **Binding** API call setting `spec.nodeName = "worker-node-03"`.

---

## 7. Step 6: `kubelet` Execution & The PLEG Loop

On the designated worker node:
1. The **`kubelet`** daemon has an active HTTP/2 Watch stream open to the API server.
2. It discovers that a Pod has been scheduled to its node.
3. **CRI (Container Runtime Interface)**: The kubelet sends gRPC calls to the local runtime (e.g. `containerd` or `CRI-O`):
   - Pulls container image from container registry.
   - Calls **CNI (Container Network Interface)** plugin (e.g., Cilium, Calico) to allocate an IP address and configure veth network interfaces.
   - Creates cgroups and namespaces via `runc`.
4. **PLEG (Pod Lifecycle Event Generator)**:
   - Polls the container runtime periodically to detect container state transitions (`ContainerStarted`, `ContainerDied`).
   - Reports Pod status (`Running`, `IP: 10.244.1.45`) back to `kube-apiserver`.

---

## 8. Summary: The 7-Step Lifecycle Cheat Sheet

```text
1. kubectl apply ──► 2. kube-apiserver (AuthN/AuthZ)
                          │
                     3. Mutating & Validating Webhooks
                          │
                     4. etcd Raft Quorum Write
                          │
                     5. Controller Manager creates Pods
                          │
                     6. kube-scheduler binds Pod to Node
                          │
                     7. kubelet + containerd starts Linux cgroups & veth
```

Understanding this flow allows you to isolate any cluster failure in seconds:
- If Pod is `Pending` with no events ➔ Check `kube-scheduler`.
- If Pod is stuck terminating ➔ Check `kubelet` PLEG or finalizers.
- If mutations are ignored ➔ Check Validating/Mutating Webhooks timeout.
