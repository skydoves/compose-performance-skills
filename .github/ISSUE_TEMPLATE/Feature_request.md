---
name: Skill feature request
about: Propose a new skill, an improvement to an existing skill, a new reference doc, or an index update

---

**Type of request:**

- [ ] New skill (a category and slug not yet present)
- [ ] Improvement to an existing skill (pattern, workflow step, mandatory rule, or verification check)
- [ ] New `references/` doc under an existing skill
- [ ] INDEX.md update (a symptom, API, or workflow-phase row that is missing)
- [ ] README.md / SPEC.md / CORPUS.md update

**Symptom or trigger vocabulary the developer would use:**

The exact phrasing a developer is likely to type ("scroll jank in `LazyColumn`", "BoxWithConstraints regresses first frame", "stability config has no effect"). The trigger vocabulary lives in the skill's frontmatter `description`, so include the words the agent should match against.

**Compose APIs or tooling in scope:**

List the AndroidX APIs, Gradle plugins, IDE plugins, or runtime artifacts the skill or update touches. Pin to a class or function name when possible (`SubcomposeLayout`, `LazyLayoutCacheWindow`, `androidx.compose.runtime:runtime-tracing`, `proguard-android-optimize.txt`).

**Existing skill that already covers this (if applicable):**

If the request is an improvement, name the SKILL.md path and the section that needs the change. If the request is for a new skill, list any skills that partially overlap so the cross-references can be wired correctly.

**Authoritative sources:**

Link to the primary sources the new content should be grounded in: Android Developers documentation, AndroidX source on `cs.android.com`, Compose Compiler source, posts by Ben Trengrove / Chris Banes / Manuel Vivo, skydoves writing on ProAndroidDev or the GetStream blog. Skills must cite primary sources; secondary blogs alone are not sufficient.

**Proposed workflow or fix:**

If the request includes a specific change, sketch it as numbered workflow steps or a RIGHT / WRONG snippet pair. Following the same structure as the existing skills makes review easier.
