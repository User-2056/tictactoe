# Conversation Log

**user** _(2026-07-22T11:31:12.715Z)_

do you remember what we discussed last time?

---

**assistant** _(2026-07-22T11:31:15.609Z)_

[used tool: Read]

---

**assistant** _(2026-07-22T11:31:18.525Z)_

I don't have any memory saved from a previous conversation — the memory index file doesn't exist yet, which means either this is our first session together or nothing was saved last time.

If you let me know what we were working on, I can pick it back up. And if you'd like me to start remembering context automatically going forward, just let me know or tell me things to save.

---

**user** _(2026-07-22T11:35:20.340Z)_

check github

---

**assistant** _(2026-07-22T11:35:24.103Z)_

I don't have a repo in context — the working directory isn't a git repository, and I don't have any saved memory pointing to a specific GitHub project. What would you like me to check? For example: a specific repo's issues/PRs, your notifications, or something else?

---

**user** _(2026-07-22T11:35:41.796Z)_

are you connected to github?

---

**assistant** _(2026-07-22T11:35:44.125Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:35:55.927Z)_

Yes — the `gh` CLI is authenticated as **User-2056**, with `repo`, `read:org`, and `gist` scopes. I can look up repos, issues, PRs, etc. What would you like me to check?

---

**user** _(2026-07-22T11:36:35.924Z)_

check everything to find what we previously discussed

---

**assistant** _(2026-07-22T11:36:40.941Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:36:43.421Z)_

There's another project directory that might have history: `C--Users-Taylor-OneDrive-Desktop-ClaudeCodeTest`. Let me check it and the current one for past session transcripts.

---

**assistant** _(2026-07-22T11:36:44.550Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:36:54.808Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:37:01.373Z)_

[used tool: Read]

---

**assistant** _(2026-07-22T11:37:01.833Z)_

[used tool: Read]

---

**assistant** _(2026-07-22T11:37:05.405Z)_

Found it — I have memory from a different project directory (`OneDrive\Desktop\ClaudeCodeTest`), tied to a GitHub repo called **User-2056/tictactoe**. Let me check that repo for the latest state.

---

**assistant** _(2026-07-22T11:37:06.750Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:37:19.129Z)_

Here's what I found from prior sessions (in a different working directory, `OneDrive\Desktop\ClaudeCodeTest`):

**Project:** A Tic Tac Toe single-page app with a CPU opponent, hosted at [User-2056/tictactoe](https://github.com/User-2056/tictactoe). Last updated **2026-07-07**, with auto-save commits tracking session work (last one: `session 2026-07-07_21-53`).

**Standing preference from that project:** commit and push every change automatically, with clean messages, so GitHub serves as full session history — no memory of that being asked for here in `C:\Users\Taylor` though, so I want to confirm before assuming it applies now.

Since we're currently in a different directory (`C:\Users\Taylor`, no git repo here), want me to:
1. Switch to working in the `tictactoe` project, or
2. Pull up more detail on what was last done there, or
3. Something else entirely?

---

**user** _(2026-07-22T11:39:58.804Z)_

any memory you find in the other directory should be transferred top this. i am workin gon the same project but i moved the file so this is why there is a diffreremt directory

---

**assistant** _(2026-07-22T11:40:05.419Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:40:07.601Z)_

The memory directory exists here but is empty. I'll copy over the feedback memory and set up the index.

---

**assistant** _(2026-07-22T11:40:11.329Z)_

[used tool: Write]

---

**assistant** _(2026-07-22T11:40:16.304Z)_

[used tool: Write]

---

**assistant** _(2026-07-22T11:40:19.201Z)_

[used tool: Write]

---

**assistant** _(2026-07-22T11:40:22.795Z)_

Memory transferred. Now saved here in this directory:

- **Project**: Tic Tac Toe single-page app with CPU opponent — repo [User-2056/tictactoe](https://github.com/User-2056/tictactoe), moved here from the old `ClaudeCodeTest` folder.
- **Workflow preference**: commit + push every change automatically (with CLAUDE.md updates when relevant), so GitHub stays the full session history.

Since the project files moved, is this current directory (`C:\Users\Taylor`) now the actual home for the tictactoe project, or is it somewhere else (e.g. a subfolder)? I want to confirm before I start treating this as the repo root and applying the auto-commit workflow here.

---

**user** _(2026-07-22T11:40:48.955Z)_

so you remember the mining corportation project?

---

**assistant** _(2026-07-22T11:40:52.818Z)_

I don't have that in memory — everything I found so far points to the Tic Tac Toe project, nothing about a mining corporation. Let me search the raw session logs in case it came up somewhere I haven't checked.

---

**assistant** _(2026-07-22T11:40:53.989Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:41:00.882Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:41:10.018Z)_

Found it — this is a different project than tic-tac-toe. Let me pull more detail on its status.

---

**assistant** _(2026-07-22T11:41:11.050Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:41:20.315Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:41:25.521Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:41:29.776Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:41:36.056Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:41:50.437Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:41:58.944Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:42:02.943Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:42:07.631Z)_

Found it — the project moved to `C:\Users\Taylor\Downloads\ClaudeCodeTest\roblox-game`. Let me check its current state.

---

**assistant** _(2026-07-22T11:42:08.629Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:42:37.351Z)_

This raises something important — let me verify, because the git remote here looks suspicious.

---

**assistant** _(2026-07-22T11:42:38.008Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:42:51.249Z)_

Good news — no data loss. The GitHub repo `User-2056/tictactoe` is actually a **monorepo** containing both projects as subfolders (`tictactoe/` and `roblox-game/`), so the mining game commits didn't overwrite anything.

Here's the full picture:

**Mining Corporation** — a Roblox multiplayer mining tycoon game, built with Rojo + Roblox Studio + MCP.
- Milestones 1–5 complete: scaffolding, core mining loop, inventory/HUD, selling with Credits currency + Atlas Ore Exchange kiosk, equipment shop (tiered pickaxes/backpacks).
- Milestone 6 never started — candidates discussed: DataService persistence, daily market prices, mining contracts.
- Most recent work (through 2026-07-08): wiring in a custom pickaxe model, fixing grip/head positioning, starter outfit, sound effects, a stray-asset error cleanup.
- Local folder moved from `OneDrive\Desktop\ClaudeCodeTest` → now at **`C:\Users\Taylor\Downloads\ClaudeCodeTest\roblox-game`**, git history intact (last commit `d9ea71f`, 2026-07-08).
- Also found: `Mining_Corporation_Design_Polish.docx` and `Mining_Corporation_Development_Plan.docx` in Downloads, plus a `Roblox Game - Mining Corporation` folder under OneDrive\Documents — haven't opened those yet.

Let me save this properly to memory now.

---

**assistant** _(2026-07-22T11:42:53.335Z)_

[used tool: Write]

---

**assistant** _(2026-07-22T11:43:01.646Z)_

[used tool: Write]

---

**assistant** _(2026-07-22T11:43:12.114Z)_

[used tool: Write]

---

**assistant** _(2026-07-22T11:43:15.984Z)_

[used tool: Write]

---

**assistant** _(2026-07-22T11:43:19.732Z)_

Memory is now fully updated with an accurate picture. Summary of what's saved:

- **ClaudeCodeTest workspace** — a monorepo (pushed to `github.com/User-2056/tictactoe`) containing two unrelated projects, now located at `C:\Users\Taylor\Downloads\ClaudeCodeTest` (moved from OneDrive\Desktop).
- **Mining Corporation** — the Roblox mining tycoon game, milestones 1–5 done, milestone 6 undecided, detailed history of the visual-polish work through 2026-07-08.
- **Tic Tac Toe** — the other project in the same workspace.
- **Git workflow preference** — auto-commit/push everything.

Want me to `cd` into `Downloads\ClaudeCodeTest\roblox-game` and pick up where Milestone 6 left off, or something else first?

---

**user** _(2026-07-22T11:43:38.753Z)_

so you remember everything in the other directory?

---

**assistant** _(2026-07-22T11:43:44.885Z)_

No — I don't have blanket recall of everything in that other directory. What I have is limited to what I could reconstruct just now by grepping the raw session logs (`.jsonl` files) in `C--Users-Taylor-OneDrive-Desktop-ClaudeCodeTest`, plus the two memory files that already existed there. That reconstruction is necessarily partial:

- I pulled the `away_summary` snippets and some grep hits — not a full read of every message in ~15 session files (some are 10–20MB).
- Anything not mentioning "mining" or "github.com" by those exact patterns wouldn't have surfaced.
- I haven't opened the two `.docx` files in Downloads or the `OneDrive\Documents\Roblox Game - Mining Corporation` folder at all.
- Actual ground truth for code state is the git history in `Downloads\ClaudeCodeTest\roblox-game`, not my summaries — I flagged that explicitly in the memory file.

So: I have a decent high-level timeline of both projects, but not perfect or complete recall of that directory's contents. If there's something specific you expect to be there, tell me what and I'll grep for it directly rather than relying on what I've already surfaced.

---

**user** _(2026-07-22T11:46:18.019Z)_

start rojo server and connect to roblox studio

---

**assistant** _(2026-07-22T11:46:21.609Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:46:27.306Z)_

Rojo 7.6.1 is available and the project config looks intact. Starting the server now.

---

**assistant** _(2026-07-22T11:46:28.217Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:46:32.813Z)_

[used tool: Read]

---

**assistant** _(2026-07-22T11:46:35.859Z)_

[used tool: ToolSearch]

---

**assistant** _(2026-07-22T11:46:39.614Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:46:49.476Z)_

Rojo server is up and running at `localhost:34872`, and Roblox Studio is already open (`RobloxStudioBeta.exe`).

There's no MCP/automation hook into Studio in this session, so the last step is manual on your end:

1. In Roblox Studio, open the **Rojo plugin** panel (Plugins tab).
2. Make sure the **Mining Corporation** place is open.
3. Click **Connect** — it should find the server at `localhost:34872` automatically.

Let me know once you've connected and I'll verify sync is working.

---

**user** _(2026-07-22T11:48:42.416Z)_

in one drive screenshot folder i have an image called pickaxe under. it shows the problem. i have created my own pickaxe and imported it intio studio but when equipped it hovers belowe the hasnd instead of being helld. fix

---

**assistant** _(2026-07-22T11:48:45.237Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:48:47.901Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:48:53.966Z)_

[used tool: Read]

---

**assistant** _(2026-07-22T11:49:00.020Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:49:03.067Z)_

[used tool: Read]

---

**assistant** _(2026-07-22T11:49:23.460Z)_

[used tool: Read]

---

**assistant** _(2026-07-22T11:50:36.555Z)_

[used tool: ToolSearch]

---

**assistant** _(2026-07-22T11:51:18.699Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:52:07.168Z)_

Let me check the timestamp on that screenshot — this exact symptom matches an older documented debugging saga that the code comments say was already fixed.

---

**assistant** _(2026-07-22T11:52:08.266Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:52:33.822Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:52:39.266Z)_

[used tool: Read]

---

**assistant** _(2026-07-22T11:52:44.255Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:52:49.225Z)_

[used tool: Read]

---

**assistant** _(2026-07-22T11:53:09.543Z)_

Good news on the root cause, but I've hit a real blocker. Here's what's going on:

**Root cause:** The pickaxe grip math in `EquipmentConfig.luau` (the `GripForward`/`GripRight`/`GripUp`/`GripPos` values) was empirically hand-tuned for a *specific* custom mesh back on 2026-07-08 — the code comments even document the whole saga of getting it right for that mesh's exact axis layout. Since you just imported a **new** mesh today, its local axes/pivot are almost certainly different, so those old tuned numbers are now pointing the grip in the wrong direction/offset — which is why it's landing down near your feet instead of in your hand.

**The blocker:** This project has a Roblox Studio MCP bridge (`Roblox_Studio` — tools like `inspect_instance`, `search_game_tree`) that would normally let me look at the new mesh's actual part sizes/orientation directly and compute the right numbers. But it's registered in Claude's config under the *old* path (`OneDrive\Desktop\ClaudeCodeTest`), which no longer exists since the project moved to `Downloads\ClaudeCodeTest` — so it's not available in this session. Guessing new grip numbers blind risks the exact trap the code comments already warn about ("looked right in a screenshot but was actually backwards").

---

**assistant** _(2026-07-22T11:53:11.905Z)_

[used tool: AskUserQuestion]

---

**assistant** _(2026-07-22T11:53:36.150Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:53:41.950Z)_

This CLI can add the MCP server directly for the new project directory. Let me run it now, scoped correctly.

---

**assistant** _(2026-07-22T11:53:42.929Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:53:48.432Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:53:50.880Z)_

[used tool: Read]

---

**assistant** _(2026-07-22T11:53:56.016Z)_

The `/c` flag got mangled by Git Bash's path conversion into `C:/`. Let me fix that directly in the config.

---

**assistant** _(2026-07-22T11:53:59.081Z)_

[used tool: Edit]

---

**assistant** _(2026-07-22T11:54:07.989Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:54:15.113Z)_

The MCP server is now correctly registered for `Downloads\ClaudeCodeTest` and shows **Connected**.

One thing to note: it's registered as **local scope** (private to you, this matches how it worked before), and I also copied over the permission allowlist that was already sitting in `.claude/settings.json` for this repo (`inspect_instance`, `search_game_tree`, `character_navigation`), so it should work without extra prompts.

Next step is on your end: start a **new Claude Code session** with working directory `C:\Users\Taylor\Downloads\ClaudeCodeTest\roblox-game` (or `Downloads\ClaudeCodeTest`) so the fresh session picks up this MCP server — the current session started before the registration and won't see it. Once you're in that new session, I (or you) can pick this pickaxe grip issue back up and I'll be able to inspect the new mesh directly via `inspect_instance` and compute the correct grip values without guessing.

---

**user** _(2026-07-22T11:58:30.959Z)_

make sure everything you have done/said in the past and going forward, including this conversation is always saved somewhere e.g in a file and also on github

---

**assistant** _(2026-07-22T11:58:40.325Z)_

This needs actual hook automation, not just a memory note — memory alone can't guarantee a file gets written and pushed after every single response. Let me set this up properly.

---

**assistant** _(2026-07-22T11:58:42.591Z)_

[used tool: Skill]

---

**user** _(2026-07-22T11:58:45.960Z)_

# Update Config Skill

Modify Claude Code configuration by updating settings.json files.

## When Hooks Are Required (Not Memory)

If the user wants something to happen automatically in response to an EVENT, they need a **hook** configured in settings.json. Memory/preferences cannot trigger automated actions.

**These require hooks:**
- "Before compacting, ask me what to preserve" → PreCompact hook
- "After writing files, run prettier" → PostToolUse hook with Write|Edit matcher
- "When I run bash commands, log them" → PreToolUse hook with Bash matcher
- "Always run tests after code changes" → PostToolUse hook

**Hook events:** PreToolUse, PostToolUse, PreCompact, PostCompact, Stop, Notification, SessionStart

## CRITICAL: Read Before Write

**Always read the existing settings file before making changes.** Merge new settings with existing ones - never replace the entire file.

## CRITICAL: Use AskUserQuestion for Ambiguity

When the user's request is ambiguous, use AskUserQuestion to clarify:
- Which settings file to modify (user/project/local)
- Whether to add to existing arrays or replace them
- Specific values when multiple options exist

## Decision: /config command vs Direct Edit

**Suggest the `/config` slash command** for these simple settings:
- `theme`, `editorMode`, `verbose`, `model`
- `language`, `alwaysThinkingEnabled`
- `permissions.defaultMode`

**Edit settings.json directly** for:
- Hooks (PreToolUse, PostToolUse, etc.)
- Complex permission rules (allow/deny arrays)
- Environment variables
- MCP server configuration
- Plugin configuration

## Workflow

1. **Clarify intent** - Ask if the request is ambiguous
2. **Read existing file** - Use Read tool on the target settings file
3. **Merge carefully** - Preserve existing settings, especially arrays
4. **Edit file** - Use Edit tool (if file doesn't exist, ask user to create it first)
5. **Confirm** - Tell user what was changed

## Merging Arrays (Important!)

When adding to permission arrays or hook arrays, **merge with existing**, don't replace:

**WRONG** (replaces existing permissions):
```json
{ "permissions": { "allow": ["Bash(npm *)"] } }
```

**RIGHT** (preserves existing + adds new):
```json
{
  "permissions": {
    "allow": [
      "Bash(git *)",      // existing
      "Edit(.claude)",    // existing
      "Bash(npm *)"       // new
    ]
  }
}
```

## Settings File Locations

Choose the appropriate file based on scope:

| File | Scope | Git | Use For |
|------|-------|-----|---------|
| `~/.claude/settings.json` | Global | N/A | Personal preferences for all projects |
| `.claude/settings.json` | Project | Commit | Team-wide hooks, permissions, plugins |
| `.claude/settings.local.json` | Project | Gitignore | Personal overrides for this project |

Settings load in order: user → project → local (later overrides earlier).

## Settings Schema Reference

### Permissions
```json
{
  "permissions": {
    "allow": ["Bash(npm *)", "Edit(.claude)", "Read"],
    "deny": ["Bash(rm -rf *)"],
    "ask": ["Write(/etc/*)"],
    "defaultMode": "default" | "plan" | "acceptEdits" | "dontAsk",
    "additionalDirectories": ["/extra/dir"]
  }
}
```

**Permission Rule Syntax:**
- Exact match: `"Bash(npm run test)"`
- Prefix wildcard: `"Bash(git *)"` - matches `git`, `git status`, `git commit`, etc.
- Tool only: `"Read"` - allows all Read operations

### Environment Variables
```json
{
  "env": {
    "DEBUG": "true",
    "MY_API_KEY": "value"
  }
}
```

### Model & Agent
```json
{
  "model": "sonnet",  // or "fable", "opus", "haiku", full model ID
  "agent": "agent-name",
  "alwaysThinkingEnabled": true
}
```

### Attribution (Commits & PRs)
```json
{
  "attribution": {
    "commit": "Custom commit trailer text",
    "pr": "Custom PR description text"
  }
}
```
Set `commit` or `pr` to empty string `""` to hide that attribution.

### MCP Server Management
```json
{
  "enableAllProjectMcpServers": true,
  "enabledMcpjsonServers": ["server1", "server2"],
  "disabledMcpjsonServers": ["blocked-server"]
}
```

### Plugins
```json
{
  "enabledPlugins": {
    "formatter@anthropic-tools": true
  }
}
```
Plugin syntax: `plugin-name@source` where source is `claude-code-marketplace`, `claude-plugins-official`, or `builtin`.

### Other Settings
- `language`: Preferred response language (e.g., "japanese")
- `cleanupPeriodDays`: Days to keep transcripts before automatic cleanup (default: 30; minimum 1)
- `respectGitignore`: Whether to respect .gitignore (default: true)
- `spinnerTipsEnabled`: Show tips in spinner
- `spinnerVerbs`: Customize spinner verbs (`{ "mode": "append" | "replace", "verbs": [...] }`)
- `spinnerTipsOverride`: Override spinner tips (`{ "excludeDefault": true, "tips": ["Custom tip"] }`)
- `syntaxHighlightingDisabled`: Disable diff highlighting


## Hooks Configuration

Hooks run commands at specific points in Claude Code's lifecycle.

### Hook Structure
```json
{
  "hooks": {
    "EVENT_NAME": [
      {
        "matcher": "ToolName|OtherTool",
        "hooks": [
          {
            "type": "command",
            "command": "your-command-here",
            "timeout": 60,
            "statusMessage": "Running..."
          }
        ]
      }
    ]
  }
}
```

### Hook Events

| Event | Matcher | Purpose |
|-------|---------|---------|
| PermissionRequest | Tool name | Run before permission prompt |
| PreToolUse | Tool name | Run before tool, can block |
| PostToolUse | Tool name | Run after successful tool |
| PostToolUseFailure | Tool name | Run after tool fails |
| Notification | Notification type | Run on notifications |
| Stop | - | Run when Claude stops (including clear, resume, compact) |
| PreCompact | "manual"/"auto" | Before compaction |
| PostCompact | "manual"/"auto" | After compaction (receives summary) |
| UserPromptSubmit | - | When user submits |
| SessionStart | - | When session starts |

**Common tool matchers:** `Bash`, `Write`, `Edit`, `Read`, `Glob`, `Grep`

### Hook Types

**1. Command Hook** - Runs a shell command:
```json
{ "type": "command", "command": "prettier --write $FILE", "timeout": 30 }
```

**2. Prompt Hook** - Evaluates a condition with LLM:
```json
{ "type": "prompt", "prompt": "Is this safe? $ARGUMENTS" }
```
Only available for tool events: PreToolUse, PostToolUse, PermissionRequest.

**3. Agent Hook** - Runs an agent with tools:
```json
{ "type": "agent", "prompt": "Verify tests pass: $ARGUMENTS" }
```
Only available for tool events: PreToolUse, PostToolUse, PermissionRequest.

### Hook Input (stdin JSON)
```json
{
  "session_id": "abc123",
  "tool_name": "Write",
  "tool_input": { "file_path": "/path/to/file.txt", "content": "..." },
  "tool_response": { "success": true }  // PostToolUse only
}
```

### Hook JSON Output

Hooks can return JSON to control behavior:

```json
{
  "systemMessage": "Warning shown to user in UI",
  "continue": false,
  "stopReason": "Message shown when blocking",
  "suppressOutput": false,
  "decision": "block",
  "reason": "Explanation for decision",
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Context injected back to model"
  }
}
```

**Fields:**
- `systemMessage` - Display a message to the user (all hooks)
- `continue` - Set to `false` to block/stop (default: true)
- `stopReason` - Message shown when `continue` is false
- `suppressOutput` - Hide stdout from transcript (default: false)
- `decision` - "block" for PostToolUse/Stop/UserPromptSubmit hooks (deprecated for PreToolUse, use hookSpecificOutput.permissionDecision instead)
- `reason` - Explanation for decision
- `hookSpecificOutput` - Event-specific output (must include `hookEventName`):
  - `additionalContext` - Text injected into model context
  - `permissionDecision` - "allow", "deny", or "ask" (PreToolUse only)
  - `permissionDecisionReason` - Reason for the permission decision (PreToolUse only)
  - `updatedInput` - Modified tool input (PreToolUse only)

### Common Patterns

**Auto-format after writes:**
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "jq -r '.tool_response.filePath // .tool_input.file_path' | { read -r f; prettier --write \"$f\"; } 2>/dev/null || true"
      }]
    }]
  }
}
```

**Log all bash commands:**
```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{
        "type": "command",
        "command": "jq -r '.tool_input.command' >> ~/.claude/bash-log.txt"
      }]
    }]
  }
}
```

**Stop hook that displays message to user:**

Command must output JSON with `systemMessage` field:
```bash
# Example command that outputs: {"systemMessage": "Session complete!"}
echo '{"systemMessage": "Session complete!"}'
```

**Run tests after code changes:**
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "jq -r '.tool_input.file_path // .tool_response.filePath' | grep -E '\\.(ts|js)$' && npm test || true"
      }]
    }]
  }
}
```


