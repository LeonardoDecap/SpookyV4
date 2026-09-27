# SpookyV4 roadmap

SpookyV4 is **not production-ready**. This setup task established the repository and DEV build; gameplay compatibility has not been tested.

| Priority | Next work |
| --- | --- |
| P0 | Verify the SpookyV4 DEV loader resolves the `dev` commit and starts its fork-owned runtime. |
| P1 | Get current BedWars lobby and match runtime loading cleanly. The inherited intentional shutdown blocks were removed; verify the next observed runtime result. |
| P2 | Repair startup-breaking outdated BedWars references and APIs based on observed errors. |
| P3 | Verify GUI and category initialization. |
| P4 | Test modules category by category. |
| P5 | Repair important BedWars features. |
| P6 | Investigate Killaura and combat runtime compatibility. |
| P7 | Review kit-specific utilities. |
| P8 | Develop original SpookyV4 improvements. |

Checkpoint `dev` before significant compatibility changes. Keep `main` and `upstream-baseline` as reference states until a separate release decision.
