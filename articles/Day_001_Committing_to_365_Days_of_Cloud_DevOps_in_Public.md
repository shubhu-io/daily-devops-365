---
title: "Committing to 365 Days of Cloud Infrastructure & DevOps in Public"
published: true
description: "Why learning in public beats passive consumption, the 4-stage engineering engine, and the complete 365-day curriculum from Linux kernels to GitOps."
tags: devops, cloud, career, learninpublic
canonical_url: "https://github.com/your-username/365-days-of-devops/blob/main/articles/day-001.md"
cover_image: "../assets/day_001/slide_1_hook.jpg"
---

# Committing to 365 Days of Cloud Infrastructure & DevOps in Public

> **"Most engineers wait until they feel like an expert to share their knowledge. Today, I am doing the exact opposite: documenting 365 consecutive days of cloud infrastructure and systems engineering in public."**

---

## 1. The Trap of Passive Consumption

In software engineering and cloud infrastructure, there is an insidious trap known as the **Tutorial Illusion**:
You watch a 4-hour video course on Kubernetes. You read a 50-page guide on Terraform modules. Everything clicks in the moment. You nod along. 

Then, Monday morning arrives at work:
- An Amazon EKS node group goes into `NotReady` state during a peak traffic spike.
- A Terraform state file locks with conflicting MD5 checksums across remote S3 backends.
- A Linux container kernel OOM-kills a mission-critical Go microservice.

Suddenly, you realize that watching someone else build a cluster does not equal the muscle memory required to debug a distributed system under fire.

True engineering competency is forged through three non-negotiable realities:
1. **Building non-trivial architectures from scratch.**
2. **Breaking things intentionally and diagnosing the root cause through telemetry.**
3. **Explaining complex systems with clarity and precision to your peers.**

Starting today, I am embarking on a **365-Day Journey of Cloud Infrastructure, DevOps, and Systems Engineering**. Every day, I will publish actionable code, real failure post-mortems, architectural diagrams, and production configs.

---

## 2. The 4-Stage Continuous Learning Engine

To maintain extreme quality and avoid burnout across 365 consecutive days, this journey is governed by a strict operational loop:

```text
┌─────────────────────────────────────────────────────────┐
│              THE 4-STAGE LEARNING ENGINE                 │
│                                                         │
│  [1. LEARN]      Deep dive into first principles        │
│        │         (Kernel, RFCs, official specs)         │
│        ▼                                                │
│  [2. BUILD]      Construct real infrastructure          │
│        │         (Terraform, K8s, Docker, Go, Python)   │
│        ▼                                                │
│  [3. DOCUMENT]   Write repeatable, versioned code       │
│        │         (Open-source GitHub repositories)      │
│        ▼                                                │
│  [4. EXPLAIN]    Synthesize high-signal breakdowns      │
│                  (Carousels, articles, post-mortems)    │
└─────────────────────────────────────────────────────────┘
```

### Stage 1: Learn (First Principles)
We do not copy random StackOverflow snippets. We read Linux manual pages, RFC specifications, Kubernetes design proposals, and AWS whitepapers. When examining Docker containers, we look at `clone(2)`, `unshare(2)`, and `cgroups(7)`, not just `docker run`.

### Stage 2: Build (Production-Grade Systems)
Toy "Hello World" tutorials are strictly prohibited. Every project must feature:
- Health check probes (`liveness`, `readiness`, `startup`).
- Resource boundaries (`cpu: 250m`, `memory: 512Mi`).
- Automated CI/CD pipelines with secret scanning and static analysis.
- Telemetry endpoints exporting Prometheus metrics.

### Stage 3: Document (Reproducibility)
If it is not in Git, it does not exist. All code, Terraform state definitions, Dockerfiles, and Helm charts developed throughout this 365-day program are versioned and open-sourced.

### Stage 4: Explain (The Feynman Technique)
If you cannot explain how Linux cgroups enforce memory limits to a junior engineer, you do not truly understand cgroups. Synthesizing complex concepts into visual carousels and technical articles forces maximum clarity.

---

## 3. The 6 Core Technical Pillars

Over the next 365 days, our curriculum spans six progressive engineering phases:

