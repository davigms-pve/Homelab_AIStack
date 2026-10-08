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

*Described by what each class can do, never by product — the products change faster than this repo can track, and naming one here would read as a pick. Match whatever tool the person has against the class, not the other way round.*

- **Shell/host-capable agents (terminal-native):** a command-line coding agent that can execute commands and edit files directly.
- **IDE-integrated agents:** an editor with an agent built in that can run commands within a project.
- **Chat-only assistants:** a general-purpose chat interface with no execution ability and, usually, no file access — fine for discovery, with the person acting as the file system (see step 6 of the Discovery & Advisory Cadence in `docs/methodology.md`), and not sufficient once a block moves into the Agent Operating Cadence.

## Output

One key: `decisions.agent_capability`, set to `shell-capable` or `advisory-only`.

This is the one field in discovery that describes the *operator* rather than the homelab, and it earns its place for two reasons. It's what `start-here/TRAVERSAL.md` reads to decide whether the person can proceed past discovery at all — an `advisory-only` setup can finish every discovery topic and then cannot execute a foundation or domain block. And recording it means a later session knows why things stopped, instead of re-deriving it or, worse, an execution-capable agent assuming the previous stall was a decision.

Don't infer this silently from your own capabilities and move on. An agent knows its own class, so the capability half is free — but *where it runs* and *cost model* above are still the person's answers, and the class only becomes a recorded decision once they've confirmed it.

## Placeholders

None to swap — this file is a conversation, not a template. Its single output key is described above.
