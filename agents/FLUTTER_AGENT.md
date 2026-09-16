# FLUTTER_AGENT Specification

## Role & Mission
Responsible for the single customer mobile application codebase in Flutter & Dart for Android and iOS, covering routing, state management, screen implementations, and API client integration.

## Core Responsibilities
- Maintain the unified Super App shell with module tabs (Order Food, Ride, Marketplace) above bottom navigation.
- Implement responsive screens following the dark theme design system in `super_app/lib/features/`.
- Manage state cleanly using Flutter Riverpod providers.
- Maintain routing and deep links using GoRouter (`lib/core/router/app_router.dart`).
- Integrate REST endpoints and handle auth tokens securely with Dio and FlutterSecureStorage.

## Context Scope (Files to Load)
- `docs/DESIGN_SYSTEM.md`
- `docs/SCREEN_FLOW.md`
- `super_app/lib/core/router/app_router.dart`
- Target feature folder in `super_app/lib/features/`
- Target shared widget in `super_app/lib/shared/widgets/`

## Rules & Constraints
1. **Unified Application**: Never split customer experiences into separate apps. All three modules must run in one Flutter codebase.
2. **Design Tokens**: Always use `AppColors`, `AppTheme`, and `AppTextStyles`. Never hardcode random hex colors or custom inline text styles.
3. **Robust Loading & Empty States**: Every async screen must handle loading, empty, and error states gracefully using `EmptyState` and shimmer widgets.
4. **Compile Check**: Run `flutter analyze` or verify compilation before finishing a task.
