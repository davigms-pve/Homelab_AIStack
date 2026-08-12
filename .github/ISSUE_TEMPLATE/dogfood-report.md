---
name: Dogfood report
about: You followed a block on your own hardware — tell us what actually happened
title: "Dogfood: "
labels: []
---

**This is the most valuable issue anyone can open here.** Every block in this
repo currently sits at `L0` — written from official documentation and never run
by anyone. You following one on your own machine is `L4` evidence, and it's
worth more than any amount of self-checking by the people who wrote it, because
they're the least-cold readers of this content on Earth. A report that ends in
failure is just as useful as one that ends in success; more useful, often.

See `docs/methodology.md` for what the rungs mean.

**Which block, and at which commit or tag?**

**What hardware and software?**
(CPU/GPU, motherboard if firmware settings mattered, platform version, whether
this was bare metal or nested virtualization — nested is still worth reporting,
just say so, since it changes what your run can prove.)

**Did it work end to end?**
(Yes / no / partly — and where it stopped.)

**Every command that was wrong, missing, or needed changing**
Please be specific — the exact command as written, and what actually worked
instead. This is the part that turns into a fix.

**Anything the checklist never asked you, but you needed to know**
Missing prerequisites, a firmware toggle nobody mentioned, an ordering that
only works one way round. These are usually the highest-value findings.

**Anything you couldn't reach**
Parts of the block your environment structurally couldn't test.

**How long did it take, and where did you get stuck?**
Optional, but it tells us where the instructions are thin rather than wrong.
