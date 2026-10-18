# Real Time Roleplay (RefugeeRP)

A post-apocalyptic roleplay gamemode for Garry's Mod, written in Lua. It is the
TacoScript framework by Rick Darkaliono (started March 23, 2007, completed March
8, 2008), converted and extended by Josh Bazar (JT) into "RefugeeRP" for the
[Real Time Roleplay (RTRP)](https://steamcommunity.com/groups/rtrp) community.
The gamemode announces itself as "RefugeeRP 2.0 Relaunched" (`GM.Name` in
`gamemode/init.lua`).

The in-game backstory (F1 help menu, `gamemode/cl_help.lua`) sets the game in
2019, eleven years after a nuclear war, in the town of Shady Sands in a sheltered
valley of the Nevada desert. Two armed factions fight over the town: the National
Republic Dawn (NRD), who impose law and order, and the New Soviet Revolutionary
Front (NSRF), who want to overthrow them. Everyone else is a survivor.

Real Time Roleplay ran RefugeeRP on the [rp_cscdesert_v2-1](https://steamcommunity.com/sharedfiles/filedetails/?id=110345906) map in Garry's Mod. This repository holds the gamemode code only. No maps, models, materials, database schema or data files are included.

## What it was built on

**Garry's Mod of its era.** The code uses the pre-GMod 13 Lua API throughout:
`umsg` and `usermessage` networking, `ValidEntity`, `file.FindInLua`, the old
`surface.CreateFont` signature, and the old `timer.Simple(delay, func, args...)`
form. It derives from `sandbox`.

**The gamemode folder was named `TacoScript`.** Item scripts are loaded with
`file.FindInLua("TacoScript/gamemode/items/*.lua")` and custom content is
registered from `TacoScript/content/`. The name is hard-coded: with any other
folder name, no items load.

**A `mysql` binary module.** `gamemode/init.lua` calls `require("mysql")` and the
code uses `mysql.connect(host, user, pass, db, port)`, `mysql.query(db, sql)`,
`mysql.escape(db, str)` and `mysql.disconnect(db)`. If the module is missing the
code stubs it out (`MYSQL_DED = true`) so the gamemode can load without it: there
are no accounts, no character saves, and players get a random citizen model.

**Database credentials.** `TS.ConnectToSQL` and `TS.CheckSQLStatus` in
`gamemode/server_events.lua` both contain the placeholders `SQL_HOST`,
`SQL_USER`, `SQL_PASSWORD` and `SQL_DATABASE`. The real values were never committed.

**MySQL tables.** No schema file ships with the code. These are the tables and
columns the code reads and writes:

| Table | Purpose | Columns used |
|---|---|---|
| `rtrp_users` | one row per Steam account | `uID`, `UserName`, `Password`, `STEAMID`, `groupID`, `UserFlags`, `AdminFlags`, `serverIP`, `serverPort` (read by position: `uID` is column 1, `UserFlags` 4, `AdminFlags` 5) |
| `rtrp_characters` | one row per character | `userID`, `charName` (column 4), `CID`, `charTokens`, `charModel`, `charAge`, `charJob`, `charTitle`, `charBio`, `charRace`, `weapons`, `ammo`, `items`, `statStrength`, `statAIM`, `statEndurance`, `statSprint`, `statMedic`, `statSpeed`, `statSneak`, `loanAmount`, `loanRemain`, `loanCanGet`, `BusinessOwn`, `BusinessName`, `BusinessMoney`, `BusinessSupplyLicense`, `BusinessSupplyLicenseTypes`, `BusinessItems`, `SaveVersion`, `playerflags`, `combineflags` |
| `rtrp_donations` | donor perks | `STEAMID`, `MaxRagdolls`, `MaxProps`, `CustomModel`, `CustomModelName`, `CustomAvatar` |
| `rtrp_realtimedonations` | queued credit and stat grants, polled every 5 minutes | `SteamID`, `charName`, `Fail`, then tokens and the seven stats, read by position |
| `rtrp_sqlverify` | any table the server can `SELECT *` from; used as a connection check every 30 seconds | none |

Three more tables live in the server's local SQLite store and are created
automatically: `rtrp_doors` (door ownership for the current session),
`rtrp_toollog` and `rtrp_proplog`.

**Data files** are read from the server's data folder under `TacoScript/`:

| Path | Read by | Format |
|---|---|---|
| `TacoScript/data/teams.txt` | `TS.ParseTeams` | blocks of `TEAM_START` ... `TEAM_END` with `TEAM_ID`, `TEAM_NAME`, `TEAM_COLOR r g b a`, `TEAM_JOB`, `TEAM_MODEL`, `TEAM_WEAPON`, `TEAM_WEAPONAMMO type amount`, `TEAM_ARMOR`, `TEAM_BONUSHEALTH`, `TEAM_ITEM`. This is the only place `team.SetUp` is called, so without it factions have no names or colors |
| `TacoScript/mapdata/<map>.txt` | `TS.CreateDoorInfo` | `BEGINBUILDING "Name"`, then one door per line as `x y z "Door name" "Property name" state price`, then `ENDBUILDING`. Door states 1, 2 and 3 start locked. State 0 doors can be bought by anyone, states 1 and 3 only by NRD or NSRF, and state 2 by nobody. Without this file property pricing is off and every door costs 50 credits |
| `TacoScript/data/cids.txt` | `TS.LoadCIDs` | one citizen ID per line; `/cid` appends to it |
| `TacoScript/data/physgunbans.txt` | `TS.LoadPhysgunBans` | one SteamID per line |
| `TacoScript/data/economymoney.txt` | startup | a single number, the server economy pool |
| `TacoScript/logs/` | `TS.Log`, `TS.DayLog` | written, not read: chat, kills, joins, business drops, with per-day copies under `logs/daylogs/MM-DD-YYYY/` |

**Custom content** goes in a `content/` folder inside the gamemode folder.
`gamemode/resources.lua` sends clients everything under `content/models/ODST/`
(NRD models), `content/models/srpmodels/` and `content/materials/models/player/loner1..3/`
(NSRF models), plus the fists, stun stick and MSG-90 sniper models and materials.
None of these files are in this repository.

**Maps.** `gamemode/custom_spawnpoints.lua` hard-codes survivor and faction spawn
points for `rp_central17_v3_dsrp` only; on any other map players use the map's
own spawns, which is what this code does on rp_cscdesert_v2-1.
`gamemode/maps/rp_tb_city45_v01.lua` removes the `ind_checkpointdoor` entities on
that map, but see Known issues: the include that would load it names a different
file.

**No gamemode manifest.** The repository has no `info.txt` (or GMod 13 style
`<name>.txt`), so the one the server ran with is not in the repo.

## Gameplay

### Joining and characters

1. A new Steam account gets a six question quiz (`gamemode/cl_quiz.lua`). One wrong
   answer kicks the player; a second failure bans them for 30 minutes.
2. After the quiz the player registers a username (3 to 16 characters) and
   password (6 to 32), or logs in to an existing account. Accounts are keyed to
   SteamID in `rtrp_users`.
3. Character creation asks for a first and last name (console command `setname`),
   one of 30 citizen models (18 male, 12 female, from `TS.Models`), an age from 16
   to 65, a race, a description under 100 characters, and 15 stat points to spend.
   Every character starts with 115 credits and base stats of Strength 35,
   Endurance 35, Sprint 33, Speed 8, Aim 20, Medic 5 and Sneak 1
   (`gamemode/player_vars.lua`); the 15 points cannot push a stat past 50.
   An account can hold up to 9 characters (`MAX_CHARACTERS`). `rp_listsaves`,
   `rp_choosechar` and `rp_deletesave "Name"` manage them; `rp_changename`
   renames the current one.
4. Characters save to MySQL every 3 minutes and on most transactions. Weapons in
   the inventory are stored as `WEAPON_<class>` entries in the `items` column and
   are given back on load.

Keys: F1 opens the help menu, F3 the player menu (Stats, Inventory, Finance,
Biography, Workshop, Business, and a supplies panel for NRD and NSRF), F4 owns or
releases the door or vehicle you are looking at, and also opens the action menu
when you look at a player or an item with actions. `rp_toggleholster` holsters
the current weapon and the client convar `rp_headbob` controls head bobbing.
`rp_thirdperson` is registered but disabled: it prints "DISABLED OK?" and
returns.

### Factions

| Team | Name | How to join | Loadout on spawn |
|---|---|---|---|
| 1 | Survivor | default; `/survivor` returns to it | Hands, Keys, Medic tool, physgun, gravity gun |
| 2 | National Republic Dawn (NRD) | `/nrd` with combine flag `A` or admin; admins can force with `rp_nrd` | random ODST model, 50 armor, 9mm pistol, MP7, radio |
| 3 | New Soviet Revolutionary Front (NSRF) | `/nsrf` with combine flag `B` or admin; `rp_nsrf` | random `srpmodels/loner` model, 50 armor, HK P46, AK47, MP5K, radio |

Teams 4, 5 and 6 are still referenced by leftover Half-Life 2 Combine code
(`IsCombine`, `IsCombineDefense`, special models on spawn), but every command that
joined them is commented out. `rp_combineroster` lists characters with faction
flags and prints the flag legend.

The code treats NRD and NSRF as one group (`IsCombineDefense` covers teams 2 to
4, `IsCombine` teams 2 to 5), so both factions share the same extras: a supply
count (`CombineRations`, 30, refilled every 10 minutes) that `rp_dropration`
draws from, the `Get CID` and `Pat Down` actions on survivors (F4), `/bc`
faction broadcast, `rp_playline` voice lines, and the supplies panel in F3. A
faction radio frequency (`CombineRadioFreq`) is generated at startup, but the
code that handed it out is commented out, so nothing uses it.

### Stats and damage

Seven stats run from 0 to 100 and rise through use (`gamemode/player_stats.lua`):

| Stat | Effect | Raised by |
|---|---|---|
| Strength | punch and stun baton damage | landing punches and stun baton hits |
| Speed | walk and sprint speed | sprinting |
| Sprint | stamina drain rate and recovery | sprinting |
| Endurance | max health (65 plus Endurance), regeneration, bleeding resistance, KO recovery, and less damage taken from punches, stun batons and bullets | taking melee damage, sprinting |
| Aim | bullet spread, weapon sway and bob | hitting a player from more than 350 units away |
| Medic | heal and bandage time, and how much a used Bandage heals | bandaging with the Medic tool |
| Sneak | crouch movement speed | moving while crouched |

Gains shrink as a stat grows. Food, drink and clothing can give temporary boosts
(`TempStatBoost`). A stat decay loop exists in `player_server.lua` but is
commented out.

Max stamina is tracked separately from the stats. Survivors lose 0.1 of it per
minute and a little more while sprinting; food, drink and supply crates add it
back (`AddMaxStamina`, floor 18, cap 100). NRD and NSRF reset to 100 on every
spawn.

Damage is tracked per hit group (`gamemode/player_dmg.lua`). Arm and leg health
drop separately from the health bar, wounded legs slow you down, and wounds can
start bleeding. Bleeding costs health and stamina over time until it clots or a
bandage stops it. A consciousness meter drops from punches and stun baton hits;
at zero the player is knocked out as a ragdoll and recovers at a rate set by
Endurance. `/passout` and `/getup` do it voluntarily. Morphine restores
consciousness, but five doses within three minutes cause an overdose.

Death is meant to strip the inventory of weapons, drop the last held weapon if a
player did the killing, and log the kill, but see Known issues: a stray `return`
in `GM:PlayerDeath` cuts this short, and the ammo strip is a no-op. A player
killed while tied up or knocked out respawns where they died.

### Inventory and items

Items are defined one per file in `gamemode/items/` with `ITEM.Name`, `Weight`,
`Size`, `Model`, `Desc`, `Usable`, `Wearable`, factory price and stock, supply
license, and optional `OnUse`, `OnPickup`, `OnDrop` and `CanPickup` hooks. Dropped
items are `item_prop` entities (`entities/entities/item_prop/`). Inventory
capacity is 4 size units. A Backpack is meant to raise it to 12 (32 for NRD and
NSRF), but it only changes the number shown to the client; the server's room
check never sees it (see Known issues).

| Item | Notes |
|---|---|
| Food and drink: Banana, Orange, Melon, MRE, Soda, Bottled Water, Vitamin Water, Beer, A Case of Beer, Vodka | restore health or stamina; some give short stat boosts |
| Medical: Bandage, Medicine, Morphine | bandage stops bleeding, morphine restores consciousness; Medicine has no use action |
| Equipment: Backpack, Radio, Paper, The Metro Informer (newspaper) | radio enables `/r`, paper enables `/write`, the newspaper opens a reader |
| Clothing: Rebel Combat Clothing, Rebel Medic Clothing | change outfit with `/rebelclothes`, `/medicclothes`, `/citizenclothes` |
| Supply Crate | gives 50 credits, 5 health and 70 max stamina when used; NRD and NSRF cannot keep one, picking it up returns it to the faction supply count |
| Weapons: NRD Standard Issue Pistol, HK P46, MP5K, MP7, AK47, SPAS 12-Gauge Shotgun, Combine CISR-762 | picking one up gives the matching SWEP |
| Ammo: Pistol Rounds x30, SMG Rounds x45, Buckshot x20 | picking one up adds ammo |

### Weapons

All SWEPs live in `entities/weapons/`. Guns derive from `weapon_ts_base`, which
adds ironsights, holstering, view sway and bob, and spread that scales with the
Aim stat.

| Class | Name | Use or ammo pool |
|---|---|---|
| `ts_hands` | Hands | left click punches, or knocks on a door while holstered; right click blocks, or unties while holstered; reload rams a door |
| `ts_keys` | Keys | left click locks, right click unlocks |
| `ts_medic` | Medic | left click heals others, right click heals yourself, reload plus click bandages. Healing needs a `healthvial` item that no item file defines, so only bandaging works |
| `weapon_ts_zipties` | Zip Ties | tie up or untie a player (5 second action) |
| `weapon_ts_enforcer` | National Republic Dawn Enforcer | stun baton |
| `weapon_ts_pistol` | 9mm Standard Sidearm | pistol |
| `weapon_ts_glock18c` | Glock 18C | pistol |
| `weapon_ts_p228` | Sig P228 | pistol |
| `weapon_ts_357` | 357 Magnum | pistol |
| `weapon_ts_hkp46` | HK P46 | pistol |
| `weapon_ts_ak47` | AK47 | pistol |
| `weapon_ts_mp5k` | MP5K | smg1 |
| `weapon_ts_mp7` | MP7 | smg1 |
| `weapon_ts_tmp` | Special Issue SMG | smg1 |
| `weapon_ts_styersniper` | Styer Elite Sniper | smg1 |
| `weapon_ts_sniper` | FN-2000 Sniper | ar2 |
| `weapon_ts_12gauge` | SPAS-12 Shotgun | buckshot |
| `weapon_ts_beanbagshotgun` | NL Beanbag Shotgun | buckshot |
| `weapon_ts_breachingshotgun` | Door Breaching Shotgun | buckshot |
| `weapon_ts_fragnade` | Frag Grenade | rpg |
| `weapon_ts_flashnade` | Flash Grenade | rpg |

`entities/weapons_old/` holds earlier versions of the same SWEPs plus eight that
are no longer in the active set (38 revolver, ACU, AR2, Christmas gun, Combine
sniper, god fist, god hand, stun stick). Garry's Mod does not load that folder.

### Doors and property

Look at a door or vehicle and press F4 to buy it. If the map has a mapdata file,
doors belong to named properties with their own prices and buying one door buys
the whole property. Otherwise any door costs 50 credits. Vehicles are free.
`/adddoorowner`, `/removedoorowner`, `/addpropertyowner`, `/removepropertyowner`
and `/getdoorowners` share access, `/doortitle` renames a door, and admins have
`rp_findowner`, `rp_unowndoor` and `rp_unownproperty`. Ownership is stored in the
SQLite `rtrp_doors` table for the current server session and is meant to be
released 8 minutes after the owner disconnects (see Known issues). Locked doors
can be rammed with the Hands weapon or `rp_ramdoor`; survivors succeed one time
in five, NRD one in two, and NSRF every time.

### Money and business

Credits are the currency. Players earn them from each other, from NRD supply
crates (50 each), and from businesses. `/givemoney <amount>` pays the player you
are looking at. `/dropmoney <amount>` is meant to drop cash but errors (see
Known issues). `/adv <text>` posts a server wide advertisement for 25 credits.

A business is created from the F3 Business tab (`rp_createbusiness <name>`). It
has its own bank account (`rp_givebusinessmoney`, `rp_takebusinessmoney`), a job
title, and a stock list. Buying stock from the factory debits the business
account and spawns the item in front of you. Stock is gated by supply licenses
bought with personal credits:

| License | Covers | Cost |
|---|---|---|
| 1 Food/Drink | food, drinks | 300 |
| 2 Travelers | Backpack, Radio, Paper | 175 |
| 3 Medical | Bandage, Medicine, Morphine, newspaper; rebel clothing needs this license and black market access | 225 |
| 4 Black market | weapons, ammo, supply crates | free, but needs player flags |

Black market items also require player flag `X` to stock and flag `F` to buy
through the rebel channel. Rebel purchases do not cost credits; each item has a
`RebelCost` that is drawn from a server wide "Rebel Weaponry" meter (0 to 100,
drawn over the F3 menu for players with flags `F` and `X`) which refills by a
third every 10 minutes. The newspaper needs flag `N`.

Loans are offered on the Finance tab (`rp_takeloan`, `rp_payloan`) but are capped
by the `maxoweamount` server variable, which is 0 in `gamemode/server_vars.lua`,
so loans were effectively disabled.

### Chat

With the default `alltalk = 1` setting, plain chat is local: it reaches 230 units.
Whisper reaches 90 and yell 490 (`gamemode/server_vars.lua`). Commands are
matched by prefix in `gamemode/rp_chat.lua`.

| Command | Does |
|---|---|
| `//`, `/a`, `((`, `/ooc`, `[OOC]` | global out of character chat (admins can add a delay with `rp_oocdelay`) |
| `.//`, `[[` | local out of character chat |
| `/w`, `/y` or `/yell`, `/an` | whisper, yell, speak anonymously (`/an` still prints the speaker's name to every console) |
| `/me`, `/it` | third person action, scene description |
| `/r <text>` | radio, if you carry a Radio (`rp_changefrequency` tunes it) |
| `/pm <name> <text>` | private message |
| `/title` or `/job` | set the title other players see, up to 32 characters |
| `/write` | write a letter on Paper; letters are read with the use key |
| `/cid <number>` | survivors only: claim a five digit citizen ID, once per character |
| `/givegun`, `/dropgun` | hand your weapon to the player you face, or drop it |
| `/help` | open the help menu |
| `/ev <text>` | admin only: broadcast an event line |
| `!kick`, `!ban`, `!slay`, `!slap`, `!explode`, `!goto`, `!bring`, `!noclip`, `!a` | shortcuts for the matching `rp_` admin commands; `!a` talks to admins |

### Workshop

The F3 Workshop tab lets you pick inventory items as ingredients and
`gamemode/workshop.lua` searches `TS.ItemMixtures` for a matching recipe. The
only recipe (`gamemode/mixtures.lua`) is kool-aid from bottled water and kool-aid
powder, neither of which exists as an item, and `TS.MixItems` never creates the
result. The system was never finished; `cl_workshop.lua` is headed
"Scrapped Dec 17 2007".

## Administration

Admin status comes from Garry's Mod user groups (`admin`, `superadmin`, plus a
custom `rda` group) and from `AdminFlags` in `rtrp_users`: flag `A` unlocks
`rp_rcon`, `rp_freechar` and `rp_setfactionflags` for non-superadmins. Player
flag `E` lets a player set other players' flags with `rp_setplayerflag`, and
combine flag `E` lets a faction member set faction flags. On a listen server or
LAN the host's SteamID is `STEAM_ID_LAN` or `UNKNOWN`, which `IsRick` treats as
the developer: automatic superadmin, tool trust group 10 with 1000 prop and
ragdoll limits, every tool mode, prop spawns that are not logged, and a God Hand
on spawn. An obfuscated block at the end of `gamemode/concmd.lua` (encoded with
`TS.Hashify`) redefines `IsRick` a minute after startup to add two hard-coded
SteamIDs to that list (replaced with `STEAM_REDACTED` in this copy).

Server variables are set from console (`gamemode/admin_cc.lua`):
`rp_allowtools 0|1`, `rp_propspawning 0|1`, `rp_oocdelay <seconds>`,
`rp_maxttprops <n>`, `rp_allowmaxstats 0|1`.

Player management: `rp_kick`, `rp_ban <name> <minutes>` (1 to 120 unless
superadmin), `rp_pban` (permanent, by SteamID; the IP ban line is commented out),
`rp_slay`, `rp_slap`, `rp_explode`, `rp_goto`, `rp_bring`, `rp_noclip`, `rp_god`,
`rp_observe`, `rp_seeall`, `rp_physgunban`, `rp_physgununban`, `rp_name` (demand
a roleplay name), `rp_sendnotice <time> <msg>`, `rp_asay` and `consay`.
`rp_rickroll` is developer only: it slaps and explodes the target and opens
yougotrickrolled.com on their screen.

Characters and flags: `rp_givemoney`, `rp_adminaddmoney`, `rp_admingivestat`,
`rp_setplayermodel`, `rp_setplayerflag`, `rp_setfactionflags`, `rp_setadminflag`,
`rp_setgroup`, `rp_whohaschar`, `rp_freechar`, `rp_reloadcharacter`,
`rp_savecharacter`, `rp_reloaduserflags`, `rp_reloadflags`, `rp_nrd`, `rp_nsrf`,
`rp_survivor`.

Building: `rp_addtooltrust`, `rp_removetooltrust`, `rp_addttsteamid`,
`rp_addadvttsteamid`, `rp_removettsteamid`, `rp_ttlist`. Tool trust is the
`groupID` column in `rtrp_users`: 1 is a regular player (10 props), 2 gets the
toolgun with weld, weld_ez and remover only and 15 props, 3 and up get every tool
mode. `rtrp_donations` can raise prop and ragdoll limits per player. Non trusted
players get a 10 second cooldown after more than three quick prop spawns,
explosive barrels and gas cans are banned, and every prop spawn and tool use is
logged to SQLite and shown by `rp_proplog` and `rp_toollog`. `rp_rcon` runs a console command,
`rp_restartmap` reloads the map, and `rp_npccreate`, `rp_npctarget` and
`rp_npchealth` manage scripted NPCs. `gm_giveswep` and `gm_spawnswep` need admin.

Background timers in `gamemode/init.lua`: character save every 3 minutes, SQL
reconnect check every 30 seconds, rebel weaponry refill and NRD ration refill
every 10 minutes, donation check and an F1 reminder every 5 minutes, and a purge
of door ownership rows from earlier sessions 12 minutes after startup.

## Repository layout

```
entities/
  entities/item_prop/      world entity for dropped items
  weapons/                 active TacoScript SWEPs (weapon_ts_* and ts_*)
  weapons_old/             previous versions and retired weapons, not loaded
gamemode/
  init.lua                 server entry: includes, globals, timers, MySQL stub
  cl_init.lua              client entry: includes, sandbox hook overrides, usermessages
  shared.lua               text wrapping, business getters, line of sight helper
  server_vars.lua          chat ranges, prop limits, welcome lines
  server_events.lua        MySQL connect, team and item parsing, map door data, donations
  server_util.lua          item and letter spawning, business stock, player search
  player_server.lua        per player data store, think loops, join flow, disconnect
  player_sqldata.lua       account lookup, groups, character save and load
  player_data.lua          old file based saves, no longer included
  player_hooks.lua         spawn, loadout, death, movement, tool and prop permissions
  player_util.lua          money, inventory, factions, ragdolls, door ramming
  player_stats.lua         stat growth and movement speed formulas
  player_dmg.lua           hit groups, limb damage, punches, knockouts
  player_status.lua        bleeding and status flags
  player_doorownership.lua F4 door and property ownership
  player_actionmenu.lua    F4 action menu (CID, pat down, item actions)
  player_anims.lua         faction emote animations
  NPCAnims.lua             NPC style player animation system and holstering
  chat.lua / rp_chat.lua   chat command registry and the commands themselves
  concmd.lua               player console commands (characters, business, items)
  item_concmd.lua          container placement (stub)
  admin.lua / admin_cc.lua admin command framework and commands
  rp_tooltrust.lua         tool trust checks and the basic tool list
  workshop.lua / mixtures.lua  crafting search and recipes
  entity.lua               door, vehicle, item and banned model helpers
  parse.lua                tokenizer for the text data files
  hash.lua                 password obfuscation
  util.lua                 notifications, logging, range chat, third person camera
  resources.lua            client downloads
  custom_spawnpoints.lua   spawn points per map
  combine_sounds.lua       voice lines for rp_playline
  special_chars.lua        donor custom models
  networkoverride.lua      disabled networking experiment
  maps/                    per map scripts
  items/                   item definitions
  tacovgui/                custom VGUI widgets (TacoPanel, TacoFrame, TacoButton, ...)
  cl_*.lua                 HUD, menus, inventory, chat box, letters, quiz, scoreboard
```

## Known issues in the code

These are bugs in the code as it was, not things to fix. The code dates from 2007
and 2008 and will not run on today's Garry's Mod without a port.

- `TS.LoadMapData` in `gamemode/server_events.lua` includes
  `maps/rp_rtrp_city45_v01.lua`, but the file in the repository is
  `maps/rp_tb_city45_v01.lua`, so the include fails on startup and that map
  script never runs.
- Passwords are not hashed. `TS.Hashify` in `gamemode/hash.lua` is a reversible
  character substitution with random padding, and `TS.UnHashify` reverses it.
  `concmd.lua` carries a second copy of the same code, and `init.lua` includes
  `concmd.lua` twice.
- `rp_createbusiness` checks that you hold 1900 credits (the menu text says
  2500) but never deducts them.
- The Combine CISR-762 item gives `weapon_ts_combinesniper`, and the developer
  loadout gives `weapon_ts_godhand`; both SWEPs exist only in `weapons_old/`.
- `rp_ow`, `rp_ce` and `rp_ca`, and the `BecomeOW`, `BecomeCE` and `BecomeCA`
  functions behind them, are all commented out, but the F1 help text and the
  `rp_rcon` blacklist still list them along with `rp_cp`, which does not exist.
- `GM:PlayerInitialSpawn` prints a stray `1` to every joining player's console.
- `GM:PlayerSpawn` writes the inventory capacity for players without a backpack
  into `inventory.CrntSize` (space used) instead of `inventory.MaxSize`.
- The Backpack sets `inventory.MaxSize` with `SetNWFloat`, but `HasRoomForItem`
  reads the server-side field set with `SetField`, which stays at 4. The backpack
  changes the capacity players see, not how much they can carry.
- `GM:ScalePlayerDamage` calls `ply:IsTempCP()` for NRD players, and
  `player_anims.lua` does the same, but `IsTempCP` is commented out in
  `player_util.lua`. Every hit on an NRD player raises a Lua error before the
  hit group and Endurance scaling runs.
- `GM:PlayerDeath` has a `return` inside its loop over the player's held
  weapons. The first one that is not an inventory entry (Hands, Keys, the Medic
  tool and the physics guns never are) ends the function before the weapon
  strip, death messages, death position and kill log that follow. The ammo strip
  it would reach last, `RemoveAllTSAmmo`, begins with `if( true ) then return; end`.
- `TS.UpdateDoorOwnership`, the 8 minute release after a disconnect, tests an
  undefined `door` variable, so it never clears the owner from the live door
  table, and it errors on any owned door that has no mapdata entry.
- `TS.DoRealTimeDonation` calls `mysql.query` without the connection handle on
  the path for characters who are not online, so queued grants for offline
  characters fail.
- `/dropmoney` uses three names that do not exist (`n`, `Notify` and
  `AddMoney`), so it errors instead of dropping cash.
- `rp_admingivestat <player> <stat> <amount>` adds the amount to the admin's own
  value of that stat, not the target's.
- `rp_maxttprops` sets `maxttprops`, which nothing reads. Prop limits come from
  `groupID` and `rtrp_donations`.
- The Medic tool and `rp_finishheal` require a `healthvial` item, but no item
  file defines one (`medicine.lua` only borrows its model), so healing never
  starts and only bandaging works.
- The backstory text calls the NSRF the "National Soviet Revolutionary Front";
  the job title the code assigns is "New Soviet Revolutionary Front".
- `rp_thirdperson` prints "DISABLED OK?" and returns, and
  `TS.CreateThirdPersonCamera` in `util.lua` is an empty function.
- Item mixing (workshop) was never finished, as described above.

## Credits

- TacoScript framework: Rick Darkaliono (2007 to 2008)
- RefugeeRP 2.0 conversion and modifications: Josh Bazar
- Community: Real Time Roleplay, https://steamcommunity.com/groups/rtrp
- The in-game credits tab (F1, `gamemode/cl_help.lua`) also names the admin team
  of the time: JT (Founder, Community Manager), Argus, Chance and Lucky (Global
  Roleplay Managers), Munroe (Head of Administrators) and Robro (Local Roleplay
  Administrator).
