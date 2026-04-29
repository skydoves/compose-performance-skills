# compose-performance-skills — Authoring Spec

This file is the single source of truth for every SKILL.md in this repo. All skill authors MUST follow it.

---

## 1. Directory layout

```
compose-performance-skills/
├── README.md                 # repo philosophy + quickstart
├── INDEX.md                  # symptom → skill map
├── LICENSE                   # Apache-2.0
└── <category>/<slug>/
    ├── SKILL.md              # the skill (required)
    └── references/           # optional, ONE level deep only
        └── <topic>.md
```

- `<category>` is lowercase, singular where natural (`stability`, `recomposition`, `modifiers` is fine even plural — match convention of android/skills).
- `<slug>` is **gerund form** (`diagnosing-compose-stability`, `migrating-to-modifier-node`). Lowercase, hyphenated, max 64 chars.
- `SKILL.md` is uppercase.
- `references/` is optional; use it for files the SKILL.md body explicitly links to (e.g. "See `references/bitmask-encoding.md`"). Never nest deeper — Claude previews deep files with `head -100` and misses content.

## 2. Frontmatter template (copy exactly)

```yaml
---
name: <slug-matching-folder>
description: <trigger paragraph — 3rd person, 1-4 sentences, ≤1024 chars. Leads with "Use this skill to …" or a verb; ends with a "if the user mentions X, Y, Z" hammer. Must state BOTH what + when.>
license: Apache-2.0. See LICENSE for complete terms.
metadata:
  author: Jaewoong Eum (skydoves)
  keywords:
  - jetpack-compose
  - performance
  - <3-6 more specific keywords>
---
```

Rules:
- `name` MUST match the folder slug exactly.
- `description` MUST be ≤1024 chars, 3rd person, no first/second person ("I can…", "You can…" → forbidden). Include vocabulary variants the user would naturally say (e.g. "jank", "dropped frames", "recomposition count", API names).
- NO reserved words: skill names must not contain `anthropic` or `claude`.
- `keywords` include both symptoms (`jank`, `slow-scroll`, `apk-size`) and APIs (`modifier-node`, `baseline-profiles`).

### Description quality checklist
- [ ] Starts with a verb or "Use this skill to …"
- [ ] Names ≥3 trigger vocabulary variants
- [ ] States the symptom/problem it addresses
- [ ] Closes with a "if the user mentions X, use this skill" line
- [ ] Under 1024 chars; reads in one breath
- [ ] No time-sensitive wording ("as of March 2026", "recently")
- [ ] Third person throughout

## 3. Body structure

Target **≤500 lines**. Longer content goes into `references/`. Use this section order:

