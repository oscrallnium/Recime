# Recime

A SwiftUI recipe browsing app for iOS 26 that lets users discover, search, and filter recipes by mood, dietary preferences, and serving size.

---

## Setup Instructions

### Requirements

- Xcode 16+
- iOS 26 SDK
- Swift 6

### Running the App

1. Clone or download the repository
2. Open `Recime.xcodeproj` in Xcode
3. Select a simulator or connected device running iOS 26
4. Press **Run** (`Cmd+R`)

No external dependencies or package installations are required. All data is bundled with the app.

---

## Architecture Overview

The app follows **MVVM (Model–View–ViewModel)** with a protocol-based service layer that mirrors real API integration patterns.

```
Recime/
├── Models/
│   ├── Recipe.swift           # Core data model
│   ├── Ingredient.swift       # Ingredient sub-model
│   ├── Instruction.swift      # Step-by-step instruction sub-model
│   ├── Mood.swift             # Mood/category model
│   └── RecipeResponse.swift   # Top-level API response wrapper
│
├── Services/
│   ├── RecipeService.swift    # Protocol + error types
│   └── MockRecipeService.swift # Local JSON implementation
│
├── ViewModels/
│   ├── HomeViewModel.swift        # State + filtering logic for home screen
│   ├── RecipeDetailViewModel.swift
│   └── ServingsFilter.swift       # Enum for servings range filtering
│
├── Views/
│   ├── HomeView.swift             # Main feed screen
│   ├── FeaturedRecipeCard.swift   # Hero card at top of feed
│   ├── RecipeCardView.swift       # List item card
│   ├── MoodPillView.swift         # Mood category row
│   ├── FilterBarView.swift        # Active filter chips
│   ├── SearchBarView.swift        # Search input
│   ├── EmptyStateView.swift       # No results state
│   └── Helpers/
│       ├── RecipeDetailView.swift # Full recipe detail screen
│       ├── IngredientRow.swift
│       ├── MethodStepView.swift
│       ├── DietaryTagView.swift
│       ├── RatingBadge.swift
│       ├── ServingsBadge.swift
│       └── RecipeImage.swift
│
└── Resources/
    └── recipes.json           # Bundled recipe data
```

### Data Flow

```
recipes.json
    └── MockRecipeService (loads + decodes, simulates network delay)
            └── HomeViewModel (holds state, applies filters)
                    └── HomeView (renders UI, drives navigation)
```

---

## Key Design Decisions

### Protocol-based Service Layer
`RecipeService` is defined as a protocol, so `MockRecipeService` can be swapped for a real `URLSession`-backed implementation without changing any ViewModel or View code. The ViewModel receives the service via dependency injection at init time.

### `@Observable` ViewModel
`HomeViewModel` uses Swift's `@Observable` macro (iOS 17+) instead of `ObservableObject`/`@Published`. This means views only re-render for the specific properties they read, reducing unnecessary updates.

### Filtering is a Computed Property
All filtering logic lives in a single `filteredRecipes` computed property on `HomeViewModel`. Filters compose in a clear, sequential pipeline — full-text search → mood → dietary → servings. Adding a new filter means adding one more `filter {}` step with no structural changes elsewhere.

### Full-Text Search Scope
The search query is matched against four fields simultaneously: recipe title, description, ingredient names, and instruction text. This allows users to find recipes by searching for an ingredient ("garlic") or a technique ("blanch") without needing separate search modes.

### `ServingsFilter` as an Enum
Serving size ranges (1–2, 3–4, 5+) are modeled as a `CaseIterable` enum rather than free-form integers. This makes the filter menu self-describing and eliminates the need for range validation logic at the call site.

### Mood as a Tag Array
Each recipe carries a `mood: [String]` array rather than a single enum value. This lets a recipe belong to multiple mood categories (e.g. both "comfort" and "healthy"), which maps cleanly to a contains-based filter.

### Shimmer Loading State
Instead of a spinner, loading placeholders use a shimmer animation that mirrors the actual card layout. This preserves visual layout stability and reduces perceived load time.

### iOS 26 Liquid Glass Navigation
The navigation bar has no custom `toolbarBackground`, intentionally deferring to iOS 26's Liquid Glass system. This gives the nav bar a transparent glass appearance that adapts to the content behind it.

---

## Assumptions and Tradeoffs

| Decision | Rationale |
|---|---|
| Local JSON as data source | Satisfies the "structured like a real API" requirement while keeping setup dependency-free. The service protocol makes a future live API a drop-in replacement. |
| Mood filter hidden during search | Mood browsing and keyword search represent different user intents. Showing both simultaneously would produce confusing compound filters. |
| Filter bar only appears when a filter is active | Keeps the default home screen uncluttered. Filters are surfaced progressively as the user interacts. |
| Featured recipe excluded from filtered list | The hero card is a curated editorial pick and is intentionally not subject to the same filtering as the browsable list below it. |
| No ingredient include/exclude filter UI | The current `searchText` already matches against ingredient names, covering the majority of ingredient-driven searches. A dedicated multi-select include/exclude UI would require a significantly more complex filter sheet and is deferred. |
| `@MainActor` on ViewModel | Ensures all state mutations happen on the main thread, avoiding the need for explicit `DispatchQueue.main` calls in async callbacks. |

---

## Known Limitations

- **Single data source**: All recipes come from `recipes.json`. There is no pagination or lazy loading — all records are decoded into memory on first load.
- **No persistence**: Favorites and user preferences are not saved between sessions. There is no SwiftData or UserDefaults integration yet.
- **Images are local assets**: Recipe images reference asset catalog names. A real implementation would load remote images via URL with a caching layer.
- **No ingredient include/exclude filter**: Ingredient-based filtering is covered by the general text search but lacks a dedicated multi-select UI that would allow "must include / must exclude" queries.
- **Single-language search**: Search matching is case-insensitive but not locale-aware. Accented characters or non-Latin ingredient names may not match as expected.
- **No error recovery UI**: If the JSON fails to decode, an error is stored on the ViewModel but the current UI does not surface a retry action to the user.
