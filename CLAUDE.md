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
  config modules, RemoteEvents, and StarterGui ScreenGuis are in place.
- **Milestone 2 (Core Mining Loop) — COMPLETE**: OreConfig populated (4 ores); 14 ore nodes in
  `Workspace.StarterMine`; full mining loop (click → server validate → damage → crack visuals →
  health bar → break → award → respawn); Pickaxe Tool in StarterPack (MINING_POWER=25, Tier 1);
  hit/break sounds + dust particles fire to all clients; ore reward popup on break;
  no per-hit damage numbers; server-authoritative throughout.
- **Milestone 3 (Inventory System) — COMPLETE**: InventoryService with weight-based capacity (100 kg);
  per-player server-authoritative inventory; HUD bag panel (weight bar + ore list); blocked-hit
  feedback when full (hollow sound + Inv_Full red toast + HP bar visible but no damage applied).
- **Milestone 4 (Selling & Credits) — COMPLETE**: EconomyService with per-player Credits balance;
  Atlas Ore Exchange kiosk in Workspace at (0, 3.5, −30) with ProximityPrompt; SellController
  opens sell dialog (ore list + prices + grand total + Sell All button); server recalculates total
  from its own inventory on SellOre — no client value trusted; Credits label top-left of HUD;
  metallic coin-clink sell sound (rbxassetid://9125616843).
- **Milestone 5 (Equipment Shop) — COMPLETE**: EquipmentConfig populated (3 pickaxes, 4 backpacks);
  EquipmentService tracks owned + equipped per player (ownership is permanent — players can switch
  between owned items via Equip button); Frontier Mining Supplies kiosk in Workspace at (15, 4, −18)
  with ProximityPrompt; ShopController two-column UI (pickaxes / backpacks) with Equipped/Equip/Buy
  button states and "Owned" price label; real MiningPower (×1/×2/×4 base-25 damage) replaces hard-
  coded value in OreService; real Capacity replaces hard-coded 100 kg in InventoryService; upgrade
  toast + rupee chime on purchase; "no ores to sell" toast at sell kiosk when bag empty;
  DevCommands Studio-only script: `/credits N` and `/ore <type> N` (respects bag capacity).
- **Milestone 6 and beyond**: Not started.

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

**Also declared in project.json (individual server scripts):**
- `ServerScriptService.DevCommands` — Studio-only dev command script (`src/server/DevCommands.server.luau`)

**Created at runtime by Bootstrap (not in project.json):**
- `ReplicatedStorage.Remotes` — Folder containing all 16 RemoteEvents

**Created via MCP (not Rojo-managed):**
- `StarterGui.HUD`, `StarterGui.Shop`, `StarterGui.Market`, `StarterGui.Contracts`, `StarterGui.Settings`
- `Workspace.AtlasOreExchange` — sell kiosk at (0, 3.5, −30) with ProximityPrompt
- `Workspace.PickaxeShop` — equipment shop kiosk at (15, 4, −18), 10×8×2, with ProximityPrompt "ShopPrompt"

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
| Name | Direction | Purpose |
|---|---|---|
| `MineOre` | C→S | Player requests to mine a node |
| `SellOre` | C→S | Player requests to sell inventory |
| `PurchaseEquipment` | C→S | Player buys a pickaxe/drill upgrade |
| `AcceptContract` | C→S | Player accepts a contract |
| `UnlockLicence` | C→S | Player purchases a region licence |
| `CollectDrillOutput` | C→S | Player collects output from an auto-drill |
| `Ore_VeinHit` | S→all | Vein took damage — payload: veinName, healthPct |
| `Ore_VeinBroke` | S→all | Vein destroyed — payload: veinName |
| `Ore_VeinSpawned` | S→all | Vein respawned — payload: veinName, newOreType |
| `Ore_OreAwarded` | S→miner | Ore awarded to mining player — payload: oreType, amount |
| `Inv_Update` | S→player | Inventory snapshot — payload: items, currentWeight, maxWeight |
| `Inv_Full` | S→player | Bag is full; triggers red toast and hollow sound |
| `Ore_HitBlocked` | S→player | Hit registered but no damage (inventory full) — payload: veinName |
| `Eco_CreditsUpdate` | S→player | Credits balance changed — payload: balance (number) |
| `Eq_Update` | S→player | Equipment snapshot — payload: pickaxeId, backpackId, ownedPickaxes[], ownedBackpacks[] |
| `EquipItem` | C→S | Player equips an already-owned item — payload: itemType, itemId |

---

## File Index

### Config (`src/shared/Config/`)
| File | Status | Contains |
|---|---|---|
| `OreConfig.luau` | ✅ M2 | Stone/Coal/Iron/Gold — BaseValue, Weight, SpawnChance, VeinHP, RespawnSeconds, Color |
| `EquipmentConfig.luau` | skeleton | Pickaxe/drill tiers, costs, mining speed multipliers |
| `RegionConfig.luau` | skeleton | Region names, unlock costs, available ore types per region |
| `ContractConfig.luau` | skeleton | Contract templates (target ore, quantity, reward) |
| `MarketConfig.luau` | skeleton | Daily price multiplier bounds per ore type |

### Server (`src/server/`)
| File | Status | Purpose |
|---|---|---|
| `Bootstrap.server.luau` | ✅ M5 | Creates Remotes folder + 16 RemoteEvents, then requires all services |
| `DevCommands.server.luau` | ✅ M5 | Studio-only: `/credits N`, `/ore <type> N` for Thxnderz_z only |
| `Services/OreService.luau` | ✅ M5 | Mining loop; damage = EquipmentService.getMiningPower × 25 |
| `Services/InventoryService.luau` | ✅ M5 | Per-player inventory; per-player maxWeight via setMaxWeight |
| `Services/EconomyService.luau` | ✅ M4 | Per-player Credits balance; handles SellOre; deductCredits |
| `Services/EquipmentService.luau` | ✅ M5 | Owned + equipped tracking; PurchaseEquipment + EquipItem handlers |
| `Services/MarketService.luau` | skeleton | Will calculate seeded daily ore sell prices |
| `Services/ContractService.luau` | skeleton | Will generate, track, and reward mining contracts |
| `Services/RegionService.luau` | skeleton | Will track unlocked regions per player, handle licence purchase |
| `Services/DataService.luau` | skeleton | Will save/load player data via DataStore with autosave |
| `Data/DataService.server.luau` | ✅ M1 | Tests DataStore connection on startup; prints result to Output |

### Client (`src/client/`)
| File | Status | Purpose |
|---|---|---|
| `Controllers/MiningController.client.luau` | ✅ M2 | Tool.Activated → MineOre; plays hit/break VFX + sounds; health bar visibility; ore popup |
| `Controllers/InventoryController.client.luau` | ✅ M4 | Bag panel (weight bar + ore list); full toast; Credits label top-left of HUD |
| `Controllers/SellController.client.luau` | ✅ M5 | Atlas Ore Exchange ProximityPrompt → sell dialog; Sell All; "no ores" toast |
| `Controllers/ShopController.client.luau` | ✅ M5 | Frontier Mining Supplies ProximityPrompt → equipment shop; Equipped/Equip/Buy states |

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