## Constructing a Hook (with verification)

Given an event, matcher, target file, and desired behavior, follow this flow. Each step catches a different failure class — a hook that silently does nothing is worse than no hook.

1. **Dedup check.** Read the target file. If a hook already exists on the same event+matcher, show the existing command and ask: keep it, replace it, or add alongside.

2. **Construct the command for THIS project — don't assume.** The hook receives JSON on stdin. Build a command that:
   - Extracts any needed payload safely — use `jq -r` into a quoted variable or `{ read -r f; ... "$f"; }`, NOT unquoted `| xargs` (splits on spaces)
   - Invokes the underlying tool the way this project runs it (npx/bunx/yarn/pnpm? Makefile target? globally-installed?)
   - Skips inputs the tool doesn't handle (formatters often have `--ignore-unknown`; if not, guard by extension)
   - Stays RAW for now — no `|| true`, no stderr suppression. You'll wrap it after the pipe-test passes.

3. **Pipe-test the raw command.** Synthesize the stdin payload the hook will receive and pipe it directly:
   - `Pre|PostToolUse` on `Write|Edit`: `echo '{"tool_name":"Edit","tool_input":{"file_path":"<a real file from this repo>"}}' | <cmd>`
   - `Pre|PostToolUse` on `Bash`: `echo '{"tool_name":"Bash","tool_input":{"command":"ls"}}' | <cmd>`
   - `Stop`/`UserPromptSubmit`/`SessionStart`: most commands don't read stdin, so `echo '{}' | <cmd>` suffices

   Check exit code AND side effect (file actually formatted, test actually ran). If it fails you get a real error — fix (wrong package manager? tool not installed? jq path wrong?) and retest. Once it works, wrap with `2>/dev/null || true` (unless the user wants a blocking check).

4. **Write the JSON.** Merge into the target file (schema shape in the "Hook Structure" section above). If this creates `.claude/settings.local.json` for the first time, add it to .gitignore — the Write tool doesn't auto-gitignore it.

5. **Validate syntax + schema in one shot:**

   `jq -e '.hooks.<event>[] | select(.matcher == "<matcher>") | .hooks[] | select(.type == "command") | .command' <target-file>`

   Exit 0 + prints your command = correct. Exit 4 = matcher doesn't match. Exit 5 = malformed JSON or wrong nesting. A broken settings.json silently disables ALL settings from that file — fix any pre-existing malformation too.

6. **Prove the hook fires** — only for `Pre|PostToolUse` on a matcher you can trigger in-turn (`Write|Edit` via Edit, `Bash` via Bash). `Stop`/`UserPromptSubmit`/`SessionStart` fire outside this turn — skip to step 7.

   For a **formatter** on `PostToolUse`/`Write|Edit`: introduce a detectable violation via Edit (two consecutive blank lines, bad indentation, missing semicolon — something this formatter corrects; NOT trailing whitespace, Edit strips that before writing), re-read, confirm the hook **fixed** it. For **anything else**: temporarily prefix the command in settings.json with `echo "$(date) hook fired" >> /tmp/claude-hook-check.txt; `, trigger the matching tool (Edit for `Write|Edit`, a harmless `true` for `Bash`), read the sentinel file.

   **Always clean up** — revert the violation, strip the sentinel prefix — whether the proof passed or failed.

   **If proof fails but pipe-test passed and `jq -e` passed**: the settings watcher isn't watching `.claude/` — it only watches directories that had a settings file when this session started. The hook is written correctly. Tell the user to open `/hooks` once (reloads config) or restart — you can't do this yourself; `/hooks` is a user UI menu and opening it ends this turn.

7. **Handoff.** Tell the user the hook is live (or needs `/hooks`/restart per the watcher caveat). Point them at `/hooks` to review, edit, or disable it later. The UI only shows "Ran N hooks" if a hook errors or is slow — silent success is invisible by design.


## Example Workflows

### Adding a Hook

User: "Format my code after Claude writes it"

