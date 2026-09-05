# Carousel & Short-Form Video Production Blueprint

---

## 1. The 9-Slide High-Converting Technical Carousel Architecture

Carousels (PDF documents on LinkedIn, swipeable graphics on Instagram) have the highest save and share rates across technical networks when executed cleanly.

### Slide-by-Slide Blueprint

| Slide | Purpose | Visual / Content Rule | Design Specification |
|---|---|---|---|
| **Slide 1: The Hook** | Stop the scroll in <1.5s | Bold statement + high-contrast visual (e.g., *"Docker Containers vs Virtual Machines: The Missing Diagram"*). | Large 48pt headline, dark background (`#0B0F19`), vibrant accent color (Cyan `#06B6D4` or Emerald `#10B981`), your profile avatar + handle. |
| **Slide 2: The Problem** | Relate to reader pain | Highlight a real failure or misconception (e.g., *"Why your Docker images are 1.2 GB and taking 8 minutes to build"*). | Code snippet with red callout box highlighting bloated `npm install` layer. |
| **Slide 3: The First Principle** | Explain underlying architecture | Define the core concept simply (e.g., *"How the Linux Kernel sees containers: Namespaces + Cgroups"*). | Minimalist SVG diagram: Host Kernel splitting into process isolation boundaries. |
| **Slide 4: The Deep Dive** | The mechanism in action | Break down the internal flow step-by-step (e.g., *“Step 1: PID Namespace creates a dedicated process tree...”*). | Numbered card layout with clear typography and monospaced terminal text. |
| **Slide 5: The Working Solution** | Clean, practical code | Show the correct way to implement it (e.g., Multi-stage Dockerfile with Alpine/Distroless). | Syntax-highlighted code editor mockup (VS Code theme, dark mode) with green annotations. |
| **Slide 6: Common Trap / Anti-Pattern** | What 90% of people get wrong | Expose the subtle edge case (e.g., *"Running containers as root user in production"*). | Warning badge (Amber `#F59E0B`), "Don't Do This vs Do This" split view. |
| **Slide 7: Production Best Practice** | Senior engineer tip | Real-world optimization (e.g., *"Adding a non-root user + `.dockerignore` + layer pinning"*). | Checklist graphic with green checkmarks and quantifiable metric (e.g., *"Result: 42MB image, 15s build"*). |
| **Slide 8: The Summary Cheat Sheet** | High-utility reference worth saving | Compact reference card summarizing the entire concept in a single view. | Grid layout or comparison table summarizing key commands or parameters. |
| **Slide 9: The Conversation / CTA** | Invite high-signal discussion | Authentic question + invitation to follow (e.g., *"What is your team’s default base image in production? Follow for daily Cloud & DevOps breakdowns."*). | Clean outro card with headshot, GitHub URL, and prompt: *"Save this post for your next deployment drill"*. |

---

## 2. 60-Second Short-Form Video Scripting Framework

For YouTube Shorts, Instagram Reels, and LinkedIn Video:

### Timing & Structural Breakdown

```
[00:00 - 00:05] THE SCROLL-STOPPING HOOK
Visual: Camera on screen pointing to a red terminal error, or you speaking directly with energetic pace.
Audio: "If you're still using default Linux permissions on your SSH keys, you're one command away from getting locked out."
On-Screen Text: "Stop doing this with chmod 777 ⚠️"

[00:05 - 00:18] THE PROBLEM / MISCONCEPTION
Visual: B-Roll of running `chmod 777 id_rsa` and getting an `UNPROTECTED PRIVATE KEY FILE` error.
Audio: "Most people just run chmod 777 whenever they hit a permission error. But SSH will literally refuse to connect if your private key is readable by other users on the system."

[00:18 - 00:38] THE VISUAL EXPLANATION & COMMAND
Visual: Screencast showing the octal breakdown: Owner (4+2=6), Group (0), Others (0).
Audio: "Linux uses 3 digits: Owner, Group, Others. 4 is Read, 2 is Write, 1 is Execute. For private keys, only you should read and write. That’s 4 plus 2 equals 6. Everyone else gets 0."

[00:38 - 00:52] THE FIX
Visual: Running `chmod 600 ~/.ssh/id_rsa` followed by successful SSH login.
Audio: "Run `chmod 600` on your private key, and `chmod 644` on your public key. Secure, repeatable, and SSH works instantly."

[00:52 - 01:00] THE ACTIONABLE CTA
Visual: You back on camera, point to caption.
Audio: "Save this video for your next server setup, and check the caption for the complete Linux permissions cheat sheet."
```
