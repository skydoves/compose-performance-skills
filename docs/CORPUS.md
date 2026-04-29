# compose-performance-skills — Research Corpus (synthesized)

This file is the distilled knowledge base. Skill authors pull facts, code samples, and citations from here so every SKILL.md is consistent.

---

## A. Canonical external references

Cite these directly in SKILL.md "References" sections.

### Android Developers (official)
- Performance overview — https://developer.android.com/develop/ui/compose/performance
- Stability — overview: https://developer.android.com/develop/ui/compose/performance/stability
- Stability — diagnose: https://developer.android.com/develop/ui/compose/performance/stability/diagnose
- Stability — fix: https://developer.android.com/develop/ui/compose/performance/stability/fix
- Strong Skipping: https://developer.android.com/develop/ui/compose/performance/stability/strongskipping
- Phases: https://developer.android.com/develop/ui/compose/phases
- Phases & perf: https://developer.android.com/develop/ui/compose/performance/phases
- Custom modifiers (Modifier.Node): https://developer.android.com/develop/ui/compose/custom-modifiers
- Lists & grids: https://developer.android.com/develop/ui/compose/lists
- Baseline Profiles: https://developer.android.com/topic/performance/baselineprofiles/overview
- Baseline Profiles w/ Compose: https://developer.android.com/develop/ui/compose/performance/baseline-profiles
- Benchmark BP w/ Macrobenchmark: https://developer.android.com/topic/performance/baselineprofiles/measure-baselineprofile
- CompositionLocal: https://developer.android.com/develop/ui/compose/compositionlocal
- R8 keep rules: https://developer.android.com/topic/performance/app-optimization/keep-rules-overview
- R8 2025 guide: https://android-developers.googleblog.com/2025/11/configure-and-troubleshoot-r8-keep-rules.html
- Graphics modifiers: https://developer.android.com/develop/ui/compose/graphics/draw/modifiers
- Practical perf codelab: https://developer.android.com/codelabs/jetpack-compose-performance
- Compose Compiler release notes: https://developer.android.com/jetpack/androidx/releases/compose-compiler
- What's new Dec '25 (1.10): https://android-developers.googleblog.com/2025/12/whats-new-in-jetpack-compose-december.html
- What's new Apr '25 (1.8): https://android-developers.googleblog.com/2025/04/whats-new-in-jetpack-compose-april-25.html
- What's new May '25 (1.9): https://android-developers.googleblog.com/2025/05/whats-new-in-jetpack-compose.html

### Ben Trengrove / Android Developers Medium
- Stability explained: https://medium.com/androiddevelopers/jetpack-compose-stability-explained-79c10db270c8
- New ways to optimize stability: https://medium.com/androiddevelopers/new-ways-of-optimizing-stability-in-jetpack-compose-038106c283cc
- Strong Skipping explained: https://medium.com/androiddevelopers/jetpack-compose-strong-skipping-mode-explained-cbdb2aa4b900
- When to use derivedStateOf: https://medium.com/androiddevelopers/jetpack-compose-when-should-i-use-derivedstateof-63ce7954c11b
- Debugging recomposition: https://medium.com/androiddevelopers/jetpack-compose-debugging-recomposition-bfcf4a6f8d37
- Why test perf in release: https://medium.com/androiddevelopers/why-should-you-always-test-compose-performance-in-release-4168dd0f2c71

### Chris Banes
- Composable metrics: https://chrisbanes.me/posts/composable-metrics/
- Compose perf tag: https://chrisbanes.me/tags/jetpack-compose-performance/

### Manuel Vivo
- Consuming flows safely: https://medium.com/androiddevelopers/consuming-flows-safely-in-jetpack-compose-cde014d0d5a3

### Skydoves (Jaewoong Eum)
- compose-performance hub: https://github.com/skydoves/compose-performance
- compose-stability-inference: https://github.com/skydoves/compose-stability-inference
- compose-stability-analyzer: https://github.com/skydoves/compose-stability-analyzer
- compose-stable-marker: https://github.com/skydoves/compose-stable-marker
- compose-effects: https://github.com/skydoves/compose-effects
- compose-hotswan-web (HotSwan docs / marketing portal): https://github.com/skydoves/compose-hotswan-web
- HotSwan JetBrains plugin: https://plugins.jetbrains.com/plugin/30551-compose-hotswan/
- "Optimize App Performance by Mastering Stability": https://medium.com/proandroiddev/optimize-app-performance-by-mastering-stability-in-jetpack-compose-69f40a8c785d
- "6 Jetpack Compose Guidelines": https://medium.com/proandroiddev/6-jetpack-compose-guidelines-to-optimize-your-app-performance-be18533721f9
- Baseline Profiles w/ GetStream: https://getstream.io/blog/android-baseline-profile/
- Jetpack Compose Mechanism (slides): https://speakerdeck.com/skydoves/jetpack-compose-mechanism