1. **Clarify**: Which formatter? (prettier, gofmt, etc.)
2. **Read**: `.claude/settings.json` (or create if missing)
3. **Merge**: Add to existing hooks, don't replace
4. **Result**:
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "jq -r '.tool_response.filePath // .tool_input.file_path' | { read -r f; prettier --write \"$f\"; } 2>/dev/null || true"
      }]
    }]
  }
}
```

### Adding Permissions

User: "Allow npm commands without prompting"

1. **Read**: Existing permissions
2. **Merge**: Add `Bash(npm *)` to allow array
3. **Result**: Combined with existing allows

### Environment Variables

User: "Set DEBUG=true"

1. **Decide**: User settings (global) or project settings?
2. **Read**: Target file
3. **Merge**: Add to env object
```json
{ "env": { "DEBUG": "true" } }
```

## Common Mistakes to Avoid

1. **Replacing instead of merging** - Always preserve existing settings
2. **Wrong file** - Ask user if scope is unclear
3. **Invalid JSON** - Validate syntax after changes
4. **Forgetting to read first** - Always read before write

## Troubleshooting Hooks

If a hook isn't running:
1. **Check the settings file** - Read ~/.claude/settings.json or .claude/settings.json
2. **Verify JSON syntax** - Invalid JSON silently fails
3. **Check the matcher** - Does it match the tool name? (e.g., "Bash", "Write", "Edit")
4. **Check hook type** - Is it "command", "prompt", or "agent"?
5. **Test the command** - Run the hook command manually to see if it works
6. **Use --debug** - Run `claude --debug` to see hook execution logs


## Full Settings JSON Schema

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "properties": {
    "$schema": {
      "description": "JSON Schema reference for Claude Code settings",
      "type": "string"
    },
    "apiKeyHelper": {
      "description": "Path to a script that outputs authentication values",
      "type": "string"
    },
    "proxyAuthHelper": {
      "description": "Shell command that outputs a Proxy-Authorization header value (EAP)",
      "type": "string"
    },
    "awsCredentialExport": {
      "description": "Path to a script that exports AWS credentials",
      "type": "string"
    },
    "awsAuthRefresh": {
      "description": "Path to a script that refreshes AWS authentication",
      "type": "string"
    },
    "gcpAuthRefresh": {
      "description": "Command to refresh GCP authentication (e.g., gcloud auth application-default login)",
      "type": "string"
    },
    "policyHelper": {
      "description": "Executable that computes managed settings at startup. Honored only from admin-controlled policy sources.",
      "type": "object",
      "properties": {
        "path": {
          "description": "Absolute path to the helper executable",
          "type": "string"
        },
        "timeoutMs": {
          "type": "integer",
          "minimum": 1000,
          "maximum": 9007199254740991
        },
        "refreshIntervalMs": {
          "anyOf": [
            {
              "type": "number",
              "const": 0
            },
            {
              "type": "integer",
              "minimum": 60000,
              "maximum": 9007199254740991
            }
          ]
        }
      },
      "required": [
        "path"
      ]
    },
    "fileSuggestion": {
      "description": "Custom file suggestion configuration for @ mentions",
      "type": "object",
      "properties": {
        "type": {
          "type": "string",
          "const": "command"
        },
        "command": {
          "type": "string"
        }
      },
      "required": [
        "type",
        "command"
      ]
    },
    "respectGitignore": {
      "description": "Whether file picker should respect .gitignore files (default: true). Note: .ignore files are always respected.",
      "type": "boolean"
    },
    "breakReminder": {
      "description": "@internal Opt-in break reminder. When enabled, shows a dismissible nudge after sustained continuous use. Never blocks — just a friendly heads-up.",
      "type": "object",
      "properties": {
        "enabled": {
          "description": "Show a friendly nudge after sustained continuous use (default false). Must be true for the reminder to fire.",
          "type": "boolean"
        },
        "intervalMinutes": {
          "description": "Minutes of continuous use before the reminder fires (default 120). Re-fires every interval until you take a break.",
          "type": "integer",
          "exclusiveMinimum": 0,
          "maximum": 9007199254740991
        },
        "breakThresholdMinutes": {
          "description": "Minutes of inactivity that count as a break and reset the timer (default 15)",
          "type": "integer",
          "exclusiveMinimum": 0,
          "maximum": 9007199254740991
        },
        "message": {
          "description": "Custom reminder text. Leave unset for a rotating set of friendly nudges.",
          "type": "string"
        }
      }
    },
    "quietHours": {
      "description": "@internal Opt-in quiet hours. When enabled, shows a single soft nudge per session while inside the configured local-time window. Never blocks.",
      "type": "object",
      "properties": {
        "enabled": {
          "description": "Show a one-time nudge when you start or keep using the CLI inside your quiet-hours window (default false).",
          "type": "boolean"
        },
        "start": {
          "description": "Start of the quiet-hours window, 24-hour local time \"HH:MM\".",
          "type": "string",
          "pattern": "^([01]?\\d|2[0-3]):[0-5]\\d$"
        },
        "end": {
          "description": "End of the quiet-hours window, 24-hour local time \"HH:MM\". May be earlier than start for an overnight range.",
          "type": "string",
          "pattern": "^([01]?\\d|2[0-3]):[0-5]\\d$"
        }
      }
    },
    "cleanupPeriodDays": {
      "description": "Number of days to retain chat transcripts before automatic cleanup (default: 30). Minimum 1. Use a large value for long retention; use --no-session-persistence to disable transcript writes entirely.",
      "type": "integer",
      "exclusiveMinimum": 0,
      "maximum": 9007199254740991
    },
    "skillListingMaxDescChars": {
      "description": "Per-skill description character cap in the skill listing sent to Claude (default: 1536). Descriptions longer than this are truncated. Raise to opt in to higher per-turn context cost.",
      "type": "integer",
      "exclusiveMinimum": 0,
      "maximum": 9007199254740991
    },
    "skillListingBudgetFraction": {
      "description": "Fraction of the context window (in characters) reserved for the skill listing sent to Claude (default: 0.01 = 1%). When the listing exceeds this, descriptions are shortened to fit. Raise to opt in to higher per-turn context cost.",
      "type": "number",
      "exclusiveMinimum": 0,
      "maximum": 1
    },
    "wslInheritsWindowsSettings": {
      "description": "When set to true in either admin-only Windows source — the HKLM SOFTWARE/Policies/ClaudeCode registry key or C:/Program Files/ClaudeCode/managed-settings.json — WSL reads managed settings from the full Windows policy chain (HKLM, C:/Program Files/ClaudeCode via DrvFs, HKCU) in addition to /etc/claude-code. Windows sources take priority. The flag is also required in HKCU itself for HKCU policy to apply on WSL (double opt-in: admin enables the chain, user confirms HKCU). On native Windows the flag has no effect.",
      "type": "boolean"
    },
    "env": {
      "description": "Environment variables to set for Claude Code sessions",
      "type": "object",
      "propertyNames": {
        "type": "string"
      },
      "additionalProperties": {
        "type": "string"
      }
    },
    "attribution": {
      "description": "Customize attribution text for commits and PRs. Each field defaults to the standard Claude Code attribution if not set.",
      "type": "object",
      "properties": {
        "commit": {
          "description": "Attribution text for git commits, including any trailers. Empty string hides attribution.",
          "type": "string"
        },
        "pr": {
          "description": "Attribution text for pull request descriptions. Empty string hides attribution.",
          "type": "string"
        },
        "sessionUrl": {
          "description": "Whether to append the claude.ai session link to commits and PRs created from web or Remote Control sessions (default: true). Set to false to omit the Claude-Session trailer and PR-body link.",
          "type": "boolean"
        }
      }
    },
    "includeCoAuthoredBy": {
      "description": "Deprecated: Use attribution instead. Whether to include Claude's co-authored by attribution in commits and PRs (defaults to true)",
      "type": "boolean"
    },
    "includeGitInstructions": {
      "description": "Include built-in commit and PR workflow instructions in Claude's system prompt (default: true)",
      "type": "boolean"
    },
    "permissions": {
      "description": "Tool usage permissions configuration",
      "type": "object",
      "properties": {
        "allow": {
          "description": "List of permission rules for allowed operations",
          "type": "array",
          "items": {
            "type": "string"
          }
        },
        "deny": {
          "description": "List of permission rules for denied operations",
          "type": "array",
          "items": {
            "type": "string"
          }
        },
        "ask": {
          "description": "List of permission rules that should always prompt for confirmation",
          "type": "array",
          "items": {
            "type": "string"
          }
        },
        "defaultMode": {
          "description": "Default permission mode when Claude Code needs access ('manual' is accepted as an alias for 'default')",
          "type": "string",
          "enum": [
            "acceptEdits",
            "auto",
            "bypassPermissions",
            "default",
            "dontAsk",
            "plan"
          ]
        },
        "disableBypassPermissionsMode": {
          "description": "Disable the ability to bypass permission prompts",
          "type": "string",
          "enum": [
            "disable"
          ]
        },
        "disableAutoMode": {
          "description": "Disable auto mode",
          "type": "string",
          "enum": [
            "disable"
          ]
        },
        "additionalDirectories": {
          "description": "Additional directories to include in the permission scope",
          "type": "array",
          "items": {
            "type": "string"
          }
        }
      },
      "additionalProperties": {}
    },
    "model": {
      "description": "Override the default model used by Claude Code",
      "type": "string"
    },
    "fallbackModel": {
      "description": "Fallback model(s) tried in order when the primary model is overloaded or unavailable. Each element accepts a model name or alias; \"default\" expands to the default model. CLI --fallback-model takes precedence.",
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "availableModels": {
      "description": "Allowlist of models that users can select. Accepts family aliases (\"opus\" allows any opus version), version prefixes (\"opus-4-5\" allows only that version), and full model IDs. If undefined, all models are available. If empty array, only the default model is available. Typically set in managed settings by enterprise administrators.",
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "enforceAvailableModels": {
      "description": "When true and availableModels is a non-empty array, the Default model selection is also constrained: if the default model for the user tier is not in availableModels, Default resolves to the first allowed availableModels entry instead. Has no effect when availableModels is unset or an empty array. Typically set in managed settings by enterprise administrators.",
      "type": "boolean"
    },
    "modelOverrides": {
      "description": "Override mapping from Anthropic model ID (e.g. \"claude-opus-4-6\") to provider-specific model ID (e.g. a Bedrock inference profile ARN). Typically set in managed settings by enterprise administrators.",
      "type": "object",
      "propertyNames": {
        "type": "string"
      },
      "additionalProperties": {
        "type": "string"
      }
    },
    "enableAllProjectMcpServers": {
      "description": "Whether to automatically approve all MCP servers in the project",
      "type": "boolean"
    },
    "enabledMcpjsonServers": {
      "description": "List of approved MCP servers from .mcp.json",
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "disabledMcpjsonServers": {
      "description": "List of rejected MCP servers from .mcp.json",
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "disableClaudeAiConnectors": {
      "description": "When true in any settings source, claude.ai MCP cloud connectors are not auto-fetched or connected. Only gates auto-fetched connectors — a claudeai-proxy server passed explicitly (e.g. via --mcp-config or the SDK mcpServers option) still follows the normal MCP config trust flow. Any-source-true wins: a project can opt out, but a project-level false cannot override a user-level true.",
      "type": "boolean"
    },
    "skillOverrides": {
      "description": "Per-skill listing overrides keyed by skill name. \"name-only\" lists the skill without its description; \"user-invocable-only\" hides it from the model but keeps /name; \"off\" hides it from both. Absent = on.",
      "type": "object",
      "propertyNames": {
        "type": "string"
      },
      "additionalProperties": {
        "type": "string",
        "enum": [
          "on",
          "name-only",
          "user-invocable-only",
          "off"
        ]
      }
    },
    "disableBundledSkills": {
      "description": "Disable the skills and workflows that ship with Claude Code: bundled skills and workflows are removed entirely; built-in slash commands stay typable but are hidden from the model. Plugins, .claude/skills/, and .claude/commands/ are unaffected. Equivalent to CLAUDE_CODE_DISABLE_BUNDLED_SKILLS=1.",
      "type": "boolean"
    },
    "allowedMcpServers": {
      "description": "Enterprise allowlist of MCP servers that can be used. Applies to all scopes including enterprise servers from managed-mcp.json. If undefined, all servers are allowed. If empty array, no servers are allowed. Denylist takes precedence - if a server is on both lists, it is denied.",
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "serverName": {
            "description": "Name of the MCP server that users are allowed to configure",
            "type": "string",
            "pattern": "^[a-zA-Z0-9_-]+$"
          },
          "serverCommand": {
            "description": "Command array [command, ...args] to match exactly for allowed stdio servers",
            "minItems": 1,
            "type": "array",
            "items": {
              "type": "string"
            }
          },
          "serverUrl": {
            "description": "URL pattern with wildcard support (e.g., \"https://*.example.com/*\") for allowed remote MCP servers",
            "type": "string"
          }
        }
      }
    },
    "deniedMcpServers": {
      "description": "Enterprise denylist of MCP servers that are explicitly blocked. If a server is on the denylist, it will be blocked across all scopes including enterprise. Denylist takes precedence over allowlist - if a server is on both lists, it is denied.",
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "serverName": {
            "description": "Name of the MCP server that is explicitly blocked",
            "type": "string",
            "minLength": 1
          },
          "serverCommand": {
            "description": "Command array [command, ...args] to match exactly for blocked stdio servers",
            "minItems": 1,
            "type": "array",
            "items": {
              "type": "string"
            }
          },
          "serverUrl": {
            "description": "URL pattern with wildcard support (e.g., \"https://*.example.com/*\") for blocked remote MCP servers",
            "type": "string"
          }
        }
      }
    },
    "hooks": {
      "description": "Custom commands to run before/after tool executions",
      "type": "object",
      "propertyNames": {
        "anyOf": [
          {
            "type": "string",
            "enum": [
              "PreToolUse",
              "PostToolUse",
              "PostToolUseFailure",
              "PostToolBatch",
              "Notification",
              "UserPromptSubmit",
              "UserPromptExpansion",
              "SessionStart",
              "SessionEnd",
              "Stop",
              "StopFailure",
              "SubagentStart",
              "SubagentStop",
              "PreCompact",
              "PostCompact",
              "PermissionRequest",
              "PermissionDenied",
              "Setup",
              "TeammateIdle",
              "TaskCreated",
              "TaskCompleted",
              "Elicitation",
              "ElicitationResult",
              "ConfigChange",
              "WorktreeCreate",
              "WorktreeRemove",
              "InstructionsLoaded",
              "CwdChanged",
              "FileChanged",
              "MessageDisplay"
            ]
          },
          {
            "not": {}
          }
        ]
      },
      "additionalProperties": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "matcher": {
              "description": "String pattern to match (e.g. tool names like \"Write\")",
              "type": "string"
            },
            "hooks": {
              "description": "List of hooks to execute when the matcher matches",
              "type": "array",
              "items": {
                "anyOf": [
                  {
                    "type": "object",
                    "properties": {
                      "type": {
                        "description": "Shell command hook type",
                        "type": "string",
                        "const": "command"
                      },
                      "command": {
                        "description": "Shell command to execute",
                        "type": "string"
                      },
                      "args": {
                        "description": "Argument list for exec form. When present, `command` is resolved as an executable and spawned directly with these arguments — no shell. Path placeholders like ${CLAUDE_PLUGIN_ROOT} are substituted per-element as plain strings, so paths with quotes, $, or backticks never reach a shell parser. When absent, `command` runs through a shell (bash on POSIX, PowerShell on Windows without Git Bash).",
                        "type": "array",
                        "items": {
                          "type": "string"
                        }
                      },
                      "if": {
                        "description": "Permission rule syntax to filter when this hook runs (e.g., \"Bash(git *)\"). Only runs if the tool call matches the pattern. Avoids spawning hooks for non-matching commands.",
                        "type": "string"
                      },
                      "shell": {
                        "description": "Shell interpreter. 'bash' uses your $SHELL (bash/zsh/sh); 'powershell' uses pwsh. Defaults to bash (powershell on Windows without Git Bash).",
                        "type": "string",
                        "enum": [
                          "bash",
                          "powershell"
                        ]
                      },
                      "timeout": {
                        "description": "Timeout in seconds for this specific command",
                        "type": "number",
                        "exclusiveMinimum": 0
                      },
                      "statusMessage": {
                        "description": "Custom status message to display in spinner while hook runs",
                        "type": "string"
                      },
                      "once": {
                        "description": "If true, hook runs once and is removed after execution",
                        "type": "boolean"
                      },
                      "async": {
                        "description": "If true, hook runs in background without blocking",
                        "type": "boolean"
                      },
                      "asyncRewake": {
                        "description": "If true, hook runs in background and wakes the model on exit code 2 (blocking error). Implies async.",
                        "type": "boolean"
                      },
                      "rewakeMessage": {
                        "description": "@internal Custom prefix for the system-reminder shown to the model when an asyncRewake hook exits with code 2. The hook output is appended after this prefix.",
                        "type": "string",
                        "minLength": 1
                      },
                      "rewakeSummary": {
                        "description": "@internal One-line summary shown to the user in the terminal when an asyncRewake hook exits with code 2. Defaults to \"Stop hook feedback\".",
                        "type": "string",
                        "minLength": 1
                      }
                    },
                    "required": [
                      "type",
                      "command"
                    ]
                  },
                  {
                    "type": "object",
                    "properties": {
                      "type": {
                        "description": "LLM prompt hook type",
                        "type": "string",
                        "const": "prompt"
                      },
                      "prompt": {
                        "description": "Prompt to evaluate with LLM. Use $ARGUMENTS placeholder for hook input JSON.",
                        "type": "string"
                      },
                      "if": {
                        "description": "Permission rule syntax to filter when this hook runs (e.g., \"Bash(git *)\"). Only runs if the tool call matches the pattern. Avoids spawning hooks for non-matching commands.",
                        "type": "string"
                      },
                      "timeout": {
                        "description": "Timeout in seconds for this specific prompt evaluation",
                        "type": "number",
                        "exclusiveMinimum": 0
                      },
                      "model": {
                        "description": "Model to use for this prompt hook (e.g., \"claude-sonnet-5\"). If not specified, uses the default small fast model.",
                        "type": "string"
                      },
                      "continueOnBlock": {
                        "description": "Sets the continue value for the decision:\"block\" produced when ok is false. Default false (turn ends). Whether continue:true lets the turn proceed depends on the event's decision:\"block\" semantics. On PostToolUse, the reason is fed back to Claude and the turn continues.",
                        "type": "boolean"
                      },
                      "statusMessage": {
                        "description": "Custom status message to display in spinner while hook runs",
                        "type": "string"
                      },
                      "once": {
                        "description": "If true, hook runs once and is removed after execution",
                        "type": "boolean"
                      }
                    },
                    "required": [
                      "type",
                      "prompt"
                    ]
                  },
                  {
                    "type": "object",
                    "properties": {
                      "type": {
                        "description": "Agentic verifier hook type",
                        "type": "string",
                        "const": "agent"
                      },
                      "prompt": {
                        "description": "Prompt describing what to verify (e.g. \"Verify that unit tests ran and passed.\"). Use $ARGUMENTS placeholder for hook input JSON.",
                        "type": "string"
                      },
                      "if": {
                        "description": "Permission rule syntax to filter when this hook runs (e.g., \"Bash(git *)\"). Only runs if the tool call matches the pattern. Avoids spawning hooks for non-matching commands.",
                        "type": "string"
                      },
                      "timeout": {
                        "description": "Timeout in seconds for agent execution (default 60)",
                        "type": "number",
                        "exclusiveMinimum": 0
                      },
                      "model": {
                        "description": "Model to use for this agent hook (e.g., \"claude-sonnet-5\"). If not specified, uses Haiku.",
                        "type": "string"
                      },
                      "statusMessage": {
                        "description": "Custom status message to display in spinner while hook runs",
                        "type": "string"
                      },
                      "once": {
                        "description": "If true, hook runs once and is removed after execution",
                        "type": "boolean"
                      }
                    },
                    "required": [
                      "type",
                      "prompt"
                    ]
                  },
                  {
                    "type": "object",
                    "properties": {
                      "type": {
                        "description": "HTTP hook type",
                        "type": "string",
                        "const": "http"
                      },
                      "url": {
                        "description": "URL to POST the hook input JSON to",
                        "type": "string",
                        "format": "uri"
                      },
                      "if": {
                        "description": "Permission rule syntax to filter when this hook runs (e.g., \"Bash(git *)\"). Only runs if the tool call matches the pattern. Avoids spawning hooks for non-matching commands.",
                        "type": "string"
                      },
                      "timeout": {
                        "description": "Timeout in seconds for this specific request",
                        "type": "number",
                        "exclusiveMinimum": 0
                      },
                      "headers": {
                        "description": "Additional headers to include in the request. Values may reference environment variables using $VAR_NAME or ${VAR_NAME} syntax (e.g., \"Authorization\": \"Bearer $MY_TOKEN\"). Only variables listed in allowedEnvVars will be interpolated.",
                        "type": "object",
                        "propertyNames": {
                          "type": "string"
                        },
                        "additionalProperties": {
                          "type": "string"
                        }
                      },
                      "allowedEnvVars": {
                        "description": "Explicit list of environment variable names that may be interpolated in header values. Only variables listed here will be resolved; all other $VAR references are left as empty strings. Required for env var interpolation to work.",
                        "type": "array",
                        "items": {
                          "type": "string"
                        }
                      },
                      "statusMessage": {
                        "description": "Custom status message to display in spinner while hook runs",
                        "type": "string"
                      },
                      "once": {
                        "description": "If true, hook runs once and is removed after execution",
                        "type": "boolean"
                      }
                    },
                    "required": [
                      "type",
                      "url"
                    ]
                  },
                  {
                    "type": "object",
                    "properties": {
                      "type": {
                        "description": "MCP tool hook type",
                        "type": "string",
                        "const": "mcp_tool"
                      },
                      "server": {
                        "description": "Name of an already-configured MCP server to invoke",
                        "type": "string"
                      },
                      "tool": {
                        "description": "Name of the tool on that server to call",
                        "type": "string"
                      },
                      "input": {
                        "description": "Arguments passed to the MCP tool. String values support ${path} interpolation from the hook input JSON (e.g. \"${tool_input.file_path}\").",
                        "type": "object",
                        "propertyNames": {
                          "type": "string"
                        },
                        "additionalProperties": {}
                      },
                      "if": {
                        "description": "Permission rule syntax to filter when this hook runs (e.g., \"Bash(git *)\"). Only runs if the tool call matches the pattern. Avoids spawning hooks for non-matching commands.",
                        "type": "string"
                      },
                      "timeout": {
                        "description": "Timeout in seconds for this specific tool call",
                        "type": "number",
                        "exclusiveMinimum": 0
                      },
                      "statusMessage": {
                        "description": "Custom status message to display in spinner while hook runs",
                        "type": "string"
                      },
                      "once": {
                        "description": "If true, hook runs once and is removed after execution",
                        "type": "boolean"
                      }
                    },
                    "required": [
                      "type",
                      "server",
                      "tool"
                    ]
                  }
                ]
              }
            }
          },
          "required": [
            "hooks"
          ]
        }
      }
    },
    "worktree": {
      "description": "Git worktree configuration for --worktree flag.",
      "type": "object",
      "properties": {
        "symlinkDirectories": {
          "description": "Directories to symlink from main repository to worktrees to avoid disk bloat. Must be explicitly configured - no directories are symlinked by default. Common examples: \"node_modules\", \".cache\", \".bin\"",
          "type": "array",
          "items": {
            "type": "string"
          }
        },
        "sparsePaths": {
          "description": "Directories to include when creating worktrees, via git sparse-checkout (cone mode). Dramatically faster in large monorepos — only the listed paths are written to disk.",
          "type": "array",
          "items": {
            "type": "string"
          }
        },
        "baseRef": {
          "description": "Which ref new worktrees branch from. 'fresh' (default) branches from origin/<default-branch> for a clean tree. 'head' branches from your current local HEAD so unpushed commits and feature-branch state are present. Applies to --worktree, EnterWorktree, and agent isolation.",
          "type": "string",
          "enum": [
            "fresh",
            "head"
          ]
        },
        "bgIsolation": {
          "description": "Isolation mode for background sessions in this repo. 'worktree' (default) blocks Edit/Write in the main checkout until EnterWorktree is called. 'none' lets background jobs edit the working copy directly.",
          "type": "string",
          "enum": [
            "worktree",
            "none"
          ]
        }
      }
    },
    "disableAllHooks": {
      "description": "Disable all hooks and statusLine execution",
      "type": "boolean"
    },
    "disableAgentView": {
      "description": "Disable agent view (`claude agents`, `--bg`, /background, the on-demand daemon). Typically set in managed settings. Equivalent to CLAUDE_CODE_DISABLE_AGENT_VIEW=1.",
      "type": "boolean"
    },
    "disableRemoteControl": {
      "description": "Disable Remote Control (claude.ai/code, `claude remote-control`, `--remote-control`/`--rc`, auto-start, and the in-session toggle). Typically set in managed settings.",
      "type": "boolean"
    },
    "disableWorkflows": {
      "description": "Disable the Workflows feature (also via CLAUDE_CODE_DISABLE_WORKFLOWS).",
      "type": "boolean"
    },
    "disableArtifact": {
      "description": "Disable the Artifact tool (also via CLAUDE_CODE_DISABLE_ARTIFACT).",
      "type": "boolean"
    },
    "enableArtifact": {
      "description": "Enable or disable the Artifact tool for this user. Unset defaults to enabled once the feature is available.",
      "type": "boolean"
    },
    "enableWorkflows": {
      "description": "Enable or disable the Workflows feature for this user. Unset = default by plan once the feature is available.",
      "type": "boolean"
    },
    "workflowKeywordTriggerEnabled": {
      "description": "Enable the \"ultracode\" keyword trigger: including the keyword in a prompt opts that turn into the Workflow tool. Set to false to disable the trigger. Default: true.",
      "type": "boolean"
    },
    "disableSkillShellExecution": {
      "description": "Disable inline shell execution in skills and custom slash commands from user, project, or plugin sources. Commands are replaced with a placeholder instead of being run.",
      "type": "boolean"
    },
    "defaultShell": {
      "description": "Default shell for input-box ! commands. Defaults to 'bash' on all platforms (no Windows auto-flip).",
      "type": "string",
      "enum": [
        "bash",
        "powershell"
      ]
    },
    "respondToBashCommands": {
      "description": "Whether Claude responds after an input-box ! bash command runs. Set to false to add the command output to context without a response. Default: true.",
      "type": "boolean"
    },
    "allowManagedHooksOnly": {
      "description": "When true (and set in managed settings), only hooks from managed settings run. User, project, and local hooks are ignored.",
      "type": "boolean"
    },
    "allowedHttpHookUrls": {
      "description": "Allowlist of URL patterns that HTTP hooks may target. Supports * as a wildcard (e.g. \"https://hooks.example.com/*\"). When set, HTTP hooks with non-matching URLs are blocked. If undefined, all URLs are allowed. If empty array, no HTTP hooks are allowed. Arrays merge across settings sources (same semantics as allowedMcpServers).",
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "httpHookAllowedEnvVars": {
      "description": "Allowlist of environment variable names HTTP hooks may interpolate into headers. When set, each hook's effective allowedEnvVars is the intersection with this list. If undefined, no restriction is applied. Arrays merge across settings sources (same semantics as allowedMcpServers).",
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "allowManagedPermissionRulesOnly": {
      "description": "When true (and set in managed settings), only permission rules (allow/deny/ask) from managed settings are respected. User, project, local, and CLI argument permission rules are ignored.",
      "type": "boolean"
    },
    "allowManagedMcpServersOnly": {
      "description": "When true (and set in managed settings), allowedMcpServers is only read from managed settings. deniedMcpServers still merges from all sources, so users can deny servers for themselves. Users can still add their own MCP servers, but only the admin-defined allowlist applies.",
      "type": "boolean"
    },
    "allowAllClaudeAiMcps": {
      "description": "When true (and set in managed settings), claude.ai cloud MCP connectors load alongside managed-mcp.json instead of being suppressed by its exclusive-control lockdown. Default off preserves the lockdown. Read from managed settings only.",
      "type": "boolean"
    },
    "strictPluginOnlyCustomization": {
      "description": "When set in managed settings, blocks non-plugin customization sources for the listed surfaces. Array form locks specific surfaces (e.g. [\"skills\", \"hooks\"]); `true` locks all four; `false` is an explicit no-op. Blocked: ~/.claude/{surface}/, .claude/{surface}/ (project), settings.json hooks, .mcp.json. NOT blocked: managed (policySettings) sources, plugin-provided customizations. Composes with strictKnownMarketplaces for end-to-end admin control — plugins gated by marketplace allowlist, everything else blocked here.",
      "anyOf": [
        {
          "type": "boolean"
        },
        {
          "type": "array",
          "items": {
            "type": "string",
            "enum": [
              "skills",
              "agents",
              "hooks",
              "mcp"
            ]
          }
        }
      ]
    },
    "statusLine": {
      "description": "Custom status line display configuration",
      "type": "object",
      "properties": {
        "type": {
          "type": "string",
          "const": "command"
        },
        "command": {
          "type": "string"
        },
        "padding": {
          "type": "number"
        },
        "refreshInterval": {
          "description": "Re-run the status line command every N seconds in addition to event-driven updates",
          "type": "number",
          "minimum": 1
        },
        "hideVimModeIndicator": {
          "description": "Hide the built-in `-- INSERT --` / `-- VISUAL --` indicator below the prompt. Use this when your status line script renders `vim.mode` itself.",
          "type": "boolean"
        }
      },
      "required": [
        "type",
        "command"
      ]
    },
    "prUrlTemplate": {
      "description": "URL template for PR links in the footer link badges and inline messages. The detected git PR is rendered as the first footer-link badge. Placeholders: {host} {owner} {repo} {number} {url}. Example: \"https://reviews.example.com/{owner}/{repo}/pull/{number}\"",
      "type": "string"
    },
    "footerLinksRegexes": {
      "description": "Extra clickable footer badges that appear when a regex matches turn output (tool results and assistant responses). Read from user, flag, and managed settings only; ignored in project .claude/settings.json and local .claude/settings.local.json. At most 5 badges render; the oldest is displaced by newer matches and /clear removes them. Use to surface IDs printed by project CLIs as session links.",
      "type": "array",
      "items": {
        "default": {
          "type": "invalid-entry-stripped"
        },
        "anyOf": [
          {
            "type": "object",
            "properties": {
              "type": {
                "description": "Config variant. This client understands \"regex\": matches turn output and builds a URL from named capture groups. Entries with other variants are preserved but skipped at runtime.",
                "type": "string",
                "const": "regex"
              },
              "pattern": {
                "description": "Regex matched against turn output (tool results and assistant text)",
                "type": "string"
              },
              "url": {
                "description": "Link target. {name} placeholders are filled from named regex capture groups, e.g. (?<id>...) -> {id}. Values are URL-encoded; the origin must be literal in the template. The scheme must be https, http, or a recognized editor or workspace deep-link scheme: vscode, vscode-insiders, cursor, windsurf, zed, jetbrains, idea, slack, linear, notion, figma.",
                "type": "string"
              },
              "label": {
                "description": "Badge text. {name} placeholders filled from named capture groups; defaults to the full match.",
                "type": "string"
              }
            },
            "required": [
              "type",
              "pattern",
              "url"
            ],
            "additionalProperties": {}
          },
          {
            "type": "object",
            "properties": {
              "type": {
                "description": "Config variant discriminator for entries this client does not understand; the entry is preserved as-is and skipped at runtime.",
                "type": "string"
              }
            },
            "required": [
              "type"
            ],
            "additionalProperties": {}
          }
        ]
      }
    },
    "subagentStatusLine": {
      "description": "Custom per-subagent status line shown in the agent panel; receives row context as JSON on stdin",
      "type": "object",
      "properties": {
        "type": {
          "type": "string",
          "const": "command"
        },
        "command": {
          "type": "string"
        }
      },
      "required": [
        "type",
        "command"
      ]
    },
    "enabledPlugins": {
      "description": "Enabled plugins using plugin-id@marketplace-id format. Example: { \"formatter@anthropic-tools\": true }. Also supports extended format with version constraints. Settings precedence is user < project < local < flag < policy, so to disable a plugin that project settings enable, set it to false in .claude/settings.local.json — setting false in ~/.claude/settings.json is overridden by the project.",
      "type": "object",
      "propertyNames": {
        "type": "string"
      },
      "additionalProperties": {
        "anyOf": [
          {
            "type": "array",
            "items": {
              "type": "string"
            }
          },
          {
            "type": "boolean"
          },
          {
            "not": {}
          }
        ]
      }
    },
    "extraKnownMarketplaces": {
      "description": "Additional marketplaces to make available for this repository. Typically used in repository .claude/settings.json to ensure team members have required plugin sources.",
      "type": "object",
      "propertyNames": {
        "type": "string"
      },
      "additionalProperties": {
        "type": "object",
        "properties": {
          "source": {
            "description": "Where to fetch the marketplace from",
            "anyOf": [
              {
                "type": "object",
                "properties": {
                  "source": {
                    "type": "string",
                    "const": "url"
                  },
                  "url": {
                    "description": "Direct URL to marketplace.json file",
                    "type": "string",
                    "format": "uri"
                  },
                  "headers": {
                    "description": "Custom HTTP headers (e.g., for authentication)",
                    "type": "object",
                    "propertyNames": {
                      "type": "string"
                    },
                    "additionalProperties": {
                      "type": "string"
                    }
                  }
                },
                "required": [
                  "source",
                  "url"
                ]
              },
              {
                "type": "object",
                "properties": {
                  "source": {
                    "type": "string",
                    "const": "github"
                  },
                  "repo": {
                    "description": "GitHub repository in owner/repo format",
                    "type": "string"
                  },
                  "ref": {
                    "description": "Git branch or tag to use (e.g., \"main\", \"v1.0.0\"). Defaults to repository default branch.",
                    "type": "string"
                  },
                  "path": {
                    "description": "Path to marketplace.json within repo (defaults to .claude-plugin/marketplace.json)",
                    "type": "string"
                  },
                  "sparsePaths": {
                    "description": "Directories to include via git sparse-checkout (cone mode). Use for monorepos where the marketplace lives in a subdirectory. Example: [\".claude-plugin\", \"plugins\"]. If omitted, the full repository is cloned.",
                    "type": "array",
                    "items": {
                      "type": "string"
                    }
                  },
                  "skipLfs": {
                    "description": "Skip Git LFS smudge during clone and update (sets GIT_LFS_SKIP_SMUDGE=1) so LFS pointer files stay as pointers instead of downloading their content. Use for marketplaces hosted in repos with large LFS objects.",
                    "type": "boolean"
                  }
                },
                "required": [
                  "source",
                  "repo"
                ]
              },
              {
                "type": "object",
                "properties": {
                  "source": {
                    "type": "string",
                    "const": "git"
                  },
                  "url": {
                    "description": "Full git repository URL",
                    "type": "string"
                  },
                  "ref": {
                    "description": "Git branch or tag to use (e.g., \"main\", \"v1.0.0\"). Defaults to repository default branch.",
                    "type": "string"
                  },
                  "path": {
                    "description": "Path to marketplace.json within repo (defaults to .claude-plugin/marketplace.json)",
                    "type": "string"
                  },
                  "sparsePaths": {
                    "description": "Directories to include via git sparse-checkout (cone mode). Use for monorepos where the marketplace lives in a subdirectory. Example: [\".claude-plugin\", \"plugins\"]. If omitted, the full repository is cloned.",
                    "type": "array",
                    "items": {
                      "type": "string"
                    }
                  },
                  "skipLfs": {
                    "description": "Skip Git LFS smudge during clone and update (sets GIT_LFS_SKIP_SMUDGE=1) so LFS pointer files stay as pointers instead of downloading their content. Use for marketplaces hosted in repos with large LFS objects.",
                    "type": "boolean"
                  }
                },
                "required": [
                  "source",
                  "url"
                ]
              },
              {
                "type": "object",
                "properties": {
                  "source": {
                    "type": "string",
                    "const": "npm"
                  },
                  "package": {
                    "description": "NPM package containing marketplace.json",
                    "type": "string"
                  }
                },
                "required": [
                  "source",
                  "package"
                ]
              },
              {
                "type": "object",
                "properties": {
                  "source": {
                    "type": "string",
                    "const": "file"
                  },
                  "path": {
                    "description": "Local file path to marketplace.json",
                    "type": "string"
                  }
                },
                "required": [
                  "source",
                  "path"
                ]
              },
              {
                "type": "object",
                "properties": {
                  "source": {
                    "type": "string",
                    "const": "directory"
                  },
                  "path": {
                    "description": "Local directory containing .claude-plugin/marketplace.json",
                    "type": "string"
                  }
                },
                "required": [
                  "source",
                  "path"
                ]
              },
              {
                "description": "Policy-list sentinel for the ~/.claude/skills/ auto-load (@skills-dir plugins). In strictKnownMarketplaces: opt the scan back IN (by default any allowlist blocks it). In blockedMarketplaces: turn the scan OFF without otherwise restricting marketplaces. Only meaningful in those two managed-settings lists (areLocalPluginDirsAllowedByPolicy); known_marketplaces.json / marketplace add etc. ignore it.",
                "type": "object",
                "properties": {
                  "source": {
                    "type": "string",
                    "const": "skills-dir"
                  }
                },
                "required": [
                  "source"
                ]
              },
              {
                "type": "object",
                "properties": {
                  "source": {
                    "type": "string",
                    "const": "hostPattern"
                  },
                  "hostPattern": {
                    "description": "Regex pattern to match the host/domain extracted from any marketplace source type. For github sources, matches against github.com. For git sources (SSH or HTTPS), extracts the hostname from the URL. Use in strictKnownMarketplaces to allow all marketplaces from a specific host (e.g., \"^github\\.mycompany\\.com$\").",
                    "type": "string"
                  }
                },
                "required": [
                  "source",
                  "hostPattern"
                ]
              },
              {
                "type": "object",
                "properties": {
                  "source": {
                    "type": "string",
                    "const": "pathPattern"
                  },
                  "pathPattern": {
                    "description": "Regex pattern matched against the .path field of file and directory sources. Use in strictKnownMarketplaces to allow filesystem-based marketplaces alongside hostPattern restrictions for network sources. Use \".*\" to allow all filesystem paths, or a narrower pattern (e.g., \"^/opt/approved/\") to restrict to specific directories.",
                    "type": "string"
                  }
                },
                "required": [
                  "source",
                  "pathPattern"
                ]
              },
              {
                "description": "Inline marketplace manifest defined directly in settings.json. The reconciler writes a synthetic marketplace.json to the cache; diffMarketplaces detects edits via isEqual on the stored source (the plugins array is inside this object, so edits surface as sourceChanged).",
                "type": "object",
                "properties": {
                  "source": {
                    "type": "string",
                    "const": "settings"
                  },
                  "name": {
                    "description": "Marketplace name. Must match the extraKnownMarketplaces key (enforced); the synthetic manifest is written under this name. Same validation as PluginMarketplaceSchema plus reserved-name rejection — validateOfficialNameSource runs after the disk write, too late to clean up.",
                    "type": "string",
                    "minLength": 1
                  },
                  "plugins": {
                    "description": "Plugin entries declared inline in settings.json",
                    "type": "array",
                    "items": {
                      "type": "object",
                      "properties": {
                        "name": {
                          "description": "Plugin name as it appears in the target repository",
                          "type": "string",
                          "minLength": 1
                        },
                        "source": {
                          "description": "Where to fetch the plugin from. Must be a remote source — relative paths have no marketplace repository to resolve against.",
                          "anyOf": [
                            {
                              "description": "Path to the plugin root, relative to the marketplace root (the directory containing .claude-plugin/, not .claude-plugin/ itself)",
                              "type": "string",
                              "pattern": "^\\.\\/.*"
                            },
                            {
                              "description": "NPM package as plugin source",
                              "type": "object",
                              "properties": {
                                "source": {
                                  "type": "string",
                                  "const": "npm"
                                },
                                "package": {
                                  "description": "Package name (or url, or local path, or anything else that can be passed to `npm` as a package)",
                                  "anyOf": [
                                    {
                                      "type": "string"
                                    },
                                    {
                                      "type": "string"
                                    }
                                  ]
                                },
                                "version": {
                                  "description": "Specific version or version range (e.g., ^1.0.0, ~2.1.0)",
                                  "type": "string"
                                },
                                "registry": {
                                  "description": "Custom NPM registry URL (defaults to using system default, likely npmjs.org)",
                                  "type": "string",
                                  "format": "uri"
                                }
                              },
                              "required": [
                                "source",
                                "package"
                              ]
                            },
                            {
                              "type": "object",
                              "properties": {
                                "source": {
                                  "type": "string",
                                  "const": "url"
                                },
                                "url": {
                                  "description": "Full git repository URL (https:// or git@)",
                                  "type": "string"
                                },
                                "ref": {
                                  "description": "Git branch or tag to use (e.g., \"main\", \"v1.0.0\"). Defaults to repository default branch.",
                                  "type": "string"
                                },
                                "sha": {
                                  "description": "Specific commit SHA to use",
                                  "type": "string",
                                  "minLength": 40,
                                  "maxLength": 40,
                                  "pattern": "^[a-f0-9]{40}$"
                                }
                              },
                              "required": [
                                "source",
                                "url"
                              ]
                            },
                            {
                              "type": "object",
                              "properties": {
                                "source": {
                                  "type": "string",
                                  "const": "github"
                                },
                                "repo": {
                                  "description": "GitHub repository in owner/repo format",
                                  "type": "string"
                                },
                                "ref": {
                                  "description": "Git branch or tag to use (e.g., \"main\", \"v1.0.0\"). Defaults to repository default branch.",
                                  "type": "string"
                                },
                                "sha": {
                                  "description": "Specific commit SHA to use",
                                  "type": "string",
                                  "minLength": 40,
                                  "maxLength": 40,
                                  "pattern": "^[a-f0-9]{40}$"
                                }
                              },
                              "required": [
                                "source",
                                "repo"
                              ]
                            },
                            {
                              "description": "Plugin located in a subdirectory of a larger repository (monorepo). Only the specified subdirectory is materialized; the rest of the repo is not downloaded.",
                              "type": "object",
                              "properties": {
                                "source": {
                                  "type": "string",
                                  "const": "git-subdir"
                                },
                                "url": {
                                  "description": "Git repository: GitHub owner/repo shorthand, https://, or git@ URL",
                                  "type": "string"
                                },
                                "path": {
                                  "description": "Subdirectory within the repo containing the plugin (e.g., \"tools/claude-plugin\"). Cloned sparsely using partial clone (--filter=tree:0) to minimize bandwidth for monorepos.",
                                  "type": "string",
                                  "minLength": 1
                                },
                                "ref": {
                                  "description": "Git branch or tag to use (e.g., \"main\", \"v1.0.0\"). Defaults to repository default branch.",
                                  "type": "string"
                                },
                                "sha": {
                                  "description": "Specific commit SHA to use",
                                  "type": "string",
                                  "minLength": 40,
                                  "maxLength": 40,
                                  "pattern": "^[a-f0-9]{40}$"
                                }
                              },
                              "required": [
                                "source",
                                "url",
                                "path"
                              ]
                            },
                            {
                              "description": "Placeholder for source types this Claude Code version does not recognize. Never authored by hand — PluginMarketplaceSchema rewrites unparseable sources to this so the entry remains in marketplace.plugins (detectDelistedPlugins must not see it as removed). Install attempts fail at cachePlugin with a clear \"update Claude Code\" message.",
                              "type": "object",
                              "properties": {
                                "source": {
                                  "type": "string",
                                  "const": "unsupported"
                                }
                              },
                              "required": [
                                "source"
                              ]
                            }
                          ]
                        },
                        "description": {
                          "type": "string"
                        },
                        "version": {
                          "type": "string"
                        },
                        "strict": {
                          "type": "boolean"
                        }
                      },
                      "required": [
                        "name",
                        "source"
                      ]
                    }
                  },
                  "owner": {
                    "type": "object",
                    "properties": {
                      "name": {
                        "description": "Display name of the plugin author or organization",
                        "type": "string",
                        "minLength": 1
                      },
                      "email": {
                        "description": "Contact email for support or feedback",
                        "type": "string"
                      },
                      "url": {
                        "description": "Website, GitHub profile, or organization URL",
                        "type": "string"
                      }
                    },
                    "required": [
                      "name"
                    ]
                  }
                },
                "required": [
                  "source",
                  "name",
                  "plugins"
                ]
              }
            ]
          },
          "installLocation": {
            "description": "Local cache path where marketplace manifest is stored (auto-generated if not provided)",
            "type": "string"
          },
          "autoUpdate": {
            "description": "Whether to automatically update this marketplace and its installed plugins on startup",
            "type": "boolean"
          }
        },
        "required": [
          "source"
        ]
      }
    },
    "strictKnownMarketplaces": {
      "description": "Enterprise strict list of allowed marketplace sources. When set in managed settings, ONLY these exact sources can be added as marketplaces. The check happens BEFORE downloading, so blocked sources never touch the filesystem. Note: this is a policy gate only — it does NOT register marketplaces. To pre-register allowed marketplaces for users, also set extraKnownMarketplaces.",
      "type": "array",
      "items": {
        "anyOf": [
          {
            "type": "object",
            "properties": {
              "source": {
                "type": "string",
                "const": "url"
              },
              "url": {
                "description": "Direct URL to marketplace.json file",
                "type": "string",
                "format": "uri"
              },
              "headers": {
                "description": "Custom HTTP headers (e.g., for authentication)",
                "type": "object",
                "propertyNames": {
                  "type": "string"
                },
                "additionalProperties": {
                  "type": "string"
                }
              }
            },
            "required": [
              "source",
              "url"
            ]
          },
          {
            "type": "object",
            "properties": {
              "source": {
                "type": "string",
                "const": "github"
              },
              "repo": {
                "description": "GitHub repository in owner/repo format",
                "type": "string"
              },
              "ref": {
                "description": "Git branch or tag to use (e.g., \"main\", \"v1.0.0\"). Defaults to repository default branch.",
                "type": "string"
              },
              "path": {
                "description": "Path to marketplace.json within repo (defaults to .claude-plugin/marketplace.json)",
                "type": "string"
              },
              "sparsePaths": {
                "description": "Directories to include via git sparse-checkout (cone mode). Use for monorepos where the marketplace lives in a subdirectory. Example: [\".claude-plugin\", \"plugins\"]. If omitted, the full repository is cloned.",
                "type": "array",
                "items": {
                  "type": "string"
                }
              },
              "skipLfs": {
                "description": "Skip Git LFS smudge during clone and update (sets GIT_LFS_SKIP_SMUDGE=1) so LFS pointer files stay as pointers instead of downloading their content. Use for marketplaces hosted in repos with large LFS objects.",
                "type": "boolean"
              }
            },
            "required": [
              "source",
              "repo"
            ]
          },
          {
            "type": "object",
            "properties": {
              "source": {
                "type": "string",
                "const": "git"
              },
              "url": {
                "description": "Full git repository URL",
                "type": "string"
              },
              "ref": {
                "description": "Git branch or tag to use (e.g., \"main\", \"v1.0.0\"). Defaults to repository default branch.",
                "type": "string"
              },
              "path": {
                "description": "Path to marketplace.json within repo (defaults to .claude-plugin/marketplace.json)",
                "type": "string"
              },
              "sparsePaths": {
                "description": "Directories to include via git sparse-checkout (cone mode). Use for monorepos where the marketplace lives in a subdirectory. Example: [\".claude-plugin\", \"plugins\"]. If omitted, the full repository is cloned.",
                "type": "array",
                "items": {
                  "type": "string"
                }
              },
              "skipLfs": {
                "description": "Skip Git LFS smudge during clone and update (sets GIT_LFS_SKIP_SMUDGE=1) so LFS pointer files stay as pointers instead of downloading their content. Use for marketplaces hosted in repos with large LFS objects.",
                "type": "boolean"
              }
            },
            "required": [
              "source",
              "url"
            ]
          },
          {
            "type": "object",
            "properties": {
              "source": {
                "type": "string",
                "const": "npm"
              },
              "package": {
                "description": "NPM package containing marketplace.json",
                "type": "string"
              }
            },
            "required": [
              "source",
              "package"
            ]
          },
          {
            "type": "object",
            "properties": {
              "source": {
                "type": "string",
                "const": "file"
              },
              "path": {
                "description": "Local file path to marketplace.json",
                "type": "string"
              }
            },
            "required": [
              "source",
              "path"
            ]
          },
          {
            "type": "object",
            "properties": {
              "source": {
                "type": "string",
                "const": "directory"
              },
              "path": {
                "description": "Local directory containing .claude-plugin/marketplace.json",
                "type": "string"
              }
            },
            "required": [
              "source",
              "path"
            ]
          },
          {
            "description": "Policy-list sentinel for the ~/.claude/skills/ auto-load (@skills-dir plugins). In strictKnownMarketplaces: opt the scan back IN (by default any allowlist blocks it). In blockedMarketplaces: turn the scan OFF without otherwise restricting marketplaces. Only meaningful in those two managed-settings lists (areLocalPluginDirsAllowedByPolicy); known_marketplaces.json / marketplace add etc. ignore it.",
            "type": "object",
            "properties": {
              "source": {
                "type": "string",
                "const": "skills-dir"
              }
            },
            "required": [
              "source"
            ]
          },
          {
            "type": "object",
            "properties": {
              "source": {
                "type": "string",
                "const": "hostPattern"
              },
              "hostPattern": {
                "description": "Regex pattern to match the host/domain extracted from any marketplace source type. For github sources, matches against github.com. For git sources (SSH or HTTPS), extracts the hostname from the URL. Use in strictKnownMarketplaces to allow all marketplaces from a specific host (e.g., \"^github\\.mycompany\\.com$\").",
                "type": "string"
              }
            },
            "required": [
              "source",
              "hostPattern"
            ]
          },
          {
            "type": "object",
            "properties": {
              "source": {
                "type": "string",
                "const": "pathPattern"
              },
              "pathPattern": {
                "description": "Regex pattern matched against the .path field of file and directory sources. Use in strictKnownMarketplaces to allow filesystem-based marketplaces alongside hostPattern restrictions for network sources. Use \".*\" to allow all filesystem paths, or a narrower pattern (e.g., \"^/opt/approved/\") to restrict to specific directories.",
                "type": "string"
              }
            },
            "required": [
              "source",
              "pathPattern"
            ]
          },
          {
            "description": "Inline marketplace manifest defined directly in settings.json. The reconciler writes a synthetic marketplace.json to the cache; diffMarketplaces detects edits via isEqual on the stored source (the plugins array is inside this object, so edits surface as sourceChanged).",
            "type": "object",
            "properties": {
              "source": {
                "type": "string",
                "const": "settings"
              },
              "name": {
                "description": "Marketplace name. Must match the extraKnownMarketplaces key (enforced); the synthetic manifest is written under this name. Same validation as PluginMarketplaceSchema plus reserved-name rejection — validateOfficialNameSource runs after the disk write, too late to clean up.",
                "type": "string",
                "minLength": 1
              },
              "plugins": {
                "description": "Plugin entries declared inline in settings.json",
                "type": "array",
                "items": {
                  "type": "object",
                  "properties": {
                    "name": {
                      "description": "Plugin name as it appears in the target repository",
                      "type": "string",
                      "minLength": 1
                    },
                    "source": {
                      "description": "Where to fetch the plugin from. Must be a remote source — relative paths have no marketplace repository to resolve against.",
                      "anyOf": [
                        {
                          "description": "Path to the plugin root, relative to the marketplace root (the directory containing .claude-plugin/, not .claude-plugin/ itself)",
                          "type": "string",
                          "pattern": "^\\.\\/.*"
                        },
                        {
                          "description": "NPM package as plugin source",
                          "type": "object",
                          "properties": {
                            "source": {
                              "type": "string",
                              "const": "npm"
                            },
                            "package": {
                              "description": "Package name (or url, or local path, or anything else that can be passed to `npm` as a package)",
                              "anyOf": [
                                {
                                  "type": "string"
                                },
                                {
                                  "type": "string"
                                }
                              ]
                            },
                            "version": {
                              "description": "Specific version or version range (e.g., ^1.0.0, ~2.1.0)",
                              "type": "string"
                            },
                            "registry": {
                              "description": "Custom NPM registry URL (defaults to using system default, likely npmjs.org)",
                              "type": "string",
                              "format": "uri"
                            }
                          },
                          "required": [
                            "source",
                            "package"
                          ]
                        },
                        {
                          "type": "object",
                          "properties": {
                            "source": {
                              "type": "string",
                              "const": "url"
                            },
                            "url": {
                              "description": "Full git repository URL (https:// or git@)",
                              "type": "string"
                            },
                            "ref": {
                              "description": "Git branch or tag to use (e.g., \"main\", \"v1.0.0\"). Defaults to repository default branch.",
                              "type": "string"
                            },
                            "sha": {
                              "description": "Specific commit SHA to use",
                              "type": "string",
                              "minLength": 40,
                              "maxLength": 40,
                              "pattern": "^[a-f0-9]{40}$"
                            }
                          },
                          "required": [
                            "source",
                            "url"
                          ]
                        },
                        {
                          "type": "object",
                          "properties": {
                            "source": {
                              "type": "string",
                              "const": "github"
                            },
                            "repo": {
                              "description": "GitHub repository in owner/repo format",
                              "type": "string"
                            },
                            "ref": {
                              "description": "Git branch or tag to use (e.g., \"main\", \"v1.0.0\"). Defaults to repository default branch.",
                              "type": "string"
                            },
                            "sha": {
                              "description": "Specific commit SHA to use",
                              "type": "string",
                              "minLength": 40,
                              "maxLength": 40,
                              "pattern": "^[a-f0-9]{40}$"
                            }
                          },
                          "required": [
                            "source",
                            "repo"
                          ]
                        },
                        {
                          "description": "Plugin located in a subdirectory of a larger repository (monorepo). Only the specified subdirectory is materialized; the rest of the repo is not downloaded.",
                          "type": "object",
                          "properties": {
                            "source": {
                              "type": "string",
                              "const": "git-subdir"
                            },
                            "url": {
                              "description": "Git repository: GitHub owner/repo shorthand, https://, or git@ URL",
                              "type": "string"
                            },
                            "path": {
                              "description": "Subdirectory within the repo containing the plugin (e.g., \"tools/claude-plugin\"). Cloned sparsely using partial clone (--filter=tree:0) to minimize bandwidth for monorepos.",
                              "type": "string",
                              "minLength": 1
                            },
                            "ref": {
                              "description": "Git branch or tag to use (e.g., \"main\", \"v1.0.0\"). Defaults to repository default branch.",
                              "type": "string"
                            },
                            "sha": {
                              "description": "Specific commit SHA to use",
                              "type": "string",
                              "minLength": 40,
                              "maxLength": 40,
                              "pattern": "^[a-f0-9]{40}$"
                            }
                          },
                          "required": [
                            "source",
                            "url",
                            "path"
                          ]
                        },
                        {
                          "description": "Placeholder for source types this Claude Code version does not recognize. Never authored by hand — PluginMarketplaceSchema rewrites unparseable sources to this so the entry remains in marketplace.plugins (detectDelistedPlugins must not see it as removed). Install attempts fail at cachePlugin with a clear \"update Claude Code\" message.",
                          "type": "object",
                          "properties": {
                            "source": {
                              "type": "string",
                              "const": "unsupported"
                            }
                          },
                          "required": [
                            "source"
                          ]
                        }
                      ]
                    },
                    "description": {
                      "type": "string"
                    },
                    "version": {
                      "type": "string"
                    },
                    "strict": {
                      "type": "boolean"
                    }
                  },
                  "required": [
                    "name",
                    "source"
                  ]
                }
              },
              "owner": {
                "type": "object",
                "properties": {
                  "name": {
                    "description": "Display name of the plugin author or organization",
                    "type": "string",
                    "minLength": 1
                  },
                  "email": {
                    "description": "Contact email for support or feedback",
                    "type": "string"
                  },
                  "url": {
                    "description": "Website, GitHub profile, or organization URL",
                    "type": "string"
                  }
                },
                "required": [
                  "name"
                ]
              }
            },
            "required": [
              "source",
              "name",
              "plugins"
            ]
          }
        ]
      }
    },
    "blockedMarketplaces": {
      "description": "Enterprise blocklist of marketplace sources. When set in managed settings, these exact sources are blocked from being added as marketplaces. The check happens BEFORE downloading, so blocked sources never touch the filesystem.",
      "type": "array",
      "items": {
        "anyOf": [
          {
            "type": "object",
            "properties": {
              "source": {
                "type": "string",
                "const": "url"
              },
              "url": {
                "description": "Direct URL to marketplace.json file",
                "type": "string",
                "format": "uri"
              },
              "headers": {
                "description": "Custom HTTP headers (e.g., for authentication)",
                "type": "object",
                "propertyNames": {
                  "type": "string"
                },
                "additionalProperties": {
                  "type": "string"
                }
              }
            },
            "required": [
              "source",
              "url"
            ]
          },
          {
            "type": "object",
            "properties": {
              "source": {
                "type": "string",
                "const": "github"
              },
              "repo": {
                "description": "GitHub repository in owner/repo format",
                "type": "string"
              },
              "ref": {
                "description": "Git branch or tag to use (e.g., \"main\", \"v1.0.0\"). Defaults to repository default branch.",
                "type": "string"
              },
              "path": {
                "description": "Path to marketplace.json within repo (defaults to .claude-plugin/marketplace.json)",
                "type": "string"
              },
              "sparsePaths": {
                "description": "Directories to include via git sparse-checkout (cone mode). Use for monorepos where the marketplace lives in a subdirectory. Example: [\".claude-plugin\", \"plugins\"]. If omitted, the full repository is cloned.",
                "type": "array",
                "items": {
                  "type": "string"
                }
              },
              "skipLfs": {
                "description": "Skip Git LFS smudge during clone and update (sets GIT_LFS_SKIP_SMUDGE=1) so LFS pointer files stay as pointers instead of downloading their content. Use for marketplaces hosted in repos with large LFS objects.",
                "type": "boolean"
              }
            },
            "required": [
              "source",
              "repo"
            ]
          },
          {
            "type": "object",
            "properties": {
              "source": {
                "type": "string",
                "const": "git"
              },
              "url": {
                "description": "Full git repository URL",
                "type": "string"
              },
              "ref": {
                "description": "Git branch or tag to use (e.g., \"main\", \"v1.0.0\"). Defaults to repository default branch.",
                "type": "string"
              },
              "path": {
                "description": "Path to marketplace.json within repo (defaults to .claude-plugin/marketplace.json)",
                "type": "string"
              },
              "sparsePaths": {
                "description": "Directories to include via git sparse-checkout (cone mode). Use for monorepos where the marketplace lives in a subdirectory. Example: [\".claude-plugin\", \"plugins\"]. If omitted, the full repository is cloned.",
                "type": "array",
                "items": {
                  "type": "string"
                }
              },
              "skipLfs": {
                "description": "Skip Git LFS smudge during clone and update (sets GIT_LFS_SKIP_SMUDGE=1) so LFS pointer files stay as pointers instead of downloading their content. Use for marketplaces hosted in repos with large LFS objects.",
                "type": "boolean"
              }
            },
            "required": [
              "source",
              "url"
            ]
          },
          {
            "type": "object",
            "properties": {
              "source": {
                "type": "string",
                "const": "npm"
              },
              "package": {
                "description": "NPM package containing marketplace.json",
                "type": "string"
              }
            },
            "required": [
              "source",
              "package"
            ]
          },
          {
            "type": "object",
            "properties": {
              "source": {
                "type": "string",
                "const": "file"
              },
              "path": {
                "description": "Local file path to marketplace.json",
                "type": "string"
              }
            },
            "required": [
              "source",
              "path"
            ]
          },
          {
            "type": "object",
            "properties": {
              "source": {
                "type": "string",
                "const": "directory"
              },
              "path": {
                "description": "Local directory containing .claude-plugin/marketplace.json",
                "type": "string"
              }
            },
            "required": [
              "source",
              "path"
            ]
          },
          {
            "description": "Policy-list sentinel for the ~/.claude/skills/ auto-load (@skills-dir plugins). In strictKnownMarketplaces: opt the scan back IN (by default any allowlist blocks it). In blockedMarketplaces: turn the scan OFF without otherwise restricting marketplaces. Only meaningful in those two managed-settings lists (areLocalPluginDirsAllowedByPolicy); known_marketplaces.json / marketplace add etc. ignore it.",
            "type": "object",
            "properties": {
              "source": {
                "type": "string",
                "const": "skills-dir"
              }
            },
            "required": [
              "source"
            ]
          },
          {
            "type": "object",
            "properties": {
              "source": {
                "type": "string",
                "const": "hostPattern"
              },
              "hostPattern": {
                "description": "Regex pattern to match the host/domain extracted from any marketplace source type. For github sources, matches against github.com. For git sources (SSH or HTTPS), extracts the hostname from the URL. Use in strictKnownMarketplaces to allow all marketplaces from a specific host (e.g., \"^github\\.mycompany\\.com$\").",
                "type": "string"
              }
            },
            "required": [
              "source",
              "hostPattern"
            ]
          },
          {
            "type": "object",
            "properties": {
              "source": {
                "type": "string",
                "const": "pathPattern"
              },
              "pathPattern": {
                "description": "Regex pattern matched against the .path field of file and directory sources. Use in strictKnownMarketplaces to allow filesystem-based marketplaces alongside hostPattern restrictions for network sources. Use \".*\" to allow all filesystem paths, or a narrower pattern (e.g., \"^/opt/approved/\") to restrict to specific directories.",
                "type": "string"
              }
            },
            "required": [
              "source",
              "pathPattern"
            ]
          },
          {
            "description": "Inline marketplace manifest defined directly in settings.json. The reconciler writes a synthetic marketplace.json to the cache; diffMarketplaces detects edits via isEqual on the stored source (the plugins array is inside this object, so edits surface as sourceChanged).",
            "type": "object",
            "properties": {
              "source": {
                "type": "string",
                "const": "settings"
              },
              "name": {
                "description": "Marketplace name. Must match the extraKnownMarketplaces key (enforced); the synthetic manifest is written under this name. Same validation as PluginMarketplaceSchema plus reserved-name rejection — validateOfficialNameSource runs after the disk write, too late to clean up.",
                "type": "string",
                "minLength": 1
              },
              "plugins": {
                "description": "Plugin entries declared inline in settings.json",
                "type": "array",
                "items": {
                  "type": "object",
                  "properties": {
                    "name": {
                      "description": "Plugin name as it appears in the target repository",
                      "type": "string",
                      "minLength": 1
                    },
                    "source": {
                      "description": "Where to fetch the plugin from. Must be a remote source — relative paths have no marketplace repository to resolve against.",
                      "anyOf": [
                        {
                          "description": "Path to the plugin root, relative to the marketplace root (the directory containing .claude-plugin/, not .claude-plugin/ itself)",
                          "type": "string",
                          "pattern": "^\\.\\/.*"
                        },
                        {
                          "description": "NPM package as plugin source",
                          "type": "object",
                          "properties": {
                            "source": {
                              "type": "string",
                              "const": "npm"
                            },
                            "package": {
                              "description": "Package name (or url, or local path, or anything else that can be passed to `npm` as a package)",
                              "anyOf": [
                                {
                                  "type": "string"
                                },
                                {
                                  "type": "string"
                                }
                              ]
                            },
                            "version": {
                              "description": "Specific version or version range (e.g., ^1.0.0, ~2.1.0)",
                              "type": "string"
                            },
                            "registry": {
                              "description": "Custom NPM registry URL (defaults to using system default, likely npmjs.org)",
                              "type": "string",
                              "format": "uri"
                            }
                          },
                          "required": [
                            "source",
                            "package"
                          ]
                        },
                        {
                          "type": "object",
                          "properties": {
                            "source": {
                              "type": "string",
                              "const": "url"
                            },
                            "url": {
                              "description": "Full git repository URL (https:// or git@)",
                              "type": "string"
                            },
                            "ref": {
                              "description": "Git branch or tag to use (e.g., \"main\", \"v1.0.0\"). Defaults to repository default branch.",
                              "type": "string"
                            },
                            "sha": {
                              "description": "Specific commit SHA to use",
                              "type": "string",
                              "minLength": 40,
                              "maxLength": 40,
                              "pattern": "^[a-f0-9]{40}$"
                            }
                          },
                          "required": [
                            "source",
                            "url"
                          ]
                        },
                        {
                          "type": "object",
                          "properties": {
                            "source": {
                              "type": "string",
                              "const": "github"
                            },
                            "repo": {
                              "description": "GitHub repository in owner/repo format",
                              "type": "string"
                            },
                            "ref": {
                              "description": "Git branch or tag to use (e.g., \"main\", \"v1.0.0\"). Defaults to repository default branch.",
                              "type": "string"
                            },
                            "sha": {
                              "description": "Specific commit SHA to use",
                              "type": "string",
                              "minLength": 40,
                              "maxLength": 40,
                              "pattern": "^[a-f0-9]{40}$"
                            }
                          },
                          "required": [
                            "source",
                            "repo"
                          ]
                        },
                        {
                          "description": "Plugin located in a subdirectory of a larger repository (monorepo). Only the specified subdirectory is materialized; the rest of the repo is not downloaded.",
                          "type": "object",
                          "properties": {
                            "source": {
                              "type": "string",
                              "const": "git-subdir"
                            },
                            "url": {
                              "description": "Git repository: GitHub owner/repo shorthand, https://, or git@ URL",
                              "type": "string"
                            },
                            "path": {
                              "description": "Subdirectory within the repo containing the plugin (e.g., \"tools/claude-plugin\"). Cloned sparsely using partial clone (--filter=tree:0) to minimize bandwidth for monorepos.",
                              "type": "string",
                              "minLength": 1
                            },
                            "ref": {
                              "description": "Git branch or tag to use (e.g., \"main\", \"v1.0.0\"). Defaults to repository default branch.",
                              "type": "string"
                            },
                            "sha": {
                              "description": "Specific commit SHA to use",
                              "type": "string",
                              "minLength": 40,
                              "maxLength": 40,
                              "pattern": "^[a-f0-9]{40}$"
                            }
                          },
                          "required": [
                            "source",
                            "url",
                            "path"
                          ]
                        },
                        {
                          "description": "Placeholder for source types this Claude Code version does not recognize. Never authored by hand — PluginMarketplaceSchema rewrites unparseable sources to this so the entry remains in marketplace.plugins (detectDelistedPlugins must not see it as removed). Install attempts fail at cachePlugin with a clear \"update Claude Code\" message.",
                          "type": "object",
                          "properties": {
                            "source": {
                              "type": "string",
                              "const": "unsupported"
                            }
                          },
                          "required": [
                            "source"
                          ]
                        }
                      ]
                    },
                    "description": {
                      "type": "string"
                    },
                    "version": {
                      "type": "string"
                    },
                    "strict": {
                      "type": "boolean"
                    }
                  },
                  "required": [
                    "name",
                    "source"
                  ]
                }
              },
              "owner": {
                "type": "object",
                "properties": {
                  "name": {
                    "description": "Display name of the plugin author or organization",
                    "type": "string",
                    "minLength": 1
                  },
                  "email": {
                    "description": "Contact email for support or feedback",
                    "type": "string"
                  },
                  "url": {
                    "description": "Website, GitHub profile, or organization URL",
                    "type": "string"
                  }
                },
                "required": [
                  "name"
                ]
              }
            },
            "required": [
              "source",
              "name",
              "plugins"
            ]
          }
        ]
      }
    },
    "disableSideloadFlags": {
      "description": "When true (and set in managed settings), rejects the --plugin-dir, --plugin-url, --agents, and non-sdk --mcp-config CLI flags at startup. Closes the CLI-flag bypass of strictKnownMarketplaces. Pair with allowedMcpServers for per-server MCP control; this setting does not gate other MCP entry points (SDK setMcpServers, claude mcp add, .mcp.json). Also blocks surfaces that spawn the CLI with these flags internally (see settings documentation). Only honored from managed settings; ignored in user/project/local settings.",
      "type": "boolean"
    },
    "pluginSuggestionMarketplaces": {
      "description": "Marketplace names whose plugins may surface as contextual install suggestions (relevance-based tips). No marketplace-declared suggestions surface without this allowlist; the built-in first-party frontend-design tip is unaffected. Only honored when set in managed settings (policy scope); the key is ignored in user, project, and local settings. A name only takes effect when the marketplace is registered on the machine AND its registered source is also declared in managed settings, either as the extraKnownMarketplaces entry for that name or as an entry of strictKnownMarketplaces. A marketplace registered from a different source under an allowlisted name is ignored. The official marketplace is exempt from the source requirement: allowlisting its name alone suffices, since that name can only register from the official Anthropic source.",
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "forceLoginMethod": {
      "description": "Force a specific login method: \"claudeai\" for Claude Pro/Max, \"console\" for Console billing, \"gateway\" for the Cloud gateway OIDC device flow",
      "type": "string",
      "enum": [
        "claudeai",
        "console",
        "gateway"
      ]
    },
    "forceLoginGatewayUrl": {
      "description": "@internal Cloud gateway URL to pre-fill and auto-connect to during login. Typically set in local managed settings alongside forceLoginMethod: \"gateway\" so users never type the URL. Hidden from public SDK types until Cloud gateway is documented.",
      "type": "string",
      "format": "uri"
    },
    "parentSettingsBehavior": {
      "description": "Controls whether the SDK parent tier (Options.managedSettings / --managed-settings) layers under this admin tier. \"first-wins\" (default): parent is dropped — admin tiers are the only policy source. \"merge\": parent's restrictive-only-filtered settings union under the admin winner. Has no effect when no admin tier exists (parent applies as the sole policy tier, still filtered restrictive-only).",
      "type": "string",
      "enum": [
        "first-wins",
        "merge"
      ]
    },
    "forceLoginOrgUUID": {
      "description": "Organization UUID to require for OAuth login. Accepts a single UUID string or an array of UUIDs (any one is permitted). When set in managed settings, login fails if the authenticated account does not belong to a listed organization.",
      "anyOf": [
        {
          "type": "string"
        },
        {
          "type": "array",
          "items": {
            "type": "string"
          }
        }
      ]
    },
    "forceRemoteSettingsRefresh": {
      "description": "When set in managed settings, the CLI blocks startup until remote managed settings are freshly fetched, and exits if the fetch fails",
      "type": "boolean"
    },
    "otelHeadersHelper": {
      "description": "Path to a script that outputs OpenTelemetry headers",
      "type": "string"
    },
    "outputStyle": {
      "description": "Controls the output style for assistant responses",
      "type": "string"
    },
    "viewMode": {
      "description": "Default transcript view mode on startup",
      "type": "string",
      "enum": [
        "default",
        "verbose",
        "focus"
      ]
    },
    "language": {
      "description": "Preferred language for Claude responses and voice dictation (e.g., \"japanese\", \"spanish\")",
      "type": "string"
    },
    "skipWebFetchPreflight": {
      "description": "Skip the WebFetch blocklist check for enterprise environments with restrictive security policies",
      "type": "boolean"
    },
    "sandbox": {
      "type": "object",
      "properties": {
        "enabled": {
          "type": "boolean"
        },
        "failIfUnavailable": {
          "description": "Exit with an error at startup if sandbox.enabled is true but the sandbox cannot start (missing dependencies or unsupported platform). When false (default), a warning is shown and commands run unsandboxed. Intended for managed-settings deployments that require sandboxing as a hard gate.",
          "type": "boolean"
        },
        "autoAllowBashIfSandboxed": {
          "type": "boolean"
        },
        "allowUnsandboxedCommands": {
          "description": "Allow commands to run outside the sandbox via the dangerouslyDisableSandbox parameter. When false, the dangerouslyDisableSandbox parameter is completely ignored and all commands must run sandboxed. Default: true.",
          "type": "boolean"
        },
        "network": {
          "type": "object",
          "properties": {
            "allowedDomains": {
              "type": "array",
              "items": {
                "type": "string"
              }
            },
            "deniedDomains": {
              "description": "Domains that are always blocked, even if matched by allowedDomains. Supports the same wildcard syntax as allowedDomains. Merged from all settings sources regardless of allowManagedDomainsOnly.",
              "type": "array",
              "items": {
                "type": "string"
              }
            },
            "allowManagedDomainsOnly": {
              "description": "When true (and set in managed settings), only allowedDomains and WebFetch(domain:...) allow rules from managed settings are respected. User, project, local, and flag settings domains are ignored. Denied domains are still respected from all sources.",
              "type": "boolean"
            },
            "allowUnixSockets": {
              "description": "macOS only: Unix socket paths to allow. Ignored on Linux (seccomp cannot filter by path).",
              "type": "array",
              "items": {
                "type": "string"
              }
            },
            "allowAllUnixSockets": {
              "description": "If true, allow all Unix sockets (disables blocking on both platforms).",
              "type": "boolean"
            },
            "allowLocalBinding": {
              "type": "boolean"
            },
            "allowMachLookup": {
              "description": "macOS only: Additional XPC/Mach service names to allow looking up. Supports trailing-wildcard prefix matching (e.g., \"com.apple.coresimulator.*\"). Needed for tools that communicate via XPC such as the iOS Simulator or Playwright.",
              "type": "array",
              "items": {
                "type": "string"
              }
            },
            "httpProxyPort": {
              "type": "number"
            },
            "socksProxyPort": {
              "type": "number"
            },
            "tlsTerminate": {
              "description": "[EXPERIMENTAL] Enable in-process TLS termination so the per-request filter can see HTTPS request bodies. Provide a CA cert+key, or omit both to have sandbox-runtime generate an ephemeral one for the session. Only honored from user, managed/policy, or CLI (`--settings`) settings — project settings (.claude/settings.json and .claude/settings.local.json) are ignored.",
              "type": "object",
              "properties": {
                "caCertPath": {
                  "type": "string",
                  "minLength": 1
                },
                "caKeyPath": {
                  "type": "string",
                  "minLength": 1
                }
              }
            }
          }
        },
        "filesystem": {
          "type": "object",
          "properties": {
            "allowWrite": {
              "description": "Additional paths to allow writing within the sandbox. Merged with paths from Edit(...) allow permission rules.",
              "type": "array",
              "items": {
                "type": "string"
              }
            },
            "denyWrite": {
              "description": "Additional paths to deny writing within the sandbox. Merged with paths from Edit(...) deny permission rules.",
              "type": "array",
              "items": {
                "type": "string"
              }
            },
            "denyRead": {
              "description": "Additional paths to deny reading within the sandbox. Merged with paths from Read(...) deny permission rules.",
              "type": "array",
              "items": {
                "type": "string"
              }
            },
            "allowRead": {
              "description": "Paths to re-allow reading within denyRead regions. Takes precedence over denyRead for matching paths.",
              "type": "array",
              "items": {
                "type": "string"
              }
            },
            "allowManagedReadPathsOnly": {
              "description": "When true (set in managed settings), only allowRead paths from policySettings are used.",
              "type": "boolean"
            }
          }
        },
        "credentials": {
          "type": "object",
          "properties": {
            "files": {
              "description": "Credential files or directories to protect. `deny` blocks reads inside the sandbox.",
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "path": {
                    "description": "Path to a credential file or directory. Same resolution as sandbox.filesystem.* paths: absolute, ~ expanded, or relative to the settings file root (project root for project settings, ~/.claude for user settings).",
                    "type": "string",
                    "minLength": 1
                  },
                  "mode": {
                    "description": "Access mode for this path. Only `deny` is supported.",
                    "type": "string",
                    "const": "deny"
                  }
                },
                "required": [
                  "path",
                  "mode"
                ]
              }
            },
            "envVars": {
              "description": "Environment variables to protect. `deny` unsets the variable for sandboxed commands; `mask` substitutes a sentinel inside the sandbox and injects the real value at the proxy.",
              "type": "array",
              "items": {
                "type": "object",
                "properties": {
                  "name": {
                    "description": "Environment variable name.",
                    "type": "string",
                    "pattern": "^[A-Za-z_][A-Za-z0-9_]*$"
                  },
                  "mode": {
                    "description": "Access mode for this environment variable. `deny` unsets the variable for sandboxed commands; `mask` shows sandboxed commands a sentinel value and the host proxy swaps sentinel→real on egress to `injectHosts`.",
                    "type": "string",
                    "enum": [
                      "deny",
                      "mask"
                    ]
                  },
                  "injectHosts": {
                    "description": "Optional narrowing of where the proxy substitutes this credential. Only meaningful when mode is `mask`; accepted but ignored for `deny`. If unset, defaults to `network.allowedDomains` — the credential is injected at every reachable host. Each entry must be reachable via `network.allowedDomains` (sandbox-runtime validates this).",
                    "type": "array",
                    "items": {
                      "type": "string"
                    }
                  }
                },
                "required": [
                  "name",
                  "mode"
                ]
              }
            },
            "allowPlaintextInject": {
              "description": "Allow sentinel→real substitution on the plain-HTTP proxy path. Defaults to false: without TLS termination the upstream identity is unverified and the credential travels in cleartext. Set only for trusted-network test fixtures. Only honored from user, managed/policy, or CLI (`--settings`) settings — project settings (.claude/settings.json and .claude/settings.local.json) are ignored.",
              "type": "boolean"
            }
          }
        },
        "ignoreViolations": {
          "type": "object",
          "propertyNames": {
            "type": "string"
          },
          "additionalProperties": {
            "type": "array",
            "items": {
              "type": "string"
            }
          }
        },
        "enableWeakerNestedSandbox": {
          "type": "boolean"
        },
        "enableWeakerNetworkIsolation": {
          "description": "macOS only: Allow access to com.apple.trustd.agent in the sandbox. Needed for Go-based CLI tools (gh, gcloud, terraform, etc.) to verify TLS certificates when using httpProxyPort with a MITM proxy and custom CA. **Reduces security** — opens a potential data exfiltration vector through the trustd service. Default: false",
          "type": "boolean"
        },
        "allowAppleEvents": {
          "description": "macOS only: Allow sandboxed commands to send Apple Events (and look up the appleeventsd Mach service). Needed for `open`, `osascript`, and browser-based auth flows that open URLs. **Removes code-execution isolation** — sandboxed commands can launch other applications unsandboxed with no user prompt, and can script running apps (e.g. Terminal) subject to the user's per-app TCC automation consent. Only honored from user, managed/policy, or CLI (--settings) settings — project settings (.claude/settings.json and .claude/settings.local.json) are ignored. Default: false",
          "type": "boolean"
        },
        "excludedCommands": {
          "type": "array",
          "items": {
            "type": "string"
          }
        },
        "ripgrep": {
          "description": "Custom ripgrep configuration for bundled ripgrep support",
          "type": "object",
          "properties": {
            "command": {
              "type": "string"
            },
            "args": {
              "type": "array",
              "items": {
                "type": "string"
              }
            }
          },
          "required": [
            "command"
          ]
        },
        "bwrapPath": {
          "description": "Linux/WSL only: Absolute path to the bwrap (bubblewrap) binary. Overrides auto-detection via PATH. Only honored from admin-controlled managed settings.",
          "type": "string"
        },
        "socatPath": {
          "description": "Linux/WSL only: Absolute path to the socat binary used for the sandbox network proxy. Overrides auto-detection via PATH. Only honored from admin-controlled managed settings.",
          "type": "string"
        }
      },
      "additionalProperties": {}
    },
    "feedbackSurveyRate": {
      "description": "Probability (0–1) that the session quality survey appears when eligible. 0.05 is a reasonable starting point.",
      "type": "number",
      "minimum": 0,
      "maximum": 1
    },
    "spinnerTipsEnabled": {
      "description": "Whether to show tips in the spinner",
      "type": "boolean"
    },
    "spinnerVerbs": {
      "description": "Customize spinner verbs. mode: \"append\" adds verbs to defaults, \"replace\" uses only your verbs.",
      "type": "object",
      "properties": {
        "mode": {
          "type": "string",
          "enum": [
            "append",
            "replace"
          ]
        },
        "verbs": {
          "type": "array",
          "items": {
            "type": "string"
          }
        }
      },
      "required": [
        "mode",
        "verbs"
      ]
    },
    "spinnerTipsOverride": {
      "description": "Override spinner tips. tips: array of tip strings. excludeDefault: if true, only show custom tips (default: false).",
      "type": "object",
      "properties": {
        "excludeDefault": {
          "type": "boolean"
        },
        "tips": {
          "type": "array",
          "items": {
            "type": "string"
          }
        }
      },
      "required": [
        "tips"
      ]
    },
    "syntaxHighlightingDisabled": {
      "description": "Whether to disable syntax highlighting in diffs",
      "type": "boolean"
    },
    "terminalTitleFromRename": {
      "description": "Whether /rename updates the terminal tab title (defaults to true). Set to false to keep auto-generated topic titles.",
      "type": "boolean"
    },
    "alwaysThinkingEnabled": {
      "description": "When false, thinking is disabled. When absent or true, thinking is enabled automatically for supported models.",
      "type": "boolean"
    },
    "effortLevel": {
      "description": "Persisted effort level for supported models.",
      "type": "string",
      "enum": [
        "low",
        "medium",
        "high",
        "xhigh"
      ]
    },
    "ultracode": {
      "description": "Enable ultracode for the session: xhigh effort plus standing dynamic-workflow orchestration. Session-scoped — typically provided via --settings or the apply_flag_settings control request; interactive toggles never persist it. Requires workflows to be enabled and an xhigh-capable model.",
      "type": "boolean"
    },
    "autoCompactWindow": {
      "description": "Auto-compact window size",
      "type": "integer",
      "minimum": 100000,
      "maximum": 1000000
    },
    "advisorModel": {
      "description": "Advisor model for the server-side advisor tool.",
      "type": "string"
    },
    "fastMode": {
      "description": "When true, fast mode is enabled. When absent or false, fast mode is off.",
      "type": "boolean"
    },
    "fastModePerSessionOptIn": {
      "description": "When true, fast mode does not persist across sessions. Each session starts with fast mode off.",
      "type": "boolean"
    },
    "promptSuggestionEnabled": {
      "description": "When false, prompt suggestions are disabled. When absent or true, prompt suggestions are enabled.",
      "type": "boolean"
    },
    "awaySummaryEnabled": {
      "description": "@internal When false, the session recap (shown when you return after being away for 5+ minutes) is disabled. When absent or true, recap is enabled. Hidden from public SDK types until external launch.",
      "type": "boolean"
    },
    "showClearContextOnPlanAccept": {
      "description": "When true, the plan-approval dialog offers a \"clear context\" option. Defaults to false.",
      "type": "boolean"
    },
    "askUserQuestionTimeout": {
      "description": "Idle time before Claude's questions auto-continue with any answers selected so far. Defaults to never — auto-continue only runs when explicitly set to 60s/5m/10m.",
      "type": "string",
      "enum": [
        "60s",
        "5m",
        "10m",
        "never"
      ]
    },
    "agent": {
      "description": "Name of an agent (built-in or custom) to use for the main thread. Applies the agent's system prompt, tool restrictions, and model.",
      "type": "string"
    },
    "companyAnnouncements": {
      "description": "Company announcements to display at startup (one will be randomly selected if multiple are provided)",
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "pluginConfigs": {
      "description": "Per-plugin configuration including MCP server user configs, keyed by plugin ID (plugin@marketplace format)",
      "type": "object",
      "propertyNames": {
        "type": "string"
      },
      "additionalProperties": {
        "anyOf": [
          {
            "type": "object",
            "properties": {
              "mcpServers": {
                "description": "User configuration values for MCP servers keyed by server name",
                "type": "object",
                "propertyNames": {
                  "type": "string"
                },
                "additionalProperties": {
                  "type": "object",
                  "propertyNames": {
                    "type": "string"
                  },
                  "additionalProperties": {
                    "anyOf": [
                      {
                        "type": "string"
                      },
                      {
                        "type": "number"
                      },
                      {
                        "type": "boolean"
                      },
                      {
                        "type": "array",
                        "items": {
                          "type": "string"
                        }
                      }
                    ]
                  }
                }
              },
              "options": {
                "description": "Non-sensitive option values from plugin manifest userConfig, keyed by option name. Sensitive values go to secure storage instead.",
                "type": "object",
                "propertyNames": {
                  "type": "string"
                },
                "additionalProperties": {
                  "anyOf": [
                    {
                      "type": "string"
                    },
                    {
                      "type": "number"
                    },
                    {
                      "type": "boolean"
                    },
                    {
                      "type": "array",
                      "items": {
                        "type": "string"
                      }
                    }
                  ]
                }
              }
            }
          },
          {
            "not": {}
          }
        ]
      }
    },
    "remote": {
      "description": "Cloud session configuration",
      "type": "object",
      "properties": {
        "defaultEnvironmentId": {
          "description": "Default environment ID to use for cloud sessions",
          "type": "string"
        }
      }
    },
    "autoUpdatesChannel": {
      "description": "Release channel for auto-updates (latest or stable)",
      "type": "string",
      "enum": [
        "latest",
        "stable",
        "rc"
      ]
    },
    "minimumVersion": {
      "description": "Minimum version to stay on - prevents downgrades when switching to stable channel",
      "type": "string"
    },
    "requiredMinimumVersion": {
      "description": "Minimum Claude Code version required to start. If the running version is older, Claude Code exits at startup with instructions to update. Only enforced from managed (policy) settings.",
      "type": "string"
    },
    "requiredMaximumVersion": {
      "description": "Maximum Claude Code version allowed to start. If the running version is newer, Claude Code exits at startup with instructions to install an approved version. Only enforced from managed (policy) settings.",
      "type": "string"
    },
    "plansDirectory": {
      "description": "Custom directory for plan files, relative to project root. If not set, defaults to ~/.claude/plans/",
      "type": "string"
    },
    "tui": {
      "description": "Terminal UI renderer. \"fullscreen\" uses the flicker-free alt-screen renderer with virtualized scrollback (equivalent to CLAUDE_CODE_NO_FLICKER=1). \"default\" uses the classic main-screen renderer.",
      "type": "string",
      "enum": [
        "default",
        "fullscreen"
      ]
    },
    "voice": {
      "description": "Voice mode settings (hold-to-talk / tap-to-toggle dictation)",
      "type": "object",
      "properties": {
        "enabled": {
          "type": "boolean"
        },
        "mode": {
          "description": "'hold' (default): hold to talk. 'tap': tap to start, tap to stop+submit.",
          "type": "string",
          "enum": [
            "hold",
            "tap"
          ]
        },
        "autoSubmit": {
          "description": "Submit the prompt when hold-to-talk is released (hold mode only)",
          "type": "boolean"
        }
      }
    },
    "channelsEnabled": {
      "description": "Managed-org opt-in for channel notifications (MCP servers with the claude/channel capability pushing inbound messages). claude.ai Teams/Enterprise: default off. Console: default on unless managed settings exist. Set true to allow; users then select servers via --channels.",
      "type": "boolean"
    },
    "allowedChannelPlugins": {
      "description": "Managed-org allowlist of channel plugins. When set, replaces the default Anthropic allowlist — admins decide which plugins may push inbound messages. Undefined falls back to the default. Requires channelsEnabled: true.",
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "marketplace": {
            "type": "string"
          },
          "plugin": {
            "type": "string"
          }
        },
        "required": [
          "marketplace",
          "plugin"
        ]
      }
    },
    "prefersReducedMotion": {
      "description": "Reduce or disable animations for accessibility (spinner shimmer, flash effects, etc.)",
      "type": "boolean"
    },
    "doneMeansMerged": {
      "description": "@internal When true, Claude keeps working until the PR is ready for you to merge, a cron/Monitor is armed to resume later, or it hands you a self-contained next step.",
      "type": "boolean"
    },
    "totalTokensReminder": {
      "description": "@internal Emit a <total_tokens>N tokens left</total_tokens> block in the system prompt, after each tool result, and (when totalTokensReminderAfterUserTurn is on) after each regular user prompt. 'infinite' uses the literal value Infinite, 'fixed' uses 5000000, 'countdown' uses the live remaining context-window tokens, 'padded-countdown' counts down from totalTokensReminderBudget (re-anchoring to the full budget on each regular user prompt when totalTokensReminderAfterUserTurn is on — task-budget semantics). Defaults to off. Env var CLAUDE_CODE_TOTAL_TOKENS_REMINDER overrides.",
      "type": "string",
      "enum": [
        "off",
        "infinite",
        "fixed",
        "countdown",
        "padded-countdown"
      ]
    },
    "totalTokensReminderBudget": {
      "description": "@internal Starting budget (tokens) for totalTokensReminder 'padded-countdown' mode. Defaults to 15000000. Server-controlled via GrowthBook; env var CLAUDE_CODE_TOTAL_TOKENS_REMINDER_BUDGET overrides.",
      "type": "integer",
      "exclusiveMinimum": 0,
      "maximum": 9007199254740991
    },
    "totalTokensReminderAfterUserTurn": {
      "description": "@internal When true, emit the totalTokensReminder block after each regular user prompt and (for 'padded-countdown') re-anchor the task budget to the full configured value at the start of each user turn. When false, the reminder appears only in the system prompt and after each tool-result batch, and 'padded-countdown' counts down over the whole session. Defaults to off. Env var CLAUDE_CODE_TOTAL_TOKENS_REMINDER_AFTER_USER_TURN overrides; server-controlled via GrowthBook tengu_lapis_anchor_user_turn.",
      "type": "boolean"
    },
    "autoMemoryEnabled": {
      "description": "Enable auto-memory for this project. When false, Claude will not read from or write to the auto-memory directory.",
      "type": "boolean"
    },
    "autoMemoryDirectory": {
      "description": "Custom directory path for auto-memory storage. Supports ~/ prefix for home directory expansion. Ignored if set in projectSettings (checked-in .claude/settings.json) for security. When unset, defaults to ~/.claude/projects/<sanitized-cwd>/memory/.",
      "type": "string"
    },
    "autoDreamEnabled": {
      "description": "Enable background memory consolidation (auto-dream). When set, overrides the server-side default.",
      "type": "boolean"
    },
    "showThinkingSummaries": {
      "description": "Request API-side thinking summaries and show them in the conversation and in the transcript view (ctrl+o). Set explicitly to override the default for your install.",
      "type": "boolean"
    },
    "skipDangerousModePermissionPrompt": {
      "description": "Whether the user has accepted the bypass permissions mode dialog",
      "type": "boolean"
    },
    "skipWorkflowUsageWarning": {
      "description": "@internal Whether the user has accepted the multi-agent workflow usage warning. Until set, auto permission mode prompts before running a workflow.",
      "type": "boolean"
    },
    "disableAutoMode": {
      "description": "Disable auto mode",
      "type": "string",
      "enum": [
        "disable"
      ]
    },
    "sshConfigs": {
      "description": "SSH connection configurations for remote environments. Typically set in managed settings by enterprise administrators to pre-configure SSH connections for team members.",
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "id": {
            "description": "Unique identifier for this SSH config. Used to match configs across settings sources.",
            "type": "string"
          },
          "name": {
            "description": "Display name for the SSH connection",
            "type": "string"
          },
          "sshHost": {
            "description": "SSH host in format \"user@hostname\" or \"hostname\", or a host alias from ~/.ssh/config",
            "type": "string"
          },
          "sshPort": {
            "description": "SSH port (default: 22)",
            "type": "integer",
            "minimum": -9007199254740991,
            "maximum": 9007199254740991
          },
          "sshIdentityFile": {
            "description": "Path to SSH identity file (private key)",
            "type": "string"
          },
          "startDirectory": {
            "description": "Default working directory on the remote host. Supports tilde expansion (e.g. ~/projects). If not specified, defaults to the remote user home directory. Can be overridden by the [dir] positional argument in `claude ssh <config> [dir]`.",
            "type": "string"
          }
        },
        "required": [
          "id",
          "name",
          "sshHost"
        ]
      }
    },
    "claudeMd": {
      "description": "CLAUDE.md-style instructions injected as organization-managed memory. Only honored from managed/policy settings.",
      "type": "string"
    },
    "claudeMdExcludes": {
      "description": "Glob patterns or absolute paths of CLAUDE.md files to exclude from loading. Patterns are matched against absolute file paths using picomatch. Only applies to User, Project, and Local memory types (Managed/policy files cannot be excluded). Examples: \"/home/user/monorepo/CLAUDE.md\", \"**/code/CLAUDE.md\", \"**/some-dir/.claude/rules/**\"",
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "pluginTrustMessage": {
      "description": "Custom message to append to the plugin trust warning shown before installation. Only read from policy settings (managed-settings.json / MDM). Useful for enterprise administrators to add organization-specific context (e.g., \"All plugins from our internal marketplace are vetted and approved.\").",
      "type": "string"
    },
    "theme": {
      "description": "Color theme for the UI",
      "anyOf": [
        {
          "type": "string",
          "enum": [
            "auto",
            "dark",
            "light",
            "light-daltonized",
            "dark-daltonized",
            "light-ansi",
            "dark-ansi"
          ]
        },
        {
          "type": "string",
          "pattern": "^custom:.*"
        }
      ]
    },
    "editorMode": {
      "description": "Key binding mode for the prompt input",
      "type": "string",
      "enum": [
        "normal",
        "vim"
      ]
    },
    "verbose": {
      "description": "Show full tool output instead of truncated summaries",
      "type": "boolean"
    },
    "preferredNotifChannel": {
      "description": "Preferred OS notification channel",
      "type": "string",
      "enum": [
        "auto",
        "iterm2",
        "iterm2_with_bell",
        "terminal_bell",
        "kitty",
        "ghostty",
        "notifications_disabled"
      ]
    },
    "autoCompactEnabled": {
      "description": "Automatically compact conversation when context fills",
      "type": "boolean"
    },
    "precomputeCompactionEnabled": {
      "description": "@internal Precompute the compaction summary in the background before it is needed. Only applies when auto-compact is on.",
      "type": "boolean"
    },
    "switchModelsOnFlag": {
      "description": "When safety measures flag a message, automatically switch to a different model to keep chatting. When off, your session will pause instead.",
      "type": "boolean"
    },
    "autoScrollEnabled": {
      "description": "Auto-scroll the conversation view to bottom (fullscreen mode only)",
      "type": "boolean"
    },
    "wheelScrollAccelerationEnabled": {
      "description": "Ramp mouse-wheel scroll speed during fast scrolls (fullscreen mode only)",
      "type": "boolean"
    },
    "fileCheckpointingEnabled": {
      "description": "Snapshot files before edits so /rewind can restore them",
      "type": "boolean"
    },
    "showTurnDuration": {
      "description": "Show \"Cooked for Nm Ns\" after each assistant turn",
      "type": "boolean"
    },
    "showMessageTimestamps": {
      "description": "Stamp each assistant message with its arrival time",
      "type": "boolean"
    },
    "terminalProgressBarEnabled": {
      "description": "Emit OSC 9;4 progress sequences during long operations",
      "type": "boolean"
    },
    "todoFeatureEnabled": {
      "description": "Enable the todo / task tracking panel",
      "type": "boolean"
    },
    "teammateMode": {
      "description": "How spawned teammates execute (tmux, iterm2, in-process, auto)",
      "type": "string",
      "enum": [
        "auto",
        "tmux",
        "iterm2",
        "in-process"
      ]
    },
    "remoteControlAtStartup": {
      "description": "Start Remote Control bridge automatically each session",
      "type": "boolean"
    },
    "isolatePeerMachines": {
      "description": "Require explicit approval before SendMessage can reach a peer session on another machine via Remote Control",
      "type": "boolean"
    },
    "daemonColdStart": {
      "description": "When no background service is running: 'transient' spawns one for this login session; 'ask' offers to install it persistently",
      "type": "string",
      "enum": [
        "transient",
        "ask"
      ]
    },
    "autoUploadSessions": {
      "description": "Mirror local sessions to claude.ai as view-only (no remote control)",
      "type": "boolean"
    },
    "inputNeededNotifEnabled": {
      "description": "Push to mobile when a permission prompt or question is waiting",
      "type": "boolean"
    },
    "agentPushNotifEnabled": {
      "description": "Allow Claude to push proactive mobile notifications",
      "type": "boolean"
    },
    "skipAutoPermissionPrompt": {
      "description": "Whether the user has accepted the auto mode opt-in dialog",
      "type": "boolean"
    },
    "useAutoModeDuringPlan": {
      "description": "Whether plan mode uses auto mode semantics when auto mode is available (default: true)",
      "type": "boolean"
    },
    "autoMode": {
      "description": "Auto mode classifier prompt customization",
      "type": "object",
      "properties": {
        "allow": {
          "description": "Rules for the auto mode classifier allow section. Include the literal string \"$defaults\" to inherit the built-in rules at that position.",
          "type": "array",
          "items": {
            "type": "string"
          }
        },
        "soft_deny": {
          "description": "Rules for the auto mode classifier SOFT BLOCK section — destructive/irreversible actions that user intent can clear. Include the literal string \"$defaults\" to inherit the built-in rules at that position.",
          "type": "array",
          "items": {
            "type": "string"
          }
        },
        "hard_deny": {
          "description": "Rules for the auto mode classifier HARD BLOCK section — security boundaries that user intent does NOT clear. Include the literal string \"$defaults\" to inherit the built-in rules at that position.",
          "type": "array",
          "items": {
            "type": "string"
          }
        },
        "environment": {
          "description": "Entries for the auto mode classifier environment section. Include the literal string \"$defaults\" to inherit the built-in entries at that position.",
          "type": "array",
          "items": {
            "type": "string"
          }
        },
        "classifyAllShell": {
          "description": "When true, every Bash/PowerShell allow rule is suspended while auto mode is active so all shell commands are routed through the classifier (higher safety, more classifier calls). Default: false.",
          "type": "boolean"
        }
      }
    },
    "disableDeepLinkRegistration": {
      "description": "Prevent claude-cli:// protocol handler registration with the OS",
      "type": "string",
      "enum": [
        "disable"
      ]
    },
    "voiceEnabled": {
      "description": "Enable voice mode (hold-to-talk dictation)",
      "type": "boolean"
    },
    "defaultView": {
      "description": "Default transcript view: chat (SendUserMessage checkpoints only) or transcript (full)",
      "type": "string",
      "enum": [
        "chat",
        "transcript"
      ]
    },
    "axScreenReader": {
      "description": "Render screen-reader friendly output (flat text, no decorative borders or animations). Overridden by the CLAUDE_AX_SCREEN_READER env var and the --ax-screen-reader CLI flag.",
      "type": "boolean"
    }
  },
  "additionalProperties": {}
}
```

