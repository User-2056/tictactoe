# CLAUDE.md

Guidance for Claude Code when working in this repository.
Auto-updated at end of every session. Last updated: 2026-06-30 (post-M5 visual pass).

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
- **Visual Pass (Ore Vein Clusters) — COMPLETE**: All 14 ore nodes in `Workspace.StarterMine`
  replaced from plain coloured cubes to multi-part rock clusters. Each primary `BasePart` (still
  owned by OreService) gains satellite children: rock body pieces (`Rock` material, grey) that
  partially embed into the cave floor, plus ore-specific pieces (Slate/CorrodedMetal/Foil for
  coal/iron/gold). MiningController drives all satellite visuals client-side without touching
  OreService: crack stages (`Rock→Concrete→Slate` at 66%/33% HP on rock satellites, colour fade
  on ore satellites); progressive break-off (peripheral pieces fly radially outward at ore-specific
  HP thresholds — e.g. gold loses 3 pieces at hits 6, 11, 16 of 20); final break uses Back.In
  suck-in tween on remaining pieces; respawn restores all CFrames, sizes, materials. Health bar
  shrunk to 64×7 px, StudsOffset lifted to 3.8 studs above cluster. Gold veins have PointLight
  (amber, range 14) managed by OreService. Clicks on satellite children now correctly route to
  the parent vein. No OreService changes — purely a visual layer.
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
- `Workspace.StarterMine` — cave folder (floor Y=0, ceiling Y=14, walls X=±42, back wall Z=−116)
  containing 14 ore node `BasePart`s with satellite cluster children:
  - stone ×5: primary + 2 rock satellites, no ore pieces
  - coal ×4: primary + 1 rock satellite + 2 Slate ore pieces
  - iron ×3: primary + 1 rock satellite + 2 CorrodedMetal ore pieces
  - gold ×2: primary + 1 rock satellite + 3 Foil ore pieces + PointLight
  Rock satellites have `Role="rock"` attribute; ore pieces have `Role="ore"`. All satellites are
  Anchored children of the primary Part (OreService only ever touches the primary).

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
| `EquipmentConfig.luau` | ✅ M5 | 3 pickaxes (MP×1/2/4, ₡0/2500/25000) + 4 backpacks (100–1000 kg, ₡0–35000) |
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
| `Controllers/MiningController.client.luau` | ✅ VP | Tool.Activated → MineOre (satellite-click-aware); crack stages + progressive piece break-off; break/respawn animations; health bar; ore popup |
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

## How to Verify Current State (post-M5 + Visual Pass)

1. `rojo serve` in `roblox-game/`, connect in Studio
2. Press Play
3. Output window should include (server side, in roughly this order):
   ```
   [Bootstrap] Created Remotes folder with 16 RemoteEvents
   [InventoryService] Loaded
   [EquipmentService] Loaded
   [EconomyService] Loaded
   [OreService] Loaded — 14 veins registered
   [MarketService] Loaded
   [ContractService] Loaded
   [RegionService] Loaded
   [DataService] Loaded
   [Bootstrap] All services loaded — Mining Corporation server is ready!
   [DevCommands] Loaded (Studio only) — /credits <n>  |  /ore <type> <n>
   ```
   And on the client side:
   ```
   [MiningController] Loaded
   [InventoryController] Loaded
   [SellController] Loaded
   [ShopController] Loaded
   [DataService] DataStore connection confirmed — PlayerData_v1 is accessible.
   ```
4. In the Explorer panel, confirm `ReplicatedStorage.Remotes` contains **16** RemoteEvents
5. In `StarterGui`, confirm HUD, Shop, Market, Contracts, Settings ScreenGuis exist
6. In `Workspace.StarterMine`, confirm ore nodes have Rock/Ore satellite children visible in Explorer
7. Pick up the Pickaxe from StarterPack and mine an ore node — you should see:
   - Satellite pieces crack (material changes) as health drops
   - Peripheral pieces fly outward at HP thresholds (e.g. coal Ore2 breaks on 2nd hit)
   - Dust particles and hit sound on each swing
   - Health bar appears above the cluster when you're within range
   - "+1 Coal" (or equivalent) popup on break
8. Walk to the Atlas Ore Exchange kiosk (at Z=−30) and sell ore
9. Walk to the Frontier Mining Supplies kiosk (near X=15) and browse the equipment shop

**If DataStore prints a warning instead:** Go to Game Settings → Security → tick
"Enable Studio Access to API Services", then Play again.

---

## Tic Tac Toe

Open `tictactoe/index.html` in a browser. No build step required.

**Architecture:** Single self-contained file. State in four module-level vars:
`board` (9-element array), `current` (X/O), `gameOver` (bool), `mode` (pvp/cpu).

**CPU AI:** Priority heuristic -- win > block > center > corner > random.