### Others
- Zach Klipp on derivedStateOf: https://blog.zachklipp.com/how-derivedstateof-works-a-deep-d-er-ive/
---

## B. Core concept cheatsheet

### Stability (the single most important Compose perf concept)

A type is **stable** iff:
1. Observable state never changes after construction, OR mutations notify Compose (via Snapshot).
2. `equals()` is structural.
3. Every public property type is itself stable.

Consequence: the Compose compiler emits a `skipToGroupEnd()` guard in every restartable composable. If all params equal the previous call, the body is skipped.

### Five compiler-level stability types (from compose-stability-inference)

1. **Stability.Certain** — primitives, String, Unit, function types, enums, `@Stable`/`@Immutable`-annotated.
2. **Stability.Runtime** — separately compiled class; compiler generates a `$stable: Int` field queried at runtime.
3. **Stability.Unknown** — interfaces, abstract classes without concrete analysis; falls back to `===` at runtime.
4. **Stability.Parameter** — generics like `Wrapper<T>`; resolved by substituting `T`.
5. **Stability.Combined** — aggregate. **Unstable dominates** — any single unstable component makes the whole unstable.

### Bitmask encoding for generics

`Container<T1,T2,T3>` with bitmask `0b101` = T1 affects stability, T2 doesn't, T3 does. Known examples:
- `kotlin.Pair` → `0b11`
- `kotlin.Triple` → `0b111`
- `kotlinx.collections.immutable.ImmutableList` → `0b1`
- `java.math.BigInteger` → `0b0`

### 12-phase inference algorithm (distilled)

1. Primitive fast path → STABLE
2. String/Unit fast path → STABLE
3. Function type fast path → STABLE
4. Type parameter substitution
5. Nullable unwrap (`Int?` → analyze `Int`)
6. Inline class — check underlying type
7. Cycle detection (conservative: recursive trees → UNSTABLE)
8. Annotations check (`@Stable`, `@Immutable`, `@StableMarker`)
9. Known stable constructs registry (Pair/Triple/Result/ImmutableList/dagger.Lazy)
10. External configuration match (stability-config.conf patterns)
11. External module (`@StabilityInferred` annotation)
12. Field-by-field: any `var` → UNSTABLE; any unstable field type → UNSTABLE; else Combined of all fields.

### Skippable / Restartable / NonRestartable

- **Restartable**: composable is a recomposition entry point (has its own restart scope). Most @Composable functions. NOT inline composables (`Row`/`Column`/`Box`).
- **Skippable**: compiler emits the skip-on-equal-params guard. Requires all params stable pre-strong-skipping.
- `@NonRestartableComposable` — trivial composable, drop the restart scope.
- `@NonSkippableComposable` — force always-recompose under strong skipping.
- `@DontMemoize` — disable strong-skipping's auto-remember on a specific lambda.

### Strong Skipping Mode (default since Kotlin 2.0.20)

Changes:
1. Every restartable composable is now skippable regardless of param stability. Unstable params compared by `===`; stable by `equals`.
2. Every lambda inside a @Composable is auto-wrapped in `remember(captures) { ... }`.

Gradle flag (pre-2.0.20):
```kotlin
composeCompiler { enableStrongSkippingMode = true }
```

Does NOT memoize lambdas in:
- `LazyListScope.items { }` (not @Composable context)
- `Modifier.pointerInput { }` (not @Composable context)
- Object expressions

### Compose Compiler Reports

```kotlin
composeCompiler {
    reportsDestination = layout.buildDirectory.dir("compose_compiler")
    metricsDestination = layout.buildDirectory.dir("compose_compiler")
    stabilityConfigurationFiles.add(
        rootProject.layout.projectDirectory.file("stability_config.conf")
    )
}
```

Run `./gradlew assembleRelease` (**release only** — debug adds Live Literals).