## User Request

Set up automated conversation logging: after every response/session, save a transcript of everything done/said in this conversation to a file, and commit+push that file to GitHub. This applies to the Mining Corporation / tictactoe workspace at C:\Users\Taylor\Downloads\ClaudeCodeTest (git repo, remote github.com/User-2056/tictactoe). User wants this persisted going forward automatically via hooks, not relying on the assistant remembering to do it manually each time.

---

**assistant** _(2026-07-22T11:59:12.304Z)_

Let me check the actual transcript JSON schema so the extraction logic is correct, then build and test the hook script.

---

**assistant** _(2026-07-22T11:59:13.828Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:59:22.532Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:59:38.592Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T11:59:53.774Z)_

[used tool: Write]

---

**assistant** _(2026-07-22T12:00:19.445Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T12:00:26.775Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T12:00:39.949Z)_

jq isn't available, but Node.js is — rewriting the hook logic in Node instead.

---

**assistant** _(2026-07-22T12:00:48.425Z)_

[used tool: Write]

---

**assistant** _(2026-07-22T12:00:59.963Z)_

Now let's remove the unused jq-based shell script and pipe-test the Node version.

---

**assistant** _(2026-07-22T12:01:02.144Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T12:02:14.162Z)_

Exit code 0, no errors. Let's verify it actually wrote and pushed the log.