```markdown
# <Title> — <one-line tagline>

<2-3 sentence orientation: what this skill fixes, who should care, approximate impact>

## When to use this skill

<3-5 bullets of concrete triggers. Mirror the vocabulary from frontmatter description.>

## When NOT to use this skill

<1-3 bullets where this skill does NOT apply — cross-reference sibling skills by relative path.>

## Prerequisites

<Bulleted. Compose version min, build flags, any sibling skills to run first.>

## Workflow

<Numbered steps OR markdown checkbox list. Every step has:
  - a concrete command or code snippet
  - a short rationale
  - (when relevant) a RIGHT / WRONG snippet pair>

## Patterns

### Pattern: <name>

<problem → fix as RIGHT / WRONG paired snippets:>

```kotlin
// WRONG
<code>
// WRONG because: <one line>
```

```kotlin
// RIGHT
<code>
```

<repeat for 2-5 patterns>

## Mandatory rules

- **MUST** …
- **MUST NOT** …
- **PREFERRED:** …

## Verification

<Checkbox list of commands/checks that prove the skill was applied correctly.
e.g. "- [ ] `./gradlew assembleRelease` succeeds" / "- [ ] Layout Inspector shows 0 recompositions per animation tick">

## References

- Inline links to authoritative sources (Android Developers, Ben Trengrove, Chris Banes, skydoves blog).
- If you use `references/*.md`, list them here with one-line summaries.
```

Shorter skills can collapse `Workflow` into `Patterns`; index-style skills can omit `Workflow`.

## 4. Voice & tone

- Written **for Claude the agent** (reader is an LLM, not a human dev).
- **Imperative 2nd person** for instructions ("Run `./gradlew …`", "Replace `List<Foo>` with `ImmutableList<Foo>`").
- **3rd person** for the user ("the developer", "the user").
- Use **MUST / MUST NOT / DO NOT / PREFERRED** in bold caps for hard rules.
- Use paired **WRONG / RIGHT** blocks with one-line "WRONG because: …" rationale.
- No emojis. No filler ("Let's dive in!"). No apologies.
- No XML tags in skill content.
- No time-sensitive phrasing. Version-specific info goes in a clearly labeled section ("### Compose ≥1.9").

## 5. Skydoves-specific editorial directives

These are hot takes from skydoves' own writing. Surface them consistently across skills:

1. **"Don't chase 100% skippability."** Skippability is a diagnostic, not a KPI.
2. **"Stability config is a contract, not a magic spell."** Marking a mutable type stable means the compiler trusts you; break the contract and you silently miss recompositions.
3. **Inline composables (`Row`, `Column`, `Box`) are NOT restartable/skippable** — wrapping changes recomposition scoping.
4. **`Flow` parameters are unstable.** Don't pass flows to composables; collect them in a `ViewModel` or with `collectAsStateWithLifecycle`.
5. **Always measure in release + R8 + real device.** Debug builds lie (Live Literals, interpreted mode).
6. **Pure-Kotlin / data modules** can use `compose-stable-marker` (or newer official `compose-runtime-annotation`) without pulling in full compose-runtime.

## 6. RIGHT/WRONG snippet quality bar

Every pattern SHOULD include a RIGHT/WRONG pair when the fix is a code transform. Format:

```kotlin
// WRONG
Box(Modifier.offset(x = animatedX.value.dp))
// WRONG because: reading .value in Composition phase invalidates the whole subtree each frame.
```

```kotlin
// RIGHT
Box(Modifier.offset { IntOffset(animatedX.value.toInt(), 0) })
```

The WRONG snippet MUST be labeled, have the one-line "because" rationale, and the RIGHT snippet MUST compile (no `...` ellipses in the critical lines).

## 7. Cross-references

When referring to another skill, use a relative Markdown link:

```
See `../recomposition/deferring-state-reads/SKILL.md` for the phase-deferral details.
```

Do not link sibling skills by URL. Do not assume a shared index loads them — the reader may jump in mid-tree.

## 8. Mandatory rules for skill authors

- **MUST** keep the body ≤500 lines. Split into `references/` if longer.
- **MUST** include at least one RIGHT/WRONG snippet pair in any skill that teaches a code-level fix.
- **MUST** end with a Verification checklist.
- **MUST** cite authoritative URLs (Android Developers, Compose compiler source, Ben Trengrove, Chris Banes, skydoves blog).
- **MUST NOT** use first person ("I", "we", "let me") anywhere except the frontmatter's `metadata.author`.
- **MUST NOT** recommend `composed { }` for new custom modifiers — always Modifier.Node.
- **MUST NOT** claim a feature without a version or doc URL.
- **MUST NOT** duplicate content between skills — cross-reference instead.

## 9. Post-write self-check

Before declaring a skill done:

- [ ] Frontmatter validates (name matches folder, description ≤1024 chars, no reserved words, has ≥4 keywords)
- [ ] Body ≤500 lines
- [ ] At least one RIGHT/WRONG pair (for code-level skills)
- [ ] Verification checklist present
- [ ] At least 3 authoritative reference URLs
- [ ] Skydoves hot-take surfaced when applicable (see §5)
- [ ] `MUST`/`MUST NOT` directives in bold caps
- [ ] No emojis, no first person, no time-sensitive phrasing