Four outputs per module:
- `<module>-classes.txt` — per-class stability breakdown
- `<module>-composables.txt` — per-function signatures with restartable/skippable flags and per-param stability
- `<module>-composables.csv` — CSV of the above (for CI)
- `<module>-module.json` — aggregate counts

Sample composables.txt line:
```
restartable scheme("[androidx.compose.ui.UiComposable]") fun HighlightedSnacks(
  stable index: Int,
  unstable snacks: List<Snack>,       // <-- blocks skipping
  stable onSnackClick: Function1<Long, Unit>,
)
```

Sample classes.txt:
```
stable class User { stable val id: Int; stable val name: String }
unstable class Counter { unstable var count: Int }
runtime stable class Box { stable val value: T }
```

### Stability configuration file (Compose Compiler 1.5.5+)

Plain text. Patterns:
```
java.time.LocalDateTime           # single class
com.example.data.*                # single package segment
com.example.data.**               # package + subpackages
com.example.GenericClass<*,_>     # bit 0 affects, bit 1 ignored
kotlin.collections.*              # make List/Set/Map stable project-wide
# comments allowed with #
```

Wire up (preferred — plural `stabilityConfigurationFiles` is a `ListProperty`):
```kotlin
composeCompiler {
    stabilityConfigurationFiles.add(
        rootProject.layout.projectDirectory.file("stability_config.conf")
    )
}
```

> Legacy singular form `stabilityConfigurationFile = file("…")` is `@Deprecated("Use the stabilityConfigurationFiles option instead")` — still works, but new code should use the plural `.add(...)` API above.

**Critical:** "These configurations don't make a class stable. They opt you into a contract with the compiler." Break it → silent missed recompositions.

### Three phases

1. **Composition** — run composable functions to produce a tree.
2. **Layout** — measure & place nodes.
3. **Draw** — record draw commands.

A state read in phase N invalidates phase N and all phases below. Push reads as low as possible via lambda-based modifiers:

```kotlin
// WRONG — reads in Composition
Box(Modifier.offset(x = offsetX.value.dp))

// RIGHT — reads in Layout only
Box(Modifier.offset { IntOffset(offsetX.value.toInt(), 0) })

// BEST for alpha — reads in Draw only
Box(Modifier.graphicsLayer { alpha = animatedAlpha.value })
```

### derivedStateOf

Wraps a State whose value only invalidates readers when the **derived** result changes (even if inputs change more often).

```kotlin
// RIGHT — scroll position changes every pixel, boolean changes rarely
val isAtTop by remember {
    derivedStateOf { lazyListState.firstVisibleItemIndex == 0 }
}
```

Rule: use ONLY when input changes more frequently than output. Using for `"$first $last"` concatenation is pure overhead.

Pitfall: captures non-state vars by initial value forever. Fix by passing them as `remember` keys.

### LazyList perf

- **`key`** — stable ID per item. Preserves composition and state across mutations. Enables `Modifier.animateItem()`.
- **`contentType`** — groups cached compositions by type (RecyclerView view-type equivalent).
- **`LazyLayoutCacheWindow`** (Compose Foundation 1.9+) — configurable ahead/behind prefetch window.
- **Pausable composition in prefetch** (Compose 1.10, default on) — prefetch work is split across frames instead of a single frame.

```kotlin
LazyColumn {
    items(
        items = snacks,
        key = { it.id },                         // MUST for animateItem, recommended always
        contentType = { it::class },             // preferred for mixed-type feeds
    ) { snack -> SnackRow(snack, Modifier.animateItem()) }
}
```

### Modifier.Node vs composed

`composed { }` creates a fresh composable scope per modifier per composition — can't be skipped, allocates every time, can't be hoisted.

`Modifier.Node` is a persistent node diffed by `ModifierNodeElement.equals()`:

```kotlin
private data class CircleElement(val color: Color) : ModifierNodeElement<CircleNode>() {
    override fun create() = CircleNode(color)
    override fun update(node: CircleNode) { node.color = color }
}

private class CircleNode(var color: Color) : Modifier.Node(), DrawModifierNode {
    override fun ContentDrawScope.draw() { drawCircle(color); drawContent() }
}

fun Modifier.circle(color: Color): Modifier = this then CircleElement(color)
```