```text
365-Day Curriculum Progression:
[Phase 1: Days 001-030] ➔ Linux Internals, Networking & Python/Bash Automation
[Phase 2: Days 031-090] ➔ Container Systems, Kubernetes & Multi-Cloud Infrastructure
[Phase 3: Days 091-180] ➔ Build in Public: 3 Flagship Enterprise Projects
[Phase 4: Days 181-270] ➔ SRE Telemetry, Zero-Trust Security & eBPF Deep Dives
[Phase 5: Days 271-330] ➔ High-Scale System Design, Chaos Engineering & Production
[Phase 6: Days 331-365] ➔ 7-Tier Capstone Architecture, Reputation & Mentorship
```

### Pillar 1: Linux & Systems Internals (Days 001–030)
- Inodes, VFS (Virtual File System), and POSIX permission math.
- The Linux boot process: BIOS/UEFI ➔ GRUB ➔ Kernel init ➔ Systemd PID 1.
- Process states: `R` (running), `S` (interruptible sleep), `D` (uninterruptible disk sleep), and `Z` (zombie reaping).
- Networking stack: TCP 3-way handshake, SYN floods, socket buffers, and iptables/nftables packet filtering.

### Pillar 2: Containerization & Cloud Native (Days 031–090)
- Container primitives: Namespaces (`pid`, `net`, `mnt`, `ipc`, `uts`, `user`) and Cgroups v2.
- Multi-stage Dockerfile optimization: Reducing image sizes from 1.2GB to 18MB via Distroless and Alpine.
- Kubernetes Control Plane: API Server reconciliation, etcd Raft consensus, Kubelet PLEG loops.
- Infrastructure as Code: Terraform modular design, remote state locking with DynamoDB, drift detection.

### Pillar 3: End-to-End Enterprise Projects (Days 091–180)
1. **Zero-Trust Secure CI/CD Supply Chain**: GitOps with ArgoCD, Cosign cryptographic image signing, Trivy vulnerability gates.
2. **Multi-Region Resilient Kubernetes Platform**: Amazon EKS across multiple availability zones, Karpenter autoscaling, Cilium eBPF CNI.
3. **Cloud-Agnostic Observability Stack**: OpenTelemetry Collector, Prometheus, Grafana, and Jaeger distributed tracing.

### Pillar 4: SRE, Chaos & Security (Days 181–270)
- Service Level Objectives (SLOs), Error Budgets, and alerting without burnout.
- Chaos Engineering: Simulating packet drop, CPU thrashing, and AZ blackholes with Chaos Mesh.
- eBPF (Extended Berkeley Packet Filter): Tracing system calls and kernel probes in real-time with zero overhead.

### Pillar 5: System Design & Production Readiness (Days 271–330)
- Distributed caching (Redis cluster sharding, cache stampede prevention).
- Asynchronous event streaming (Kafka partition rebalancing, consumer lag metrics).
- Zero-downtime database schema migrations in production.

### Pillar 6: Capstone Architecture & Community (Days 331–365)
- Architecting a complete 7-tier production-grade cloud platform from bare metal to global DNS.
- Authoring comprehensive post-mortems and mentoring the next generation of engineers.

---

## 4. The Rules of Engagement

To keep this endeavor authentic and high-signal, I am holding myself to four non-negotiable rules:

1. **Zero Generic Quotes**: You will never see generic AI motivational platitudes. Every post must teach a specific concept, show real code, or diagnose an engineering failure.
2. **Reproducible Code Only**: All commands and YAML manifests must be tested against real environments before publication.
3. **Blameless Post-Mortems**: When deployments fail or scripts destroy resources (which will inevitably happen), I will document the post-mortem transparently.
4. **Consistency Over Intensity**: 1 hour of focused engineering and writing every day consistently outperforms sporadic 12-hour weekend binges.

---

## 5. How to Follow Along and Collaborate

All code, configurations, slides, and articles are open-sourced in our public GitHub repository:
- **GitHub Repository**: `https://github.com/your-username/365-days-of-devops`
- **Daily Carousels**: 5-slide visual breakdowns on LinkedIn & Instagram.
- **Deep-Dive Articles**: Weekly long-form publications on Dev.to and Medium.

If you are a student, junior engineer, senior architect, or hiring manager passionate about distributed systems and cloud infrastructure, let's connect:
- Drop a star on the GitHub repo.
- Leave a comment sharing the biggest production outage you have ever debugged.
- Follow along daily as we build, break, and master modern cloud engineering together.

**Day 1 begins now. Let's build.**