---

**assistant** _(2026-07-22T12:02:15.818Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T12:02:34.812Z)_

The hook works end-to-end — wrote, committed, and pushed. Now let me clean up the test artifacts and make sure the real session doesn't duplicate what the test run already logged.

---

**assistant** _(2026-07-22T12:02:37.376Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T12:02:45.851Z)_

[used tool: Write]

---

**assistant** _(2026-07-22T12:02:58.242Z)_

Good idea to make this resilient to another folder move — let me have the script resolve its own repo path dynamically instead of hardcoding it.

---

**assistant** _(2026-07-22T12:02:59.707Z)_

[used tool: Edit]

---

**assistant** _(2026-07-22T12:03:13.463Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T12:03:34.129Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T12:03:48.279Z)_

Clean single copy now, and the real session's marker is correctly set so the actual Stop hook won't re-duplicate this content. Now let's wire the hook into `.claude/settings.json`.

---

**assistant** _(2026-07-22T12:03:48.437Z)_

[used tool: Read]

---

**assistant** _(2026-07-22T12:03:53.977Z)_

[used tool: Edit]

---

**assistant** _(2026-07-22T12:04:01.711Z)_

Now validate the settings JSON syntax and pipe-test the exact command as it will run, including the `$CLAUDE_PROJECT_DIR` variable.