Specialized interfaces: `LayoutModifierNode`, `DrawModifierNode`, `SemanticsModifierNode`, `PointerInputModifierNode`, `CompositionLocalConsumerModifierNode`, `LayoutAwareModifierNode`, `GlobalPositionAwareModifierNode`, `ObserverModifierNode`, `DelegatingNode`, `TraversableNode`.

### Flow collection

Use `collectAsStateWithLifecycle()` from `androidx.lifecycle:lifecycle-runtime-compose`, NOT plain `collectAsState()`, for any flow originating outside the composition (ViewModel StateFlow, Repository flows). Prevents background CPU/battery drain.

```kotlin
val state by viewModel.uiState.collectAsStateWithLifecycle()
```

For high-frequency flows, add `.conflate()` or `.distinctUntilChanged()` upstream.

### Side-effect efficiency

- `LaunchedEffect(key)` — coroutine, cancelled/restarted on key change. Use for async work.
- `RememberedEffect(key)` (skydoves/compose-effects) — non-coroutine analog; cheaper when you don't need a scope.
- `DisposableEffect(key)` — for setup/teardown with a cleanup block.
- `rememberUpdatedState(latest)` — keep a reference fresh inside a long-lived `LaunchedEffect`.

### Baseline Profiles & Macrobenchmark

AGP 8.2+ has "Baseline Profile Generator" module template. Adds `androidx.baselineprofile` plugin.

```kotlin
@RunWith(AndroidJUnit4::class)
class StartupBenchmark {
    @get:Rule val rule = MacrobenchmarkRule()

    @Test fun startupCompilationBaselineProfiles() = rule.measureRepeated(
        packageName = "com.example",
        metrics = listOf(StartupTimingMetric()),
        iterations = 10,
        startupMode = StartupMode.COLD,
        compilationMode = CompilationMode.Partial(BaselineProfileMode.Require),
    ) {
        pressHome(); startActivityAndWait()
    }
}
```

Scroll journey (example):
```kotlin
rule.measureRepeated(
    metrics = listOf(FrameTimingMetric()),
    compilationMode = CompilationMode.Partial(BaselineProfileMode.Require),
    iterations = 5,
) {
    startActivityAndWait()
    device.findObject(By.res("feed")).fling(Direction.DOWN)
}
```

Use `ReportDrawn` / `ReportDrawnWhen` / `ReportDrawnAfter` from `androidx.activity` to signal fully-drawn correctly.

### R8

- Use `proguard-android-optimize.txt`, NOT `proguard-android.txt`.
- Full mode is default (AGP 8.0+).
- Compose ships consumer rules — you typically need NO Compose-specific keep rules.
- Cited perf gain from R8 on Compose: ~75% startup, ~60% frame-render improvement (debug vs release).

```kotlin
buildTypes.release {
    isMinifyEnabled = true
    isShrinkResources = true
    proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
}
```

### Release-mode rule

Debug builds:
- Compose runs interpreted (unbundled, JIT takes time).
- Live Literals turn constants into getters that defeat compile-time folding and look "dynamic" to the recomposer.
- Recomposition counts in debug are not representative.

**MUST** profile release + R8 + real device.

### CompositionLocal

- `compositionLocalOf` — tracks reads; only readers recompose on change.
- `staticCompositionLocalOf` — does NOT track reads; changing value invalidates the entire content lambda of `CompositionLocalProvider`.

Use static for effectively-never-changing values (LocalContext). Use dynamic for runtime-changing values (dark mode, locale, animated theme colors).

---

## C. Skydoves tools reference

### @TraceRecomposition (compose-stability-analyzer runtime)

```kotlin
@TraceRecomposition(traceStates = true)
@Composable
fun RecompositionTrackingExample() {
    var counter by remember { mutableIntStateOf(0) }
    // ...
}

// In Application:
ComposeStabilityAnalyzer.setEnabled(BuildConfig.DEBUG)
```

Logcat output:
```
D/Recomposition: [Recomposition #1] RecompositionTrackingExample
D/Recomposition:   ├─ [state] counter: Int changed (0 → 1)
```

### stabilityDump / stabilityCheck (CI workflow)

Plugin ID: `com.github.skydoves.compose.stability.analyzer` (v0.7.3+).

```kotlin
plugins { alias(libs.plugins.compose.stability.analyzer) }

composeStabilityAnalyzer {
    enabled.set(true)
    stabilityValidation {
        enabled.set(true)
        outputDir.set(layout.projectDirectory.dir("stability"))
        failOnStabilityChange.set(true)
        ignoredPackages.set(listOf("com.example.preview"))
        stabilityConfigurationFiles.add(file("stability_config.conf"))
    }
}
```

