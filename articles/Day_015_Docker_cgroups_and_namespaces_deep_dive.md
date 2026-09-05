---
title: "Containers Under the Hood: Building a Container From Scratch with Linux Namespaces and Cgroups v2"
published: true
description: "Demystifying Docker by creating isolated container environments from scratch using unshare, pivot_root, and cgroup resource controllers."
tags: docker, linux, devops, containers
canonical_url: "https://github.com/your-username/365-days-of-devops/blob/main/articles/day-015.md"
cover_image: "../assets/day_015/slide_1_hook.jpg"
---

# Containers Under the Hood: Building a Container From Scratch with Linux Namespaces and Cgroups v2

> **"There is no such thing as a 'container' in the Linux kernel. A container is simply an ordinary Linux process wrapped in namespaces for isolation and cgroups for resource metering."**

---

## 1. The Container Illusion

When you type:
```bash
docker run -d --name redis -m 512m -p 6379:6379 redis:alpine
```

It feels like Docker boots a mini virtual machine with its own operating system kernel, network card, and isolated file tree.

In reality:
- **No hypervisor** exists.
- **No guest kernel** is loaded.
- The Redis process runs directly on your host kernel’s CPU scheduler right next to your web browser and text editor.

Docker is simply a friendly user-space daemon that coordinates two fundamental Linux kernel subsystems:
1. **Linux Namespaces** (What a process can **see**).
2. **Control Groups (cgroups)** (How much a process can **use**).

In this deep dive, we will build a production-grade isolated container environment from scratch using native Linux terminal tools—without installing Docker.

---

## 2. The 7 Linux Namespaces Explained

Namespaces partition global system resources into isolated visual boundaries:

| Namespace | Linux Flag | What It Isolates |
|---|---|---|
| **PID** | `CLONE_NEWPID` | Process IDs (the container gets its own PID 1) |
| **NET** | `CLONE_NEWNET` | Network devices, routing tables, port bindings, IP addresses |
| **MNT** | `CLONE_NEWNS` | Filesystem mount points and drive mounts |
| **IPC** | `CLONE_NEWIPC` | Inter-process communication and shared memory segments |
| **UTS** | `CLONE_NEWUTS` | Hostname and NIS domain name |
| **USER** | `CLONE_NEWUSER`| User and group IDs (root inside container maps to unprivileged user on host) |
| **CGROUP**| `CLONE_NEWCGROUP`| Visibility of cgroup hierarchy |

---

## 3. Hands-On: Launching an Isolated Process with `unshare`

Let us create a process isolated in its own PID, UTS, and Mount namespaces:

```bash
# 1. Create a rootfs directory with Alpine mini root
mkdir -p /tmp/mycontainer/rootfs
cd /tmp/mycontainer
curl -sSL https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-minirootfs-3.19.1-x86_64.tar.gz | tar -xz -C rootfs/

# 2. Enter isolated namespaces
sudo unshare --mount --uts --ipc --net --pid --fork chroot rootfs /bin/sh
```

Inside this newly launched shell:
```bash
/ # hostname sandbox-container
/ # ps aux
# Notice ps still looks at the host /proc! Let's mount an isolated proc filesystem:
/ # mount -t proc proc /proc
/ # ps aux
PID   USER     TIME  COMMAND
    1 root      0:00 /bin/sh
    5 root      0:00 ps aux
```

You now have an isolated environment where `/bin/sh` is **PID 1**, unable to see any other processes running on the host system!

---

## 4. Enforcing Hard Resource Limits with Cgroups v2

Namespaces prevent a process from seeing host resources, but they do **not** prevent a rogue process from consuming 100% of the host’s RAM or CPU cores. That is the job of **cgroups**.

In Linux kernels 5.8+, **Cgroups v2** organizes resource controls under `/sys/fs/cgroup`:

```bash
# 1. Create a cgroup slice for our container
sudo mkdir /sys/fs/cgroup/container_demo

# 2. Limit memory to 256 Megabytes (268,435,456 bytes)
echo "268435456" | sudo tee /sys/fs/cgroup/container_demo/memory.max

# 3. Limit CPU to 50% of one core (50,000 microseconds per 100,000 microsecond period)
echo "50000 100000" | sudo tee /sys/fs/cgroup/container_demo/cpu.max

# 4. Attach our container process (PID) to this cgroup
echo "$PID" | sudo tee /sys/fs/cgroup/container_demo/cgroup.procs
```

### What Happens During Memory Exhaustion?
If the process allocates 260MB of RAM:
1. The kernel invokes the **Out-Of-Memory (OOM) Killer**.
2. The OOM killer evaluates processes strictly inside `container_demo`.
3. The containerized process is terminated with `SIGKILL` (**Exit Code 137**).
4. The host system and all neighboring applications remain completely untouched.

---

## 5. Why This Matters for Production Kubernetes

Understanding these kernel primitives separates junior operators from Senior SREs:

1. **Kubernetes Requests vs Limits**:
   - `resources.requests.cpu` maps directly to `cpu.weight` in cgroups v2.
   - `resources.limits.cpu` maps directly to `cpu.max` CFS bandwidth throttling.
   - `resources.limits.memory` sets `memory.max`. If crossed, kernel OOM occurs immediately.
2. **CPU Throttling Without High CPU Usage**:
   - If your application spikes CPU within a 100ms quota period, CFS throttling kicks in, causing latency spikes even when overall 1-minute CPU averages look low (20%).
3. **The `hostNetwork: true` Vulnerability**:
   - Specifying `hostNetwork: true` skips network namespace isolation, allowing a container pod to bind directly to the node's local ports and sniff host traffic.

---

## 6. Summary Checklist

- [x] Containers are isolated processes, not VMs.
- [x] Namespaces control **visibility** (`pid`, `net`, `mnt`).
- [x] Cgroups control **resource quotas** (`memory.max`, `cpu.max`).
- [x] Exit Code 137 means $128 + 9$ (`SIGKILL`), almost always caused by Cgroup `memory.max` breach.