---

**assistant** _(2026-07-22T12:04:02.467Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T12:04:13.398Z)_

JSON is valid. Now let's pipe-test the exact command string with `CLAUDE_PROJECT_DIR` set, simulating a real Stop event with a fresh synthetic session id.

---

**assistant** _(2026-07-22T12:04:16.248Z)_

[used tool: Bash]

---

**assistant** _(2026-07-22T12:04:27.614Z)_

[used tool: Bash]

---

**user** _(2026-07-22T12:29:46.122Z)_

fix the problem i mentioned before

---

**assistant** _(2026-07-22T12:29:50.974Z)_

I'll start by loading the Roblox Studio MCP tools I need, then inspect the current state of the pickaxe mesh and the grip code.

---

**assistant** _(2026-07-22T12:29:51.961Z)_

[used tool: ToolSearch]

---

**assistant** _(2026-07-22T12:29:52.315Z)_

[used tool: Glob]

---

**assistant** _(2026-07-22T12:29:53.236Z)_

[used tool: Glob]

---

**assistant** _(2026-07-22T12:29:56.105Z)_

[used tool: Read]

---

**assistant** _(2026-07-22T12:29:56.738Z)_

[used tool: Read]

---

**assistant** _(2026-07-22T12:29:56.759Z)_

[used tool: mcp__Roblox_Studio__get_studio_state]