Tasks:
- `./gradlew :app:stabilityDump` — generate baseline `.stability` file
- `./gradlew :app:stabilityCheck` — fail CI on regression

Sample baseline file entry:
```
@Composable
public fun com.example.CounterDisplay(count: com.example.MainViewModel): kotlin.Unit
  skippable: false
  restartable: true
  params:
    - count: RUNTIME (requires runtime check)
```

### compose-stable-marker

`compileOnly` dependency giving `@Stable`/`@Immutable`/`@StableMarker` to pure-Kotlin modules without pulling `compose-runtime`. Newer official equivalent: `androidx.compose.runtime:runtime-annotation`.

### compose-effects

- `RememberedEffect(key) { ... }` — non-coroutine LaunchedEffect analog.
- `ViewModelStoreScope { ... }` — composable-scoped ViewModelStore for per-row ViewModels in LazyColumn.

### ComposeGuard (community tool)

Gradle plugin that fails CI when new restartable-but-not-skippable composables or new unstable classes are added. Tasks: `<variant>ComposeCompilerGenerate`, `<variant>ComposeCompilerCheck`. Multiplatform-compatible.

---

## D-pre. Hot reload — Compose HotSwan

Compose HotSwan (`com.github.skydoves.compose.hotswan.compiler`, latest 1.2.10 at the time of authoring) is a JetBrains IDE plugin + Gradle compiler plugin that swaps changed Kotlin classes into a running app on a real device or emulator in **under one second**, preserving app state. Distributed via JetBrains Marketplace + Maven Central. **Authoritative version source: https://hotswan.dev/docs/releases — always check there for the latest stable version before pinning.**

### Architecture (5-step pipeline)
1. IDE plugin (Android Studio 2024.3+ / IntelliJ 2024.3+) detects file save via VFS listener.
2. Incremental Kotlin compile + D8 dex generation, scoped to changed module only.
3. Class filtering: extracts only changed `.class` files from the dex output.
4. Runtime class swap on device via ART class redefinition (JVMTI-flavored).
5. Compose recomposition with three tiers (see "State preservation" below).

### Gradle setup
```toml
# libs.versions.toml
[plugins]
hotswan-compiler = { id = "com.github.skydoves.compose.hotswan.compiler", version = "1.2.10" }
```

```kotlin
// app/build.gradle.kts
plugins {
    alias(libs.plugins.hotswan.compiler)
}

hotSwanCompiler {
    enabled = true
    debugOnly = true        // skip transform for release builds — zero runtime overhead
}
```

`debugOnly = true` is the default and is non-negotiable for release: HotSwan transformations are diagnostic-only and MUST NOT ship in production builds.

### Three-tier recomposition / state preservation

| Tier | Mechanism | Preserves | Triggered when |
|---|---|---|---|
| 1. Targeted recomposition | recomposes only affected scopes in place | navigation back stack, scroll position, `remember`, `rememberSaveable`, `ViewModel`, lazy layout items, dialog/sheet state | simple body change inside one composable scope |
| 2. Composition reset | dispose + recreate all compositions | Activity, ViewModel, navigation (via NavController), saved state | tier 1 unavailable (theme change, root-scope structural change) |
| 3. `Activity.recreate()` | last resort — recreate Activity | ViewModel, SavedInstanceState | composition fails / structural mismatch |

### What hot-reloads (supported changes)

- Composable function body (text, colors, modifiers, layout, control flow)
- Non-composable function body (ViewModel methods, mappers, utilities)
- Adding new composables (same file or cross-file)
- Reordering composables (1.2.0+)
- Resource values: `strings.xml`, `colors.xml`, `dimens.xml`
- Extension functions, suspend functions, vararg
- Adding data class properties (API 30+)
- Numeric / string / float literal patches (compiled separately for fastest reload)

### What forces full rebuild (limits)

ART enforces class schema immutability — only **method bodies** can change at runtime. Anything that changes the schema falls back to a full incremental build (HotSwan detects automatically; no surprise failure):

- Adding or removing function parameters
- Constructor changes
- Interface or superclass changes
- Adding new resource IDs (new R.string / R.drawable entries)
- Inline functions (expanded at call sites; no discrete unit to swap)
- Lambda count changes (internal class renumbering)
- Removing previously defined functions

