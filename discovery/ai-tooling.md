# AI tooling discovery

requires: [needs]

This is the one discovery topic that's a little different: the person needs *an AI agent* to keep using these templates at all, so this has to be resolvable without assuming they have one yet. Keep it to capability classes, not a ranked comparison — specific tools change faster than this repo can track them.

## Checklist

- **Capability class needed:**
  - An agent that can run shell commands, read/write files, and reach real hosts (SSH, APIs) — needed for anything past discovery, i.e. actually operating a host-platform or domain block.
  - A chat-only assistant that can advise and explain but can't execute anything — enough for working through `needs.md` and `hardware-envelope.md`, not enough to run the Agent Operating Cadence later.
- **Where it runs** — terminal/CLI-native, or an IDE-integrated assistant, or a hosted chat interface. This affects how "give it this repo's templates" actually happens in practice.
- **Say plainly where the agent lives versus what it operates on.** These are two different machines and people routinely assume they're one. The agent runs on the person's **everyday computer** — laptop, desktop, whatever they're typing on — and reaches the server **over the home network**. The server is headless: no monitor, no keyboard, and nothing is "installed onto it" to make the agent work. Their daily machine needs to be on the same network and nothing more; a very old laptop is a perfectly good place to run the agent from. State this early and unprompted. Someone who hasn't heard it can reasonably conclude their laptop has to *be* the server and worry it's not powerful enough — or conclude the AI tool gets installed on the server and wonder how, given the server doesn't exist yet.
- **Cost model** — free tier, subscription, or usage-based — relevant to someone's budget alongside hardware.

## Example

Continuing the persona from `needs.md` (wants AI stack primary, media later, ~$800, apartment, quiet, has used Docker a little). A worked, fictional conversation outcome — what a completed pass looks like, not a transcript to copy. Tools are described by what they can do, never by product: products change faster than this repo can track, and naming one would read as a pick.

> **What they already use:** a general-purpose AI assistant in a terminal on their everyday laptop, on a monthly subscription. It can run commands and edit files in a folder they point it at. They'd assumed they'd have to install it "on the server" and were relieved to hear they don't.
> **Where it lives vs. what it operates on:** said unprompted — the agent runs on the laptop; the server will be a headless box in the closet that the laptop reaches over the home network. Nothing gets installed onto the server to make the agent work, and the laptop only has to be on the same network. They hadn't realised their older laptop would be fine for that.
> **Cost model:** subscription, already paid for — no new line item against the ~$800 hardware budget.
> **Class, confirmed with them:** the agent knows it can execute commands, so `shell-capable` was proposed and they agreed — including what that means in practice: it proposes each state-changing command and waits for a yes, rather than running unattended.

This maps into `.homelab-state.yml` as the single key described under Output:
```yaml
decisions:
  agent_capability: shell-capable
```

*The other classes, by capability: an **IDE-integrated** agent is an editor with an agent inside it that can run commands in a project — treat it as `shell-capable`. A **chat-only** assistant has no execution ability and usually no file access; it would record `advisory-only`. Discovery still completes with the person saving the two state files by hand (step 6 of the Discovery & Advisory Cadence in `docs/methodology.md`), and the session stops there — see `start-here/TRAVERSAL.md`.*

## Output

One key: `decisions.agent_capability`, set to `shell-capable` or `advisory-only`.

This is the one field in discovery that describes the *operator* rather than the homelab, and it earns its place for two reasons. It's what `start-here/TRAVERSAL.md` reads to decide whether the person can proceed past discovery at all — an `advisory-only` setup can finish every discovery topic and then cannot execute a foundation or domain block. And recording it means a later session knows why things stopped, instead of re-deriving it or, worse, an execution-capable agent assuming the previous stall was a decision.

Don't infer this silently from your own capabilities and move on. An agent knows its own class, so the capability half is free — but *where it runs* and *cost model* above are still the person's answers, and the class only becomes a recorded decision once they've confirmed it.

## Placeholders

None to swap — this file is a conversation, not a template. Its single output key is described above.