---

**assistant** _(2026-07-22T12:29:59.796Z)_

[used tool: mcp__Roblox_Studio__inspect_instance]

---

**assistant** _(2026-07-22T12:30:04.689Z)_

[used tool: mcp__Roblox_Studio__inspect_instance]

---

**assistant** _(2026-07-22T12:30:05.287Z)_

[used tool: mcp__Roblox_Studio__inspect_instance]

---

**assistant** _(2026-07-22T12:30:55.617Z)_

[used tool: mcp__Roblox_Studio__inspect_instance]

---

**assistant** _(2026-07-22T12:31:18.748Z)_

[used tool: ToolSearch]

---

**assistant** _(2026-07-22T12:31:36.143Z)_

[used tool: mcp__Roblox_Studio__start_stop_play]

---

**assistant** _(2026-07-22T12:31:49.097Z)_

[used tool: mcp__Roblox_Studio__execute_luau]

---

**assistant** _(2026-07-22T12:35:48.954Z)_

This confirms the bug: the custom pickaxe's Handle sits ~1 stud below and behind the hand — not gripped at all. Rather than guess new numbers by eye, I'll derive the correct grip mathematically: measure the known-good Iron pickaxe's hand-relative pose, then solve for the Grip transform that puts the custom mesh in that same pose, accounting for its different local axes.

