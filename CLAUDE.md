# CLAUDE.md

Guidance for Claude Code when working in this repository.
Auto-updated at end of every session. Last updated: 2026-06-30.

---

## Projects in this Repo

| Project | Folder | Stack |
|---|---|---|
| Tic Tac Toe | `tictactoe/` | Browser SPA, no build step |
| Mining Corporation (Roblox) | `roblox-game/` | Luau + Rojo + Studio MCP |

---

## Roblox Game: Mining Corporation

### Concept
A Roblox multiplayer mining/tycoon game. Players mine ore nodes, sell ore for coins,
purchase better equipment, unlock new regions, and complete mining contracts.

### Milestone Status
- **Milestone 1 (Scaffolding) — COMPLETE**: All folders, skeleton services, skeleton controllers,
  config modules, RemoteEvents, and StarterGui ScreenGuis are in place. Nothing is playable yet.
- **Milestone 2 and beyond**: Not started.

---

## Rojo Setup

**Installed:** Rojo v7.6.1 at `C:\Users\Taylor\.local\bin\rojo.exe`
**Project:** `roblox-game/`
**Project file:** `roblox-game/default.project.json`

**Folder mapping:**
| Disk path | In-game location | Type |
|---|---|---|
| `src/shared/Config/` | `ReplicatedStorage.Config` | Folder of ModuleScripts |
| `src/server/Bootstrap.server.luau` | `ServerScriptService.Bootstrap` | Script (auto-runs) |
| `src/server/Services/` | `ServerScriptService.Services` | Folder of ModuleScripts |
| `src/server/Data/` | `ServerScriptService.Data` | Folder with Script |
| `src/client/Controllers/` | `StarterPlayer.StarterPlayerScripts.Controllers` | Folder of LocalScripts |

**Declared in project.json (not file-backed, just exist as empty folders):**
- `ReplicatedStorage.Shared` — placeholder for future shared utilities
- `ReplicatedStorage.Assets` — placeholder for models/sounds
- `ServerScriptService.Systems` — placeholder for larger gameplay systems

**Created at runtime by Bootstrap (not in project.json):**
- `ReplicatedStorage.Remotes` — Folder containing all 6 RemoteEvents

**Created via MCP (not Rojo-managed):**
- `StarterGui.HUD`, `StarterGui.Shop`, `StarterGui.Market`, `StarterGui.Contracts`, `StarterGui.Settings`

**To start syncing:**
1. Open terminal in `roblox-game/` and run: `rojo serve`
2. In Studio: Rojo plugin → Connect
3. Scripts in `src/` live-sync into Studio automatically

---

## Studio MCP

An MCP server bridges Claude Code to Roblox Studio for placing world objects.

**Config:** `cmd.exe /c C:\Users\Taylor\AppData\Local\Roblox\mcp.bat` (project scope)

**Requirements:**
- Studio must be open with a place loaded before starting a Claude session
- Check the Plugins tab if MCP tools are unresponsive

---

## Architecture

### Security model
FilteringEnabled is ON. All economy and inventory mutations will be server-authoritative.
Clients fire RemoteEvents to request actions; server validates and responds.

### Naming convention
- `XxxService` = server-side module (in `ServerScriptService.Services`)
- `XxxController` = client-side LocalScript (in `StarterPlayer.StarterPlayerScripts.Controllers`)
- `XxxConfig` = shared config module (in `ReplicatedStorage.Config`)

### RemoteEvents (created by Bootstrap at runtime in `ReplicatedStorage.Remotes`)
| Name | Intended direction | Purpose |
|---|---|---|
| `MineOre` | C->S | Player requests to mine a node |
| `SellOre` | C->S | Player requests to sell inventory |
| `PurchaseEquipment` | C->S | Player buys a pickaxe/drill upgrade |
| `AcceptContract` | C->S | Player accepts a contract |
| `UnlockLicence` | C->S | Player purchases a region licence |
| `CollectDrillOutput` | C->S | Player collects output from an auto-drill |

---

## File Index

### Config (`src/shared/Config/`) — all return empty tables for now
| File | Will eventually contain |
|---|---|
| `OreConfig.luau` | Ore names, rarity, base sell prices, hit count to mine |
| `EquipmentConfig.luau` | Pickaxe/drill tiers, costs, mining speed multipliers |
| `RegionConfig.luau` | Region names, unlock costs, available ore types per region |
| `ContractConfig.luau` | Contract templates (target ore, quantity, reward) |
| `MarketConfig.luau` | Daily price multiplier bounds per ore type |

### Server (`src/server/`)
| File | Purpose |
|---|---|
| `Bootstrap.server.luau` | Creates Remotes folder + all RemoteEvents, then requires all services |
| `Services/OreService.luau` | Will scan Workspace for ore nodes, attach ProximityPrompts, handle respawn |
| `Services/InventoryService.luau` | Will manage per-player ore inventory and bag capacity |
| `Services/MarketService.luau` | Will calculate seeded daily ore sell prices |
| `Services/ContractService.luau` | Will generate, track, and reward mining contracts |
| `Services/EquipmentService.luau` | Will validate and apply pickaxe/drill purchase upgrades |
| `Services/RegionService.luau` | Will track unlocked regions per player, handle licence purchase |
| `Services/DataService.luau` | Will save/load player data via DataStore with autosave |
| `Data/DataService.server.luau` | Tests DataStore connection on startup; prints result to Output |

### Client (`src/client/`)
| File | Purpose |
|---|---|
| `Controllers/MiningController.client.luau` | Will handle mining VFX, animations, floating text (client-side visuals only) |
| `Controllers/InventoryController.client.luau` | Will display ore inventory and bag capacity on the HUD |

### StarterGui (created via MCP, not file-backed)
| Name | Will eventually contain |
|---|---|
| `HUD` | Coins, equipment tier, bag capacity bar |
| `Shop` | Equipment purchase UI |
| `Market` | Daily ore prices panel |
| `Contracts` | Active contracts and progress bars |
| `Settings` | Player settings/options |

---

## How to Verify Milestone 1

1. `rojo serve` in `roblox-game/`, connect in Studio
2. Press Play
3. Output window should show (in order):
   ```
   [Bootstrap] Created Remotes folder with 6 RemoteEvents
   [OreService] Loaded
   [InventoryService] Loaded
   [MarketService] Loaded
   [ContractService] Loaded
   [EquipmentService] Loaded
   [RegionService] Loaded
   [DataService] Loaded
   [Bootstrap] All services loaded — Mining Corporation server is ready!
   [MiningController] Loaded
   [InventoryController] Loaded
   [DataService] DataStore connection confirmed — PlayerData_v1 is accessible.
   ```
4. In the Explorer panel, confirm `ReplicatedStorage.Remotes` contains 6 RemoteEvents
5. In `StarterGui`, confirm HUD, Shop, Market, Contracts, Settings ScreenGuis exist

**If DataStore prints a warning instead:** Go to Game Settings → Security → tick
"Enable Studio Access to API Services", then Play again.

---

## Tic Tac Toe

Open `tictactoe/index.html` in a browser. No build step required.

**Architecture:** Single self-contained file. State in four module-level vars:
`board` (9-element array), `current` (X/O), `gameOver` (bool), `mode` (pvp/cpu).

**CPU AI:** Priority heuristic -- win > block > center > corner > random.
