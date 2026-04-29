# Contributing to compose-performance-skills

Thanks for considering a contribution. The library covers Compose stability, recomposition, lazy layouts, modifiers, side effects, measurement, build configuration, hot reload, and an end to end audit orchestrator. Every contribution either adds a new focused skill or improves an existing one.

## Before you start

- Read [`docs/SPEC.md`](docs/SPEC.md) end to end. The frontmatter template, body structure, voice rules, and Mandatory Rules section are not negotiable. Skills that drift from the spec slow review and risk regressions.
- Skim [`docs/CORPUS.md`](docs/CORPUS.md) for the canonical citations. Pull facts from there so vocabulary and sources stay consistent across skills.
- Read two or three existing `SKILL.md` files in the category closest to your contribution. Match the voice and the RIGHT and WRONG snippet conventions.

## Authoring a new skill

1. Pick a category that already exists. New top level categories require a separate proposal; open an issue first.
2. Pick a slug in gerund form: `diagnosing-foo`, `migrating-to-bar`. Lowercase, hyphenated, max 64 chars.
3. Create the directory `<category>/<slug>/SKILL.md`. Optional `references/<topic>.md` files live one level deep.
4. Fill the frontmatter exactly as the SPEC §2 template prescribes. The description field is what triggers the skill, so write it carefully: third person, verb led, trigger rich, under 1024 chars.
5. Body under 500 lines. RIGHT and WRONG paired snippets for any code level skill. MUST and MUST NOT directives in bold caps. Verification checklist at the end. Three or more authoritative reference URLs from `docs/CORPUS.md` §A.
6. Update [`INDEX.md`](INDEX.md) so the symptom and API tables surface the new skill. Add the new slug to the relevant workflow phase section.

## Improving an existing skill

- File a PR scoped to one cause. A stability fix and a recomposition fix should be separate PRs even if they touch the same skill.
- Update `docs/CORPUS.md` if you introduce a new citation. Pull facts from primary sources, not paraphrases.
- If your change moves trigger vocabulary, also update `INDEX.md` so the symptom and API tables still resolve.

## Self check before opening a PR

The SPEC §9 self check is the gate. Run through it manually:

- Frontmatter validates (name matches folder slug, description ≤ 1024 chars, license line, ≥ 4 keywords).
- Body ≤ 500 lines.
- At least one RIGHT and WRONG pair for code level skills.
- Verification checklist present.
- Three or more authoritative reference URLs cited.
- Skydoves hot take from SPEC §5 surfaced where applicable.
- MUST and MUST NOT in bold caps.
- No emojis, no first person, no time sensitive phrasing.
- Cross references between skills use relative Markdown links.

## Reporting issues

- Bug in a skill (wrong API, broken claim, dead link): open an issue with the skill slug and a reproduction.
- Suggestion for a new skill: open an issue with the symptom or API the skill should address. Wait for triage before drafting.
- Discussion: GitHub Discussions on this repo.

## Code of Conduct

This project follows the [Contributor Covenant](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## License

By contributing, you agree your contribution is licensed under Apache License 2.0 to match the rest of the repo.
