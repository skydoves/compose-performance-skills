---
name: Skill bug report
about: A skill produced wrong, outdated, or misleading guidance, or its workflow does not work as written

---

**Affected skill:**

Path of the SKILL.md (or `references/<topic>.md`) that contains the issue. Example: `recomposition/deferring-state-reads/SKILL.md`.

**Repository version:**

Commit SHA or tag of `compose-performance-skills` you have loaded. `git rev-parse HEAD` works.

**Agent runtime where the skill was loaded:**

- [ ] Claude Code
- [ ] Anthropic API / Claude.ai
- [ ] Android CLI
- [ ] Android Studio Agent mode
- [ ] Gemini
- [ ] Other (specify)

**Prompt or context that triggered the skill:**

Paste the user prompt (or the file open in the editor) that made the agent load this skill.

**What the skill says:**

Quote the exact lines from the SKILL.md (or reference doc) that are wrong or misleading. Include section header and step number where applicable.

**Why it is wrong:**

Either (a) link to the authoritative source that contradicts it (Android Developers docs, AndroidX source on `cs.android.com`, Compose Compiler source, official release notes), or (b) describe what the agent actually did when following the workflow and what broke.

**Compose / AndroidX versions in scope:**

If the bug only appears against a specific Compose UI / Compose Foundation / Compose Compiler version, list it. Skill claims that hold on `androidx-main` but break on a stable release should be flagged here.

**Suggested fix:**

If known, describe the corrected text or workflow step. Cite the authoritative source.
