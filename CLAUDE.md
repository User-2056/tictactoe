# CLAUDE.md

Guidance for Claude Code when working in this repository.
Auto-updated at end of every session. Last updated: 2026-06-29.

---

## Projects in this Repo

| Project | Folder | Stack |
|---|---|---|
| Tic Tac Toe | `tictactoe/` | Browser SPA, no build step |
| Mining Corporation (Roblox) | `roblox-game/` | Luau + Rojo + Studio MCP |

---

## Roblox Game: Mining Corporation

### Concept
A Roblox idle/active mining game. Players mine ore nodes, sell ore for coins,
upgrade pickaxes and bag capacity, and complete mining contracts.

### MVP Scope (Stage 1 -- IN PROGRESS)
- One mine (StarterMine region)
- 4 ore types: Stone, Coal, Iron, Gold
- 4 pickaxe tiers: Starter, Iron, Steel, Gold
- 5 bag capacity tiers
- 3 active contracts at a time (mine X of Y ore)
- Daily market price variation (seeded, deterministic)
- DataStore save/load with autosave every 60s

### NOT in Stage 1
- Multiple regions, automation, HQ, marketplace, crafting

---

## Rojo Setup

**Installed:** Rojo v7.6.1 at `C:\Users\Taylor\.local\bin\rojo.exe`
**Project:** `roblox-game/`

**Folder mapping:**
| Disk path | In-game location |
|---|---|
| `src/server/` | `ServerScriptService.Server` (Script) |
| `src/client/` | `StarterPlayer.StarterPlayerScripts.Client` (LocalScript) |
| `src/shared/` | `ReplicatedStorage.Shared` (Folder) |

**To start syncing:**
1. Open terminal in `roblox-game/` and run: `rojo serve`
2. In Studio: Rojo plugin -> Connect
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
FilteringEnabled is ON. All economy and inventory mutations are server-authoritative.
Clients fire RemoteEvents to request; server validates and responds.

### RemoteEvent flow
Mining and Selling use `ProximityPrompt.Triggered` (fires on server automatically).
All other client requests go through RemoteEvents in `ReplicatedStorage.Shared.RemoteEvents`.

### Dependency graph (server)
```
GameConstants
    <- DataService           (DataStore, cache, autosave)
    <- MarketService         (seeded daily prices)
    <- MiningService         (node scanning, ProximityPrompt, respawn)
         |-- onOreAwarded -->
    <- ContractService       (generate, track, reward)
    <- SellingService        (sell zone ProximityPrompt)
    <- UpgradeService        (pickaxe + bag upgrades)
    <- RemoteHandler         (binds client->server remotes)
```

### Data structure saved per player
```lua
{
    money                = 0,
    inventory            = { stone=0, coal=0, iron=0, gold=0 },
    pickaxeTier          = "Starter",
    capacityTier         = 1,         -- 1-5, see UpgradeConfig
    contracts            = { ... },   -- array of 3 contract tables
    contractsLastRefresh = 0,         -- os.time() of last refresh
    version              = 1,
}
```

---

## File Index

### Shared (`src/shared/`)
| File | Purpose |
|---|---|
| `GameConstants.luau` | All tunable numbers in one place |
| `RemoteEvents.luau` | String constants for every event name |
| `Config/OreConfig.luau` | Ore data + weighted random roll |
| `Config/PickaxeConfig.luau` | Pickaxe tier stats and costs |
| `Config/MarketConfig.luau` | Price multiplier bounds |
| `Config/UpgradeConfig.luau` | Bag capacity tier data |
| `Config/ContractConfig.luau` | Contract generation templates |

### Server (`src/server/`)
| File | Purpose |
|---|---|
| `init.server.luau` | Bootstrap: create remotes, init all services |
| `DataService.luau` | DataStore cache, autosave, schema migration |
| `MarketService.luau` | Seeded daily ore price calculation |
| `MiningService.luau` | Node scanning, ProximityPrompt, health, respawn |
| `SellingService.luau` | Sell zone prompt, inventory -> money |
| `UpgradeService.luau` | Pickaxe and bag upgrade validation |
| `ContractService.luau` | Contract gen, progress tracking, rewards |
| `RemoteHandler.luau` | Binds client->server remotes to service fns |

