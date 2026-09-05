# Recruiter Attractor Engine

> **Principle**: Top companies rarely hire from desperate application blasts. They hire engineers who demonstrate competence, clarity of communication, and verifiable proof of work in plain sight.

---

## 1. What Tech Recruiters & Hiring Managers Actually Scan For

When a technical recruiter or engineering manager lands on your profile after reading a post, they spend **15 to 30 seconds** seeking answers to five questions:

| Recruiter Question | What Triggers a "YES" | What Triggers a "SKIP" |
|---|---|---|
| **1. What is their core domain?** | Clear headline with specific technologies: AWS, Kubernetes, Terraform, CI/CD, Python/Go. | Vague taglines: "Tech Enthusiast", "Aspiring Engineer", "Passionate Learner". |
| **2. Can they actually write code and configure systems?** | Direct GitHub links with real commits, clean READMEs, and production-like repos. | Zero code links, only reposts of motivational quotes or certificate badges. |
| **3. Can they communicate complex problems simply?** | Structured posts with clear headings, ASCII diagrams, and trade-off explanations. | Dense walls of text, broken English, or abrasive hot takes. |
| **4. Do they understand production engineering?** | Mentions of monitoring, security scanning, rollback strategies, cost optimization, and test suites. | Only toy "hello-world" tutorials that lack real-world edge cases. |
| **5. Are they consistent and coachable?** | Consistent, multi-month trail of documented builds, experiments, and post-mortems. | Inactive for 3 months, then 10 posts in two days begging for referrals. |

---

## 2. The Public Proof-of-Work Post Framework (STAR-L)

Use this structure for every project milestone post to subtly showcase senior-level engineering behavior without ever begging for an interview:

```
[S - Situation]
"When deploying microservices to Kubernetes, monolithic deployments often cause cascading failures during database schema migrations."

[T - Task]
"I set out to build a fully automated, zero-downtime deployment pipeline using GitHub Actions, Helm, and ArgoCD that handles database migrations before traffic cutover."

[A - Action]
"Here is how I architected it:
1. Multi-stage Docker build utilizing distroless base images (reduced attack surface by 78%).
2. Pre-sync Kubernetes Job in Helm that executes database migrations in an isolated container.
3. Canary deployment rollout via Argo Rollouts, gradually routing 10% -> 25% -> 50% -> 100% traffic based on Prometheus error rates."

[R - Result]
"Zero downtime during deployment drills, and automated rollback triggers within 12 seconds if error rate exceeds 1%."

[L - Learning / Open Code]
"Full architecture schematic, Helm templates, and GitHub Actions workflow are available in my open-source repository: [github-link]

What rollback metrics does your team prioritize during canary releases?"
```

---

## 3. The "Recruiter Magnet" Post Types

### Post Type 1: The Architecture Breakdown
- **Goal**: Signals systems-level thinking.
- **Hook**: *"Most tutorials deploy an AWS EC2 instance into a default public VPC. Here is how I architected a production-ready, multi-AZ private VPC from scratch using Terraform."*
- **Visual**: Minimalist architecture diagram showing Internet Gateway, NAT Gateways, Public vs Private Subnets, and Route Tables.

### Post Type 2: The Debugging Post-Mortem
- **Goal**: Signals perseverance, problem-solving grit, and root-cause analysis.
- **Hook**: *"A container deployment that exited with Code 137 cost me 3 hours of debugging yesterday. Here is what actually happened beneath the surface."*
- **Body**: Explains Linux OOM-killer (Out of Memory), cgroups limits vs host memory, and how setting proper Pod resource requests/limits fixed the issue.

### Post Type 3: The Cost Optimization & Efficiency Breakdown
- **Goal**: Signals business acumen and engineering maturity.
- **Hook**: *"How cleaning up orphaned EBS volumes and optimizing Docker layer caching saved $420/month on cloud spend."*
- **Body**: Shares practical commands, Terraform retention tags, and automated pruning scripts.

---

## 4. Handling Inbound Inquiries

When a recruiter reaches out via LinkedIn DM:

### The Professional Response Template:
> *"Hi [Recruiter Name], thanks for reaching out. The role at [Company] sounds compelling, particularly the work your team is doing with [specific technology mentioned in message, e.g., Kubernetes / Cloud platform modernization].*  
>  
> *Here is a quick overview of my recent work:  
> • GitHub Architecture & Code: [github-link]  
> • Live Portfolio & Case Studies: [portfolio-link]  
> • Resume: [attached PDF]  
>  
> *I’d be happy to hop on a 15-minute introductory call to learn more about the team's upcoming roadmap and discuss how my skills in automated infrastructure and CI/CD can help. When does your calendar look best this week?"*
