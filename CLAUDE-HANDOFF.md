# SpookyV4: start here

1. Clone `https://github.com/LeonardoDecap/SpookyV4` and check out `dev`.
2. Read `AI-HANDOFF.md` and `ROADMAP.md`.
3. Preserve `main` and `upstream-baseline`; make a checkpoint before significant compatibility work.
4. First verify the DEV loader and BedWars lobby/match startup. Record the first concrete runtime error before changing code.
5. Avoid a broad rewrite. Edit `src/`, run `node tools/build-dev.js`, and commit the regenerated `dev-build/` with the source.

DEV command:

```luau
loadstring(game:HttpGet("https://raw.githubusercontent.com/LeonardoDecap/SpookyV4/dev/DevMainScript.lua", true))()
```

The stock BedWars source still contains deliberate lobby/match shutdown blocks. Runtime compatibility has not been verified. The exact file map and loader flow are in `AI-HANDOFF.md`.
