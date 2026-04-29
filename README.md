# Compose Performance Skills

If you have used [`android/skills`](https://github.com/android/skills), you already know the shape of an Agent Skill: a Markdown file an agent loads on demand to perform one focused task. That library covers Android development at large. This repository goes narrow and deep on a single axis: Jetpack Compose performance. The skills here cover stability, recomposition, lazy layouts, custom modifiers, side effects, baseline profiles, R8, hot reload with Compose HotSwan, and the measurement loop that ties them together. The goal is to give a coding agent enough operational knowledge to diagnose and fix Compose performance issues without guessing, and to give the developer reading the diff a citation trail back to primary sources.

## What this repo is

This is a curated library of Agent Skills focused on Jetpack Compose performance. The skills follow the open Agent Skills standard published at [agentskills.io](https://agentskills.io), which is the same standard Google's [Android CLI](https://developer.android.com/tools/agents/android-cli) and Android Studio Agent mode use for [Android skills](https://developer.android.com/tools/agents/android-skills). Any compliant runtime should load the SKILL.md files in this repo as is. The library was iterated against Claude Code; integration with the Anthropic API, the Android CLI, Android Studio Agent mode, and Gemini follows from standards conformance and has not been individually end to end tested by the author. Every skill is grounded in primary sources: Android Developers documentation, the Compose compiler, posts by Ben Trengrove, Chris Banes, Manuel Vivo, and the skydoves open source projects, and blog posts. Every API reference is pinned to a version.

## What is a Skill

A Skill is a single Markdown file (`SKILL.md`) plus optional `references/` material that teaches an agent how to perform one focused task. It declares trigger vocabulary in YAML frontmatter and a numbered workflow in the body. The agent reads the frontmatter, decides whether the skill applies to the current task, then follows the workflow inside `SKILL.md` step by step.

A skill is not documentation for humans. It is operational instructions for an LLM. That changes the writing voice: terse, imperative, RIGHT and WRONG snippet pairs, MUST and MUST NOT directives in bold caps, and a Verification checklist that proves the work was done. Prose is kept short. Code samples carry the load.

## Directory layout

```
compose-performance-skills/
├── README.md                 # this file
├── INDEX.md                  # symptom to skill lookup table
├── LICENSE                   # Apache-2.0
└── <category>/<slug>/
    ├── SKILL.md              # the skill (required)
    └── references/           # optional, one level deep
        └── <topic>.md
```

Conventions:

- **Category**: lowercase, one of `stability`, `recomposition`, `lists`, `modifiers`, `side-effects`, `measurement`, `build`, `audit`, `hot-reload`.
- **Slug**: gerund form, lowercase, hyphenated, max 64 chars (`diagnosing-compose-stability`, `migrating-to-modifier-node`).
- **`SKILL.md`**: uppercase. Every skill body stays under 500 lines. Longer material moves into `references/`.
- **`references/`**: one level deep only. Deeper nesting breaks how agents preview the files.
- **Cross links**: relative Markdown links between skills so they resolve when the repository is browsed on GitHub.

The full authoring specification lives in [`docs/SPEC.md`](docs/SPEC.md).

## How to use

### Claude Code

Point Claude Code at this repository through its Skills mechanism. Either clone the repo into the project's `.claude/skills/` directory or reference it from a global skills location. Once installed, mention a Compose performance symptom in a prompt and Claude Code matches the trigger vocabulary in the skill frontmatter, then loads the relevant `SKILL.md` automatically.

```bash
git clone https://github.com/skydoves/compose-performance-skills.git \
  ~/.claude/skills/compose-performance-skills
```

### Android CLI and Android Studio Agent mode

The [Android CLI](https://developer.android.com/tools/agents/android-cli) and Android Studio Agent mode load any skill that follows the [agentskills.io](https://agentskills.io) open standard, which is what the SKILL.md files in this repo use. The CLI does not accept a remote repository URL: `android skills add --skill <name>` only installs skills from Google's [first party catalog](https://github.com/android/skills). To use this repo with the same agents, drop it into one of the project local directories the agents scan on startup.

Two locations are supported:

- `.skills/` at the repo root of the Android project
- `.agent/skills/` at the repo root

Clone this repo into one of those directories. Skills coexist with the first party catalog; the two sets do not overlap because this repo is Compose performance only.

```bash
cd <your-android-project>
git clone https://github.com/skydoves/compose-performance-skills.git \
  .skills/compose-performance
```

Once the directory is present, the Android CLI and Android Studio Agent mode match the trigger vocabulary in each skill's frontmatter against the user prompt or the open file. A slow `LazyColumn` triggers `lists/optimizing-lazy-layouts`, a stability question triggers `stability/diagnosing-compose-stability`, and so on. To inspect what Google ships out of the box alongside, run `android skills list` and `android skills add --skill <name>` for the first party skills the developer wants enabled.

### Claude.ai and the Claude API

For Claude.ai workspaces, upload the relevant `SKILL.md` files as Agent Skill attachments. For direct Anthropic API integrations, reference skills inline in the system prompt or load them through the Agent Skills file API. The skills are self contained. No external runtime is required beyond a working Compose toolchain on the developer's machine for verification steps.

### Other agent runtimes

Any agent runtime that can read a Markdown file and follow its instructions can use these skills. The frontmatter is plain YAML. The body is plain Markdown. Treat the `SKILL.md` files as system prompts for the task, attach the linked `references/` files when the body cites them, and let the agent run the Verification checklist before declaring the work done.

## Quickstart

A developer pastes the following into Claude Code:

> My LazyColumn drops frames during fast scroll. Composables show in the layout inspector but recomposition counts spike on every scroll tick. Diagnose the stability issue and fix it.

Claude Code matches the symptoms (`dropped frames`, `recomposition counts`, `LazyColumn`) against skill frontmatter and loads [`stability/diagnosing-compose-stability/SKILL.md`](stability/diagnosing-compose-stability/SKILL.md). That skill walks Claude through enabling Compose Compiler reports in release mode, parsing `<module>-composables.txt` for `unstable` parameters, then chains into [`stability/stabilizing-compose-types/SKILL.md`](stability/stabilizing-compose-types/SKILL.md) for the fix. The chain is explicit in each skill's body: a fix skill states which diagnostic skill should have produced the input, and a diagnostic skill names the fix skills it can hand off to. The agent does not have to infer the path.

## Skill categories

- **`stability/`**: diagnose and fix Compose stability. Read compiler reports, stabilize types, configure `stability_config.conf`, validate via `compose-stability-analyzer`.
- **`recomposition/`**: eliminate unnecessary recomposition. Defer state reads to layout or draw, apply `derivedStateOf` correctly, trace recomposition with `@TraceRecomposition`, avoid `SubcomposeLayout`/`BoxWithConstraints`/`Scaffold` pitfalls that compose during the measure pass.
- **`lists/`**: make `LazyColumn` and `LazyVerticalGrid` smooth. Stable keys, `contentType`, `LazyLayoutCacheWindow`, pausable prefetch.
- **`modifiers/`**: author and migrate custom modifiers. `Modifier.Node` over `composed { }`, `graphicsLayer { }` for animated reads.
- **`side-effects/`**: wire flows and effects safely. `collectAsStateWithLifecycle`, `LaunchedEffect` vs `RememberedEffect`, lambda memoization under strong skipping.
- **`measurement/`**: measure before fixing. Macrobenchmark, Baseline Profiles, frame timing, startup metrics, release mode invariants.
- **`build/`**: get the toolchain right. R8 in full mode, strong skipping flag, CI time stability validation.
- **`audit/`**: orchestrator skill that sequences the others into an end to end performance audit (Measure to Diagnose to Fix to Verify).
- **`hot-reload/`**: install Compose Hot Reload for Android, stay inside the supported change set, preserve state across reloads, and drive the loop from an AI agent over MCP.

The full symptom to skill lookup is in [INDEX.md](INDEX.md).

## Scope

In scope:

- Jetpack Compose for Android, on the runtime, compiler, and tooling that ship with AndroidX.
- The Compose performance loop end to end: measurement, diagnosis, fix, and verification.
- Build configuration where it changes Compose runtime behavior (R8 full mode, strong skipping, baseline profiles).

Out of scope:

- General Compose tutorials and onboarding. Use the official [Compose pathway](https://developer.android.com/courses/jetpack-compose/course) for that.
- Compose Multiplatform specifics. Most skills apply, but iOS, Desktop, and Web targets are not validated here.
- Non Compose Android performance work (View system, RecyclerView, app startup outside Compose).

## Editorial position

Five non negotiable hot takes carried across every skill. They appear in skill bodies as MUST and MUST NOT directives so the agent treats them as constraints, not advice.

1. Skippability is a diagnostic, not a KPI. Do not chase 100%.
2. A stability config is a contract with the compiler, not a magic spell. Break the contract and you silently miss recompositions.
3. Inline composables (`Row`, `Column`, `Box`) are not restartable or skippable. Wrapping them changes recomposition scoping.
4. `Flow` parameters are unstable. Collect them in a `ViewModel` or with `collectAsStateWithLifecycle`. Do not pass them down.
5. Always measure in release plus R8 plus a real device. Debug builds lie.

## Contributing

Contributions are welcome. Before opening a pull request:

1. Read [`docs/SPEC.md`](docs/SPEC.md) end to end. The frontmatter template, body structure, voice, and mandatory rules apply to every skill.
2. Pull facts and code samples from [`docs/CORPUS.md`](docs/CORPUS.md) so vocabulary stays consistent across skills.
3. Run the post write self check. It is the gate. Frontmatter validates, body is 500 lines or fewer, at least one RIGHT and WRONG pair for code level skills, a Verification checklist, three or more authoritative reference URLs, no first person, no emojis, no time sensitive phrasing.
4. Add the new skill to [INDEX.md](INDEX.md) under each lookup section it belongs to.

Open the pull request only after the self check passes.

## Attribution

Five skydoves OSS libraries seed the technical content of this repository. The skills cite them inline where their APIs are referenced.

- [compose-performance](https://github.com/skydoves/compose-performance): the umbrella performance hub.
- [compose-stability-inference](https://github.com/skydoves/compose-stability-inference): the 12 phase stability inference algorithm and bitmask encoding.
- [compose-stability-analyzer](https://github.com/skydoves/compose-stability-analyzer): `@TraceRecomposition`, `stabilityDump`, and the `stabilityCheck` Gradle plugin.
- [compose-stable-marker](https://github.com/skydoves/compose-stable-marker): `@Stable`, `@Immutable`, and `@StableMarker` for pure Kotlin modules without pulling `compose-runtime`.
- [compose-effects](https://github.com/skydoves/compose-effects): `RememberedEffect`, `ViewModelStoreScope`, and other side effect primitives.

Additional primary sources are listed in [`docs/CORPUS.md`](docs/CORPUS.md).

## Find this repository useful? :heart:
Support it by joining __[stargazers](https://github.com/skydoves/compose-performance-skills/stargazers)__ for this repository. :star: <br>
Also __[follow](https://github.com/skydoves)__ me for my next creations! 🤩

# License
```xml
Designed and developed in 2026 by skydoves (Jaewoong Eum)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```