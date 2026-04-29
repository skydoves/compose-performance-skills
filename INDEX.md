# INDEX — Symptom and API lookup for compose-performance-skills

This index maps a developer's symptom or API of interest to the skill that resolves it. Use it as the entry point: skim **By symptom** first, then **By API** for a more targeted lookup, then **By workflow phase** to understand where each skill fits in the Measure → Diagnose → Fix → Verify loop.

## By symptom

| Symptom | Likely cause | Skill |
|---|---|---|
| Scroll jank in `LazyColumn` or `LazyVerticalGrid` | Missing `key`, non-skippable item composables, prefetch not configured | [lists/optimizing-lazy-layouts](lists/optimizing-lazy-layouts/SKILL.md), [lists/configuring-lazy-prefetch](lists/configuring-lazy-prefetch/SKILL.md) |
| Entire screen recomposes during scroll or animation | State read in Composition phase instead of Layout or Draw | [recomposition/deferring-state-reads](recomposition/deferring-state-reads/SKILL.md) |
| Recomposition count high even when params look equal | Unstable parameter (`List`, `Set`, `Map`, `Flow`, `var`, interface) | [stability/diagnosing-compose-stability](stability/diagnosing-compose-stability/SKILL.md), [stability/stabilizing-compose-types](stability/stabilizing-compose-types/SKILL.md) |
| Slow cold startup | No Baseline Profile, R8 misconfigured, or measured in debug | [measurement/generating-baseline-profiles](measurement/generating-baseline-profiles/SKILL.md), [build/configuring-r8-for-compose](build/configuring-r8-for-compose/SKILL.md), [measurement/testing-compose-in-release-mode](measurement/testing-compose-in-release-mode/SKILL.md) |
| `derivedStateOf` not firing or firing on every input change | Non-state var captured by initial value, or wrong use case | [recomposition/choosing-derivedstateof](recomposition/choosing-derivedstateof/SKILL.md) |
| Custom modifier triggers recomposition on every parent invalidation | `composed { }` allocates a fresh scope each time | [modifiers/migrating-to-modifier-node](modifiers/migrating-to-modifier-node/SKILL.md) |
| ViewModel `Flow` drains battery in background | `collectAsState()` keeps collecting off-screen | [side-effects/collecting-flows-safely](side-effects/collecting-flows-safely/SKILL.md) |
| `Modifier.alpha(state.value)` invalidates the subtree | Animated state read in Composition instead of Draw | [recomposition/deferring-state-reads](recomposition/deferring-state-reads/SKILL.md) |
| Compose Compiler report shows unstable third-party type | No `stability_config.conf` entry for the dependency | [stability/stabilizing-compose-types](stability/stabilizing-compose-types/SKILL.md) |
| Compiler report unreadable, surprising, or absent | Reports not enabled, generated from a debug build, or output format unfamiliar | [stability/diagnosing-compose-stability](stability/diagnosing-compose-stability/SKILL.md), [stability/understanding-stability-inference](stability/understanding-stability-inference/SKILL.md) |
| Need to confirm a specific composable recomposes too often | No instrumentation in place | [recomposition/debugging-recompositions](recomposition/debugging-recompositions/SKILL.md), [measurement/tracing-recompositions-at-runtime](measurement/tracing-recompositions-at-runtime/SKILL.md) |
| Mixed-type list reuses wrong cached compositions | `contentType` not declared in `items { }` | [lists/optimizing-lazy-layouts](lists/optimizing-lazy-layouts/SKILL.md) |
| `LazyColumn` prefetch dropping frames at high scroll velocity | Default cache window too small or pausable prefetch off | [lists/configuring-lazy-prefetch](lists/configuring-lazy-prefetch/SKILL.md) |
| `LaunchedEffect` keeps restarting unexpectedly | Wrong key, or should have been `RememberedEffect` / `DisposableEffect` | [side-effects/using-efficient-effects](side-effects/using-efficient-effects/SKILL.md) |
| Modifier chain produces unexpected painting or measurement | `.then()` ordering wrong; `padding` vs `background` flipped | [modifiers/ordering-modifier-chains](modifiers/ordering-modifier-chains/SKILL.md) |
| `BoxWithConstraints` or `Scaffold` regresses scroll perf or first frame | `SubcomposeLayout` composes during the measure pass; nesting or per-item use multiplies the cost | [recomposition/avoiding-subcomposition-pitfalls](recomposition/avoiding-subcomposition-pitfalls/SKILL.md) |
| `BoxWithConstraints` inside a `LazyColumn`/`LazyRow`/`LazyVerticalGrid` item | Each item subcomposes during the lazy layout's measure pass | [recomposition/avoiding-subcomposition-pitfalls](recomposition/avoiding-subcomposition-pitfalls/SKILL.md) |
| Custom `SubcomposeLayout`'s `measurePolicy` block creates a fresh `subcompose` lambda per measurement | The same anti-pattern AndroidX's own `ComposableLambdaInMeasurePolicy` lint flags internally | [recomposition/avoiding-subcomposition-pitfalls](recomposition/avoiding-subcomposition-pitfalls/SKILL.md) |
| Strong skipping not behaving as expected | Lambda passed in `LazyListScope.items { }` not auto-memoized; `@DontMemoize` needed somewhere | [recomposition/using-strong-skipping-correctly](recomposition/using-strong-skipping-correctly/SKILL.md) |
| Stability regressions slip into `main` | No CI gate on stability output | [stability/enforcing-stability-in-ci](stability/enforcing-stability-in-ci/SKILL.md) |
| Why is class X classified as `runtime` / `unknown` / `unstable`? | Compiler inference subtleties (generics, cycles, separate compilation) | [stability/understanding-stability-inference](stability/understanding-stability-inference/SKILL.md) |
| Performance degrades but no clear starting point | Need an end-to-end audit | [audit/auditing-compose-performance](audit/auditing-compose-performance/SKILL.md) |
| Want instant UI feedback on a real device without rebuilds | HotSwan not installed or configured | [hot-reload/setting-up-compose-hotswan](hot-reload/setting-up-compose-hotswan/SKILL.md) |
| Hot reload triggered a full rebuild instead of swapping classes | Schema change (parameter add, constructor edit, inline function, new resource ID) | [hot-reload/understanding-hot-reload-limits](hot-reload/understanding-hot-reload-limits/SKILL.md) |
| Scroll position or dialog state lost after a hot reload | Reload escalated to tier 2 or tier 3; local `remember` not Saveable | [hot-reload/preserving-state-across-reloads](hot-reload/preserving-state-across-reloads/SKILL.md) |
| AI agent should edit, reload, and screenshot the device autonomously | No MCP loop wired up | [hot-reload/iterating-with-ai-and-mcp](hot-reload/iterating-with-ai-and-mcp/SKILL.md) |
| Want stability feedback while editing without running a Gradle build | Compose Stability Analyzer IDEA plugin not installed or disabled | [stability/using-stability-analyzer-ide-plugin](stability/using-stability-analyzer-ide-plugin/SKILL.md) |
| Need to see which composables a single change would invalidate downstream | No call-graph visualization in place | [stability/visualizing-recomposition-cascades](stability/visualizing-recomposition-cascades/SKILL.md) |
| Want a live in-IDE heatmap of recomposition counts during interaction | Heatmap toggle off or `@TraceRecomposition` not applied | [stability/visualizing-recomposition-cascades](stability/visualizing-recomposition-cascades/SKILL.md), [measurement/tracing-recompositions-at-runtime](measurement/tracing-recompositions-at-runtime/SKILL.md) |
| Inspection flags a composable as `UnstableComposable` and the developer wants to triage | False positive vs real instability classification | [stability/using-stability-analyzer-ide-plugin](stability/using-stability-analyzer-ide-plugin/SKILL.md) |

## By API

| API or tool | Skill |
|---|---|
| `derivedStateOf`, `snapshotFlow` | [recomposition/choosing-derivedstateof](recomposition/choosing-derivedstateof/SKILL.md) |
| `Modifier.offset { }`, `Modifier.graphicsLayer { }`, `Modifier.drawBehind`, lambda-based modifiers | [recomposition/deferring-state-reads](recomposition/deferring-state-reads/SKILL.md) |
| `Modifier.Node`, `ModifierNodeElement`, `DrawModifierNode`, `LayoutModifierNode`, `CompositionLocalConsumerModifierNode` | [modifiers/migrating-to-modifier-node](modifiers/migrating-to-modifier-node/SKILL.md) |
| `Modifier.then()`, modifier ordering, hoisting modifier chains | [modifiers/ordering-modifier-chains](modifiers/ordering-modifier-chains/SKILL.md) |
| `SubcomposeLayout`, `SubcomposeLayoutState`, `SubcomposeSlotReusePolicy`, `precompose`, `BoxWithConstraints`, `Scaffold`, `Modifier.onSizeChanged` | [recomposition/avoiding-subcomposition-pitfalls](recomposition/avoiding-subcomposition-pitfalls/SKILL.md) |
| `LazyColumn`, `LazyRow`, `LazyVerticalGrid`, `key`, `contentType`, `Modifier.animateItem()` | [lists/optimizing-lazy-layouts](lists/optimizing-lazy-layouts/SKILL.md) |
| `LazyLayoutCacheWindow`, `NestedPrefetchScope`, pausable prefetch | [lists/configuring-lazy-prefetch](lists/configuring-lazy-prefetch/SKILL.md) |
| `collectAsStateWithLifecycle`, `collectAsState`, `StateFlow`, `SharedFlow`, `conflate`, `distinctUntilChanged` | [side-effects/collecting-flows-safely](side-effects/collecting-flows-safely/SKILL.md) |
| `LaunchedEffect`, `DisposableEffect`, `RememberedEffect`, `rememberUpdatedState`, `ViewModelStoreScope` | [side-effects/using-efficient-effects](side-effects/using-efficient-effects/SKILL.md) |
| `@Stable`, `@Immutable`, `@StableMarker`, `kotlinx.collections.immutable`, `compose-stable-marker`, `runtime-annotation` | [stability/stabilizing-compose-types](stability/stabilizing-compose-types/SKILL.md) |
| Compose Compiler reports (`<module>-classes.txt`, `<module>-composables.txt`, `<module>-module.json`) | [stability/diagnosing-compose-stability](stability/diagnosing-compose-stability/SKILL.md) |
| `stability_config.conf`, `stabilityConfigurationFile` DSL | [stability/stabilizing-compose-types](stability/stabilizing-compose-types/SKILL.md) |
| `@StabilityInferred`, `$stable` field, bitmask encoding, 12-phase inference | [stability/understanding-stability-inference](stability/understanding-stability-inference/SKILL.md) |
| `@TraceRecomposition`, `ComposeStabilityAnalyzer.setEnabled` | [measurement/tracing-recompositions-at-runtime](measurement/tracing-recompositions-at-runtime/SKILL.md) |
| Layout Inspector recomposition + skip counts | [recomposition/debugging-recompositions](recomposition/debugging-recompositions/SKILL.md) |
| `stabilityDump`, `stabilityCheck`, `composeStabilityAnalyzer { }` Gradle DSL | [stability/enforcing-stability-in-ci](stability/enforcing-stability-in-ci/SKILL.md) |
| Baseline Profile Generator, `androidx.baselineprofile` plugin, `BaselineProfileRule`, `MacrobenchmarkRule`, `StartupTimingMetric`, `FrameTimingMetric`, `CompilationMode.Partial`, `ReportDrawn` | [measurement/generating-baseline-profiles](measurement/generating-baseline-profiles/SKILL.md) |
| Strong skipping mode, `enableStrongSkippingMode`, `@NonSkippableComposable`, `@DontMemoize`, lambda auto-memoization | [recomposition/using-strong-skipping-correctly](recomposition/using-strong-skipping-correctly/SKILL.md) |
| R8 full mode, `proguard-android-optimize.txt`, Compose consumer rules | [build/configuring-r8-for-compose](build/configuring-r8-for-compose/SKILL.md) |
| Live Literals, debug vs release Compose perf, interpreted mode | [measurement/testing-compose-in-release-mode](measurement/testing-compose-in-release-mode/SKILL.md) |
| End-to-end audit orchestration | [audit/auditing-compose-performance](audit/auditing-compose-performance/SKILL.md) |
| `com.github.skydoves.compose.hotswan.compiler` Gradle plugin, `hotSwanCompiler { enabled, debugOnly }` DSL, HotSwan IDE plugin | [hot-reload/setting-up-compose-hotswan](hot-reload/setting-up-compose-hotswan/SKILL.md) |
| ART class redefinition limits, supported vs unsupported change types | [hot-reload/understanding-hot-reload-limits](hot-reload/understanding-hot-reload-limits/SKILL.md) |
| Three tier recomposition (targeted, composition reset, Activity recreate), `rememberSaveable`, `LazyListState` saveability | [hot-reload/preserving-state-across-reloads](hot-reload/preserving-state-across-reloads/SKILL.md) |
| `hotswan_get_status`, `hotswan_reload`, `hotswan_take_screenshot`, `hotswan_start_snapshot`, `hotswan_stop_snapshot`, `hotswan_select_variant`, `hotswan_build_and_install` MCP tools | [hot-reload/iterating-with-ai-and-mcp](hot-reload/iterating-with-ai-and-mcp/SKILL.md) |
| Compose Stability Analyzer IDEA plugin: `StabilityLineMarkerProvider` gutter icons, `StabilityDocumentationProvider` hover tooltips, `StabilityInlayHintsProvider` inline hints, `StabilityInspection` inspection (`UnstableComposable`), `AddTraceRecompositionIntention` quick fix | [stability/using-stability-analyzer-ide-plugin](stability/using-stability-analyzer-ide-plugin/SKILL.md) |
| Compose Stability Analyzer tool window (Explorer, Cascade, Heatmap tabs), `AnalyzeCascadeAction`, `ToggleHeatmapAction`, `ClearHeatmapDataAction`, `AdbLogcatService`, `HeatmapInlayManager` | [stability/visualizing-recomposition-cascades](stability/visualizing-recomposition-cascades/SKILL.md) |
| `Settings → Tools → Compose Stability Analyzer` configurable: `isStabilityCheckEnabled`, `isStrongSkippingEnabled`, `showGutterIcons`, `showInlineHints`, `showOnlyUnstableHints`, RGB color overrides, `stabilityConfigurationPath` | [stability/using-stability-analyzer-ide-plugin](stability/using-stability-analyzer-ide-plugin/SKILL.md) |