### Client (`src/client/`)
| File | Purpose |
|---|---|
| `init.client.luau` | Bootstrap: wait for remotes, init all modules |
| `RemoteProxy.luau` | Cached remote access (fire / connect helpers) |
| `HUDController.luau` | Money / pickaxe / bag overlay (top-left) |
| `MiningClient.luau` | Hit VFX, floating damage text |
| `InventoryUI.luau` | Ore list + market value, toggle I |
| `MarketUI.luau` | Today's prices panel (top-right) |
| `ShopUI.luau` | Pickaxe + bag upgrade shop |
| `ContractUI.luau` | Contract progress panel, toggle C |

---

## Studio World Setup (required before mining works)

MiningService scans Workspace for Parts with the `OreType` attribute.
SellingService scans for Parts with `IsSellZone = true`.
ShopUI scans for Parts with `IsPickaxeShop = true`.

**Ore nodes (place in a Model named StarterMine):**
- Part, Size ~(3,3,3), Anchored
- Attribute `OreType` (string): "stone" | "coal" | "iron" | "gold"
- Attribute `Region` (string): "StarterMine"
- Suggest 15 nodes: 7 stone, 5 coal, 2 iron, 1 gold

**Sell Zone:**
- Part, large flat, Anchored
- Attribute `IsSellZone` (bool): true
- SellingService attaches the ProximityPrompt automatically

**Pickaxe Shop:**
- Part, Anchored
- Attribute `IsPickaxeShop` (bool): true
- Add a child ProximityPrompt manually (ActionText = "Open Shop")
- ShopUI opens the GUI when the prompt fires client-side

---

## Key Bindings (in game)
- `I` -- toggle Inventory panel
- `C` -- toggle Contracts panel
- `E` -- activate nearby ProximityPrompt (mine / sell / open shop)

---

## RemoteEvents Reference

| Name | Direction | Payload |
|---|---|---|
| `Data_Update` | S->C | full player data table |
| `Mining_NodeDamaged` | S->All | {nodeId, healthRemaining, maxHealth} |
| `Mining_NodeRespawned` | S->All | {nodeId, oreType} |
| `Market_PricesUpdated` | S->All | {[oreType]: price} |
| `Sell_Result` | S->C | {success, moneyEarned, message} |
| `Upgrade_Result` | S->C | {success, type, newTier, message} |
| `Contract_Updated` | S->C | contracts array |
| `Upgrade_Pickaxe` | C->S | tier string |
| `Upgrade_Capacity` | C->S | (none) |
| `Contract_Refresh` | C->S | (none) |

---

## How to Test (Stage 1 checklist)

1. `rojo serve` in `roblox-game/`, connect in Studio
2. Press Play -> Output should show each service init line
3. HUD overlay appears top-left (coins: 0, Pickaxe: Starter, Bag: 0/50)
4. Market prices panel appears top-right
5. Place ore nodes in Workspace with OreType attribute -> ProximityPrompts appear
6. Mine node -> floating text, inventory updates, contracts track
7. Walk to Sell Zone -> sell all -> coins increase, inventory clears
8. Press I -> inventory panel shows ore quantities and coin values
9. Press C -> contract panel shows 3 contracts with progress bars
10. Go to shop -> buy pickaxe -> tier updates in HUD, mining is faster
11. Leave and rejoin -> coins and inventory persist (DataStore)

---

## Future Expansion Notes

- **Multiple regions**: Add region key to OreConfig, new Model in Workspace with Region attribute
- **Automation**: New AutomationService + AutoMiner instances; uses existing MiningService.handleSwing
- **HQ**: Separate place or top-level region; add HQService
- **Marketplace**: PlayerToPlayer trades via RemoteFunction + DataService transaction helpers
- **Crafting**: CraftingConfig + CraftingService; reads inventory via DataService.getPlayerData

---

## Tic Tac Toe

Open `tictactoe/index.html` in a browser. No build step required.

**Architecture:** Single self-contained file. State in four module-level vars:
`board` (9-element array), `current` (X/O), `gameOver` (bool), `mode` (pvp/cpu).

**CPU AI:** Priority heuristic -- win > block > center > corner > random.
