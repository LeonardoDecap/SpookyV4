# SPOOKYV4 AI / DEVELOPER HANDOFF

## Project identity and status

- Repository: `LeonardoDecap/SpookyV4`
- Upstream: `7GrandDadPGN/VapeV4ForRoblox`
- Active development branch: `dev`
- Stable/reference branches: `main`, `upstream-baseline`
- Initial upstream commit: `489962b90131b0de9fc34518bf43819f68a4aa08`
- Status: repository infrastructure prepared; Roblox runtime and BedWars compatibility **not verified**.

SpookyV4 was intentionally started fresh from stock Vape V4. It does not depend on the previous LeoV4 workspace or its changes. No broad BedWars compatibility work has been completed. The deliberate `Kick`/`Shutdown` blocks inherited from stock Vape were removed from the BedWars lobby and match `base.lua` files after a user reported the exact kick message. This narrow change has not been runtime-tested; other compatibility failures may remain.

## Branch and checkpoint policy

`main` and `upstream-baseline` point to the untouched upstream starting commit. Develop on `dev`; do not merge it into `main` until a separately reviewed release decision. `checkpoint/spookyv4-bootstrap-2026-09-26` marks the pre-rebrand starting point. `checkpoint/spookyv4-ready-for-claude-2026-09-26` marks this handoff state. Create another checkpoint branch before significant compatibility work. Never force-push the reference branches.

The local remotes are `origin` (SpookyV4) and `upstream` (VapeV4ForRoblox). The upstream push URL is disabled locally. For an upstream sync, fetch `upstream`, inspect the change on a new branch, and merge or cherry-pick reviewed changes into `dev`. Keep `upstream-baseline` as the original snapshot.

## Repository map

| Path | Purpose |
| --- | --- |
| `DevMainScript.lua` | Public DEV bootstrap; downloads this fork's `src/loader.lua` from `dev`. |
| `src/loader.lua` | Resolves the current `dev` SHA using GitHub's commits API, maintains cache versioning, and starts `main.lua`. |
| `src/main.lua` | Initializes GUI, universal/game bundles, save loop, and teleport reload. |
| `src/libraries/` | Runtime libraries (entity, prediction, drawing, hash, VM). |
| `src/guis/new/` | Current GUI source: `base.lua`, `init.lua`, components, overlays, libraries, and assets. |
| `src/games/` | Game source grouped by game and place ID; `universal - base/` is shared across games. |
| `tools/build-dev.js` | Local Node build entry point. |
| `tools/bundler/helpers/` | Upstream VapeBundler helpers copied with attribution in `NOTICE.md`. |
| `dev-build/` | Generated loader, main, libraries, GUI, assets, and place-ID game bundles. Commit this output after a source change. Do not edit it manually. |
| `.github/workflows/build.yaml` | `dev` consistency check that rebuilds and requires committed `dev-build/` to match; GitHub Actions is currently disabled on this fork. |

## DEV loader and runtime flow

The public command is:

```luau
loadstring(game:HttpGet("https://raw.githubusercontent.com/LeonardoDecap/SpookyV4/dev/DevMainScript.lua", true))()
```

`DevMainScript.lua` prints `[SpookyV4 DEV]` and retrieves `src/loader.lua` from SpookyV4. The loader requests `https://api.github.com/repos/LeonardoDecap/SpookyV4/commits/dev`, validates a 40-character SHA, records it in `newvape/profiles/commit.txt`, and fetches `dev-build/main.lua` at that exact SHA. Runtime download helpers use `https://raw.githubusercontent.com/LeonardoDecap/SpookyV4/<sha>/dev-build/<path>`. Teleport reload and GUI restart paths use this fork's compiled `loader.lua`. Required download or commit-resolution failure stops loading; there is no upstream executable fallback.

The upstream `newvape` filesystem naming remains intentionally. Cache paths include `newvape/main.lua`, `newvape/guis/`, `newvape/games/`, `newvape/libraries/`, `newvape/assets/`, and `newvape/profiles/`. Watermarked cached files are cleared when the resolved commit changes; unwatermarked custom files may persist by upstream design. GUI and module settings live under `newvape/profiles/`, including game GUI and profile/place files. Asset downloads use the fork's generated `dev-build/assets/`. The upstream whitelist repository remains a separate data dependency, not a source of executable Lua.

## Build process

Upstream used `7GrandDadPGN/VapeBundler` plus a separate `VapeCompiled` repository. SpookyV4 keeps its adapted bundler helpers locally and writes output to `dev-build/` in the same repository. Run `node tools/build-dev.js` from any current directory. The script copies `src/loader.lua`, `src/main.lua`, and libraries; assembles GUI source and assets; and builds game bundles by place ID. Its generated files are checked into `dev`. Rebuild after editing source, then review and commit both source and output. The old upstream `VapeCompiled` repository is not used by the DEV loader.

GitHub disabled Actions when the fork was created because upstream had a workflow. The `dev` branch contains a build consistency workflow, but it is not running yet. The untouched `main` branch still contains upstream's workflow that targets a separate compiled repository. Review that workflow and make an explicit repository-wide Actions decision before enabling workflows.

## BedWars map for later work

BedWars source is under `src/games/bedwars/`:

- Lobby place `6872265039`: `6872265039 - lobby/base.lua`, plus lobby Combat and World modules.
- Match place `6872274481`: `6872274481 - game/base.lua`, plus category folders. This base initializes BedWars controllers, store, remotes, item metadata, and helper functions.
- Additional place adapters: `8444591321 - mega.lua` and `8560631822 - micro.lua` load the appropriate base game bundle.
- BedWars Killaura: `6872274481 - game/Blatant/Killaura.lua`.
- BedWars inventory: `6872274481 - game/Inventory/`, including AutoHotbar, AutoBuy, AutoBank, and ArmorSwitch.
- Kit-related source: `6872274481 - game/Utility/AutoKit.lua`, `Legit/CleanKit.lua`, `Render/KitESP.lua`, and kit references in match `base.lua`.
- Universal modules: `src/games/universal - base/`, assembled as `dev-build/games/universal.lua` and loaded before a place bundle.

Generated match and lobby files are `dev-build/games/6872274481.lua` and `dev-build/games/6872265039.lua`. Edit source, then rebuild. The inherited shutdown blocks have been removed from both. Do not infer broader compatibility from a successful loader download or the absence of that kick.

### ProjectileController startup investigation

On DEV build `4bfd7ff6`, the match bundle stopped at the old `debug.getupvalue(ProjectileController.enableBeam, 8)` read with `index out of range`. A user-run read-only diagnostic in the live match reported upvalues 1–7; upvalue 5 was the only table with numeric `RelX`, `RelY`, and `RelZ` values (`0.8`, `-0.6`, `0`). The source now searches the available upvalues for exactly one table with those fields and fails with a clear error if there is none or more than one. This value is used by LongJump, ProjectileAimbot, and ProjectileAura. The change was based on that runtime evidence, but the updated build has not yet been tested in a live match. Do not infer that those modules or the rest of BedWars are compatible.

## First investigation for the next developer

Start by verifying the public DEV loader can resolve its commit and download its fork-owned files. Then observe the first concrete lobby/match runtime result. Record the error and source mapping before changing BedWars code. Do not begin with a broad refactor or speculative controller/API index changes. No live Roblox smoke test was performed during infrastructure setup.