---

**assistant** _(2026-07-22T12:35:59.046Z)_

[used tool: mcp__Roblox_Studio__execute_luau]

---

**assistant** _(2026-07-22T12:36:02.009Z)_

[used tool: mcp__Roblox_Studio__get_studio_state]

---

**assistant** _(2026-07-22T12:36:05.075Z)_

Play mode ended unexpectedly. Restarting it.

---

**assistant** _(2026-07-22T12:36:05.164Z)_

[used tool: mcp__Roblox_Studio__start_stop_play]

---

**assistant** _(2026-07-22T12:36:09.627Z)_

[used tool: mcp__Roblox_Studio__get_studio_state]

---

**assistant** _(2026-07-22T12:36:11.856Z)_

Good, now in Play mode with Server datamodel available. Re-running the diagnostic/solve script.

---

**assistant** _(2026-07-22T12:36:21.843Z)_

[used tool: mcp__Roblox_Studio__execute_luau]

---

**assistant** _(2026-07-22T12:36:35.538Z)_

The solve converged on clean values — and notably the rotation (`GripForward`/`GripRight`/`GripUp`) came out identical to what was already configured, confirming that part was correct. Only `GripPos` was wrong: `(0, 0.9, 1.0)` → `(0, 0.4, 0)`. Let me visually confirm before writing it back.

---

**assistant** _(2026-07-22T12:36:36.087Z)_

[used tool: ToolSearch]

---

**assistant** _(2026-07-22T12:36:40.675Z)_

[used tool: mcp__Roblox_Studio__execute_luau]

---

**assistant** _(2026-07-22T12:36:43.645Z)_

[used tool: mcp__Roblox_Studio__screen_capture]

---

**assistant** _(2026-07-22T12:38:51.837Z)_

[used tool: ScheduleWakeup]

---

**user** _(2026-07-22T12:38:59.836Z)_

[Your previous response had no visible output. Please continue and produce a user-visible response.]

---

**assistant** _(2026-07-22T12:39:09.855Z)_

Still waiting on the screenshot capture (it moved to background after running long) to visually confirm the grip fix. In the meantime, here's what I've found and done:

**Root cause confirmed:** the new pickaxe mesh's `GripForward`/`GripRight`/`GripUp` axis assignment in `EquipmentConfig.luau` was actually still correct (verified via the mesh's Weld — the head sits at +Y from the handle, matching `GripForward = (0,1,0)`). The bug was purely `GripPos = (0, 0.9, 1.0)`, which was tuned for the old mesh's proportions and pushed the new handle ~1 stud below and behind the hand.

**Fix derived, not guessed:** I equipped the known-good Iron pickaxe in Play mode, measured its Handle CFrame relative to `RightHand`, then solved algebraically for the Grip CFrame that puts the new mesh's handle in that exact same hand-relative pose (accounting for the new mesh's local Y being the forward axis instead of Iron's local -Z). Applied live and re-measured:
- New `GripPos = (0, 0.4, 0)` (down from `(0, 0.9, 1.0)`)
- Distance from handle to hand dropped from ~1.25 studs to 0.25 studs
- Clears `RightUpperArm` by 1.04 studs, overlaps `RightLowerArm` by 0.38 (fist wrapping the grip, same as the Iron reference)

Waiting on the screenshot to eyeball it before I write this to `EquipmentConfig.luau`.

---

