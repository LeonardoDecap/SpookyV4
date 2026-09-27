# SpookyV4

SpookyV4 is a maintained development fork of [Vape V4 for Roblox](https://github.com/7GrandDadPGN/VapeV4ForRoblox), hosted at [LeonardoDecap/SpookyV4](https://github.com/LeonardoDecap/SpookyV4). The original code, history, and attribution belong to their respective upstream authors. The upstream `LICENSE` remains in this repository.

**Development status:** infrastructure is set up, but current Roblox and BedWars compatibility has not been verified. Use the `dev` branch for development. `main` and `upstream-baseline` are preserved at the initial upstream commit.

## DEV loader

```luau
loadstring(game:HttpGet("https://raw.githubusercontent.com/LeonardoDecap/SpookyV4/dev/DevMainScript.lua", true))()
```

The DEV loader resolves the `dev` commit and downloads compiled runtime files from this repository's `dev-build/` directory. It fails if commit resolution or a required download fails. It retains the upstream `newvape` cache and profile paths for compatibility. This command is provided for development testing; no runtime success claim is made.

## Build

`src/` is the editable source. `dev-build/` is generated and committed so raw GitHub URLs can serve it. With Node.js installed, run:

```sh
node tools/build-dev.js
```

The build follows the upstream [VapeBundler](https://github.com/7GrandDadPGN/VapeBundler) layout using adapted local helpers. Do not edit `dev-build/` by hand. Commit source and regenerated output together. See [AI-HANDOFF.md](AI-HANDOFF.md) for the loader flow, branch policy, and BedWars file map.

GitHub Actions is currently disabled by GitHub for this fork. The `dev` workflow is prepared to check generated output, but it will not run until Actions is enabled. Review the untouched upstream workflow on `main` before enabling Actions repository-wide.

## Starting development

1. Clone this repository and check out `dev`.
2. Read [CLAUDE-HANDOFF.md](CLAUDE-HANDOFF.md), [AI-HANDOFF.md](AI-HANDOFF.md), and [ROADMAP.md](ROADMAP.md).
3. Create a checkpoint before significant compatibility work.

## Upstream credit

Vape V4 is maintained upstream by [7GrandDad](https://github.com/7GrandDadPGN). The upstream project also credits [rce-incorporated](https://github.com/rce-incorporated/Fiu), Egor Skriptunoff, boatbomber, howmanysmall, and Vernumerator for components and research used in its codebase. SpookyV4 does not claim authorship of that work. See upstream [README](https://github.com/7GrandDadPGN/VapeV4ForRoblox#readme) and [CONTRIBUTING.md](CONTRIBUTING.md).