### MCP server + AI integration

HotSwan ships an embedded HTTP MCP server inside the IntelliJ plugin so AI tools (Claude Code, Cursor, any MCP client) can drive the iteration loop autonomously.

MCP tools exposed:
- `hotswan_get_status()` — device, app, watcher state
- `hotswan_reload(filePaths)` — trigger reload for edited files
- `hotswan_take_screenshot()` — capture device screenshot
- `hotswan_start_snapshot()` / `hotswan_stop_snapshot()` — toggle snapshot history
- `hotswan_select_variant()` — pick favorite variant from snapshots
- `hotswan_build_and_install()` — fall back to full install when needed

AI loop: AI edits file → HotSwan auto-reloads → AI captures screenshot via MCP → AI evaluates → AI iterates.

### Other features

- Snapshot + time-travel: auto-screenshots after every reload, code rollback to any snapshot
- Preview Runner: run `@Preview` composables on a real device in ~0.5s
- Multi-device broadcasting: phone + tablet + emulator simultaneously
- KMP-aware: detects configuration cache, supports Compose Multiplatform targets
- Compose 1.11 LinkBuffer support (1.2.7+): adapts reflection to detect gapbuffer vs linkbuffer SlotTable backend at runtime

### Comparison vs official tools

| Capability | HotSwan | JB Live Edit | JB Hot Reload (2025) | Apply Changes |
|---|---|---|---|---|
| Composable body edits | yes | yes | yes | limited |
| Non-composable function edits | yes | no | partial | no |
| Resource (.xml) changes | yes | no | no | no |
| State preservation | 3-tier | automatic | unknown | no |
| Real device | yes | preview only | emulator | yes (limited) |
| Multi-device broadcast | yes | no | no | no |
| Snapshot / time-travel | yes | no | no | no |
| MCP / AI integration | yes (built-in server) | no | unlikely | no |
| Speed | <1s | 2–5s | 2–4s | 3–10s |

HotSwan's gap: real-device + non-composable + resource hot reload + AI loop, all in one toolchain. Not a replacement for full rebuild during release; a pure development-time accelerator.

---

## D. Version matrix (2026-04-25 current)

- Kotlin 2.0.20+ → Strong Skipping default ON.
- Compose Compiler plugin now ships as part of Kotlin 2.0+ via `org.jetbrains.kotlin.plugin.compose` (no more `kotlinCompilerExtensionVersion`).
- Compose Foundation 1.9+ → `LazyLayoutCacheWindow` API.
- Compose Foundation 1.10+ → pausable composition in lazy prefetch (default on).
- Compose Compiler 1.5.5+ → `stabilityConfigurationFiles` DSL (plural; singular `stabilityConfigurationFile` is now deprecated).
- Compose UI 1.7+ → `rememberGraphicsLayer()`, shared element transitions GA, `Modifier.animateItem()` GA.
- AGP 8.2+ → Baseline Profile Generator module template.

---

## E. Symptom → diagnosis table

| Symptom | Likely cause | Fix skill |
|---|---|---|
| Scroll jank on LazyColumn | Missing keys / non-skippable items / prefetch not configured | `lists/optimizing-lazy-layouts`, `lists/configuring-lazy-prefetch` |
| Entire screen recomposes on scroll | State read in wrong phase | `recomposition/deferring-state-reads` |
| Recomposition count high despite params equal | Unstable param (List/Set/Map/Flow/var/interface) | `stability/diagnosing-compose-stability`, `stability/stabilizing-compose-types` |
| Slow cold startup | No Baseline Profile / R8 misconfigured | `measurement/generating-baseline-profiles`, `build/configuring-r8-for-compose` |
| derivedStateOf not firing | Non-state var captured by initial value | `recomposition/choosing-derivedstateof` |
| Custom modifier causes recomposition | `composed { }` usage | `modifiers/migrating-to-modifier-node` |
| ViewModel flow drains battery | `collectAsState` instead of `collectAsStateWithLifecycle` | `side-effects/collecting-flows-safely` |
| Animation causes subtree recompose | `Modifier.alpha(state.value)` instead of `graphicsLayer { }` | `recomposition/deferring-state-reads` |
| Theme toggle recomposes everything | `staticCompositionLocalOf` for changing value | future: `side-effects/using-composition-locals-wisely` (out of scope v1) |