## By workflow phase

Compose performance work is a four-phase loop. Run it in order; do not skip ahead.

### Measure

Establish a baseline before changing anything. Numbers from a debug build are not representative — measure in release with R8 on a physical device.

- [measurement/testing-compose-in-release-mode](measurement/testing-compose-in-release-mode/SKILL.md)
- [measurement/generating-baseline-profiles](measurement/generating-baseline-profiles/SKILL.md)

### Diagnose

Turn symptoms into named causes. Compose Compiler reports, recomposition tracing, and stability inference are the diagnostic surface area.

- [stability/diagnosing-compose-stability](stability/diagnosing-compose-stability/SKILL.md)
- [stability/understanding-stability-inference](stability/understanding-stability-inference/SKILL.md)
- [recomposition/debugging-recompositions](recomposition/debugging-recompositions/SKILL.md)
- [measurement/tracing-recompositions-at-runtime](measurement/tracing-recompositions-at-runtime/SKILL.md)
- [stability/using-stability-analyzer-ide-plugin](stability/using-stability-analyzer-ide-plugin/SKILL.md)
- [stability/visualizing-recomposition-cascades](stability/visualizing-recomposition-cascades/SKILL.md)

### Fix

Apply the targeted code or configuration change. Each fix skill is scoped to one cause so the diff stays small.

