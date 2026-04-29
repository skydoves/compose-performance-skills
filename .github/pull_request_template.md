### Goal

Describe the change and link the issue it resolves. State whether this is a new skill, a fix to an existing skill, a reference-doc addition, or an index/README update.

### Affected files

- Skill(s): `<category>/<slug>/SKILL.md`
- Reference doc(s): `<category>/<slug>/references/<topic>.md`
- Index / README / SPEC / CORPUS: list any of these that changed.

### Type of change

- [ ] New skill
- [ ] Fix or update to an existing skill
- [ ] New `references/` doc
- [ ] INDEX.md update (symptom row, API row, or workflow-phase entry)
- [ ] README.md / SPEC.md / CORPUS.md update
- [ ] Tooling or `.github` config

### Authoritative sources cited

List the primary sources the new or updated content is grounded in. Every API claim must point to one of:

- Android Developers documentation
- AndroidX source on `cs.android.com` (pinned to a path)
- Compose Compiler source
- Compose / AndroidX release notes
- Posts by Ben Trengrove, Chris Banes, Manuel Vivo, or skydoves writing on ProAndroidDev / GetStream blog

### SPEC.md self-check

Run through `docs/SPEC.md` §9 before requesting review. All items below must pass for any skill body that changes:

- [ ] Frontmatter `name` matches the folder slug
- [ ] Frontmatter `description` is third person, ≤1024 chars, names ≥3 trigger vocabulary variants, and closes with a "use when the developer mentions X" hammer
- [ ] Frontmatter contains `license: Apache-2.0. See LICENSE for complete terms.` exactly
- [ ] `metadata.author` is `Jaewoong Eum (skydoves)` and `metadata.keywords` has ≥4 entries including `jetpack-compose` and `performance`
- [ ] No reserved words `anthropic` or `claude` appear in the skill name
- [ ] Body is ≤500 lines; longer material moved to `references/`
- [ ] At least one RIGHT / WRONG paired snippet (for any skill that teaches a code transform), with `// WRONG because: …` rationale on the WRONG block
- [ ] Mandatory rules use **MUST**, **MUST NOT**, **DO NOT**, or **PREFERRED** in bold caps
- [ ] Verification section is a checkbox list of provable checks
- [ ] References section has ≥3 authoritative URLs
- [ ] No first person, no emojis, no time-sensitive phrasing

### Cross-reference updates

- [ ] INDEX.md updated under every lookup section the skill belongs to (By symptom, By API, By workflow phase)
- [ ] README.md skill-categories bullet updated if the change introduces or renames a topic in that category
- [ ] Sibling skills' "When NOT to use" / "References" sections cross-link to this change where relevant

### Verification

Describe how the workflow in the SKILL.md was exercised. For code-level skills, paste output from running the verification checklist on a sample project: compiler reports, Layout Inspector counts, Perfetto trace section names, or `./gradlew :app:assembleRelease` output.

### Code review

All submissions require review. Use GitHub pull requests for this purpose. See [GitHub Help](https://docs.github.com/en/github/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests) for more information.
