# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Projects in this Repo

This repo contains two separate projects:

1. **Tic Tac Toe** (`tictactoe/`) — a browser-based single-page app (no build step)
2. **Roblox Game** — built directly in Roblox Studio via the Studio MCP integration

## Roblox Studio Setup

The Roblox game is built using Claude Code connected to Roblox Studio via MCP (Model Context Protocol).

**How the connection works:**
- An MCP server (`StudioMCP.exe`) runs locally and connects to an open Roblox Studio session
- This allows Claude to create parts, models, scripts, and other objects directly inside Studio
- Config: `cmd.exe /c C:\Users\Taylor\AppData\Local\Roblox\mcp.bat` (local project scope)

**Requirements to use Studio MCP:**
- Roblox Studio must be open with a place loaded before starting a Claude Code conversation
- Start a fresh conversation in Cursor after opening Studio — the MCP tools load at conversation startup
- Check the Plugins tab in Studio if tools aren't responding

## Running the App

Open `tictactoe/index.html` directly in a browser — no build step, server, or dependencies required.

## Architecture

The entire app lives in `tictactoe/index.html` as a single self-contained file: HTML structure, CSS styles, and JavaScript logic are all inline.

**Game state** is held in four module-level variables: `board` (9-element array), `current` (active player, `'X'` or `'O'`), `gameOver` (boolean), `mode` (`'pvp'` or `'cpu'`), and `score` (persists across resets via the `score = score || ...` guard in `init()`).

**CPU AI** (`bestMove`) is a priority-ordered heuristic, not minimax: win if possible → block opponent win → take center → take a random corner → take any open cell. It plays as `'O'` and fires after a 350 ms delay via `setTimeout`.

**Win detection** checks all 8 winning lines defined in `WINS` against the current `board` array. The same `winner()` helper is reused both for `checkResult()` (end-of-turn check) and inside `bestMove()` (look-ahead simulation with temporary board mutations that are immediately reverted).

**DOM rendering** is a full re-render on every move: `render()` rewrites all 9 cell `textContent` and `className` values from scratch each call.