- [stability/stabilizing-compose-types](stability/stabilizing-compose-types/SKILL.md)
- [recomposition/using-strong-skipping-correctly](recomposition/using-strong-skipping-correctly/SKILL.md)
- [recomposition/deferring-state-reads](recomposition/deferring-state-reads/SKILL.md)
- [recomposition/choosing-derivedstateof](recomposition/choosing-derivedstateof/SKILL.md)
- [recomposition/avoiding-subcomposition-pitfalls](recomposition/avoiding-subcomposition-pitfalls/SKILL.md)
- [lists/optimizing-lazy-layouts](lists/optimizing-lazy-layouts/SKILL.md)
- [lists/configuring-lazy-prefetch](lists/configuring-lazy-prefetch/SKILL.md)
- [modifiers/migrating-to-modifier-node](modifiers/migrating-to-modifier-node/SKILL.md)
- [modifiers/ordering-modifier-chains](modifiers/ordering-modifier-chains/SKILL.md)
- [side-effects/collecting-flows-safely](side-effects/collecting-flows-safely/SKILL.md)
- [side-effects/using-efficient-effects](side-effects/using-efficient-effects/SKILL.md)

### Verify

Confirm the fix landed and lock it in so regressions cannot slip back. Build configuration belongs here because it codifies the invariants the rest of the loop relies on.

- [build/configuring-r8-for-compose](build/configuring-r8-for-compose/SKILL.md)
- [stability/enforcing-stability-in-ci](stability/enforcing-stability-in-ci/SKILL.md)

### Iterate

A development time loop separate from the production performance loop. Use these skills during active UI work to compress the edit, build, install, navigate, observe cycle into one save.

- [hot-reload/setting-up-compose-hotswan](hot-reload/setting-up-compose-hotswan/SKILL.md)
- [hot-reload/understanding-hot-reload-limits](hot-reload/understanding-hot-reload-limits/SKILL.md)
- [hot-reload/preserving-state-across-reloads](hot-reload/preserving-state-across-reloads/SKILL.md)
- [hot-reload/iterating-with-ai-and-mcp](hot-reload/iterating-with-ai-and-mcp/SKILL.md)

## End-to-end audit

When the symptom is broad ("the app feels sluggish", "scroll is rough everywhere") or the team is starting a performance sprint without a specific lead, enter through the orchestrator skill. It chains Measure → Diagnose → Fix → Verify, delegating to the focused skills above at each step and producing a written audit at the end.

- [audit/auditing-compose-performance](audit/auditing-compose-performance/SKILL.md)
