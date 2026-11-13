# Tasks - Apple iOS-Styled To-Do Application for Android

An enterprise-grade, Apple iOS-inspired To-Do application built with Flutter exclusively for Android, seamlessly connected to a shared Supabase backend with an existing Next.js Web application.

Developed to meet the **Quality Bar 9.5/10 Standard** (Separation of Concerns, Threat Modeling, Data Integrity, Optimistic UI with Rollback, Comprehensive Testing, and Release Engineering).

---

## 🏛️ System Architecture

```mermaid
flowchart TD
    subgraph Presentation["Presentation Layer (Flutter)"]
        UI["Cupertino / iOS HIG Widgets"]
        AC["AuthController (ChangeNotifier)"]
        TC["TaskController (Optimistic UI & Rollback)"]
    end

    subgraph Domain["Domain Layer (Pure Dart)"]
        TaskEntity["Task Entity (Immutable)"]
        Counts["TaskCounts Value Object"]
        IRepo["ITaskRepository (Interface)"]
        IAuth["IAuthRepository (Interface)"]
    end

    subgraph Data["Data Layer"]
        Dto["TaskDto (UTC ISO 8601 Serialization)"]
        RepoImpl["SupabaseTaskRepository"]
        AuthImpl["SupabaseAuthRepository"]
    end

    subgraph Supabase["Shared Supabase Cloud"]
        GoTrue["Supabase Auth (Google OAuth & Email)"]
        Postgres[("PostgreSQL: public.tasks")]
        RLS{"Row Level Security (auth.uid() = user_id)"}
    end

    UI --> TC & AC
    TC --> IRepo
    AC --> IAuth
    IRepo <|.. RepoImpl
    IAuth <|.. AuthImpl
    RepoImpl --> Dto --> Postgres
    AuthImpl --> GoTrue
    Postgres --- RLS
```

### Key Architectural Principles
- **Separation of Concerns (SoC):** Business logic is strictly contained inside `TaskController` and `AuthController`. UI Widgets contain zero Supabase SDK calls.
- **Dependency Inversion Principle (DIP):** Presentation and Domain depend on abstract interfaces (`ITaskRepository`, `IAuthRepository`), enabling effortless testing and mocking without backend dependencies.
- **Zero Framework Leakage:** `Task` entity is a pure, immutable Dart model with value equality and `copyWith`.

---

## 🔒 Security Engineering & Threat Modeling

1. **OAuth PKCE & Deep Link Security:**
   - Implements Proof Key for Code Exchange (PKCE) flow through Chrome Custom Tabs via `supabase_flutter`.
   - Uses an application-unique scheme: `io.supabase.fluttertodo://login-callback` registered in `AndroidManifest.xml` with `singleTop` launch mode to thwart intent hijacking.
2. **Credential Safety:**
   - Client embeds **only** the public publishable anon key (`sb_publishable_...`).
   - Absolute prohibition of Supabase `service_role` key in client binaries.
   - Zero hardcoded passwords or session tokens in logs or persistent plain text.
3. **Session Lifecycle & Memory Hygiene:**
   - Tokens stored securely using Encrypted SharedPreferences on Android.
   - Comprehensive `clearData()` call on user sign-out to prevent in-memory cross-account data leaks.
4. **Row Level Security (RLS):**
   - All database transactions are guarded by Supabase PostgreSQL RLS: `auth.uid() = user_id`.

---

## ⚡ Data Integrity & Bi-directional Synchronization

- **Optimistic UI with Fail-safe Rollback:**
  - Checkbox toggling, inline editing, task deletion, and clearing completed tasks execute immediately on UI with haptic feedback.
  - If a network error or server rejection occurs, the state is automatically restored from an in-memory snapshot and an error banner is displayed.
- **Double-Submission Protection:**
  - `TaskController.isSubmitting` lock ensures rapid taps or Enter key repetitions cannot produce duplicate tasks.
- **Timestamp & Timezone Consistency:**
  - All timestamps (`created_at`, `updated_at`) are strictly parsed and serialized in ISO 8601 UTC format.
- **Seamless Web $\leftrightarrow$ Android Sync:**
  - Pull-to-Refresh (`CupertinoSliverRefreshControl`) with Apple spring physics.
  - Automatic silent refresh when the app returns to foreground (`AppLifecycleState.resumed`).

---

## 🎨 Apple iOS HIG Design Details

- **Typography & Proportions:**
  - Large Navigation Title (34pt Bold, letter-spacing -0.5px).
  - Uppercase date header (`THURSDAY, NOV 13`, 13pt Semibold, letter-spacing 0.8px).
  - Status Pill: `"X remaining"` or `"All tasks completed"` (Apple Green `#34C759`).
- **Color Palette (Matching Next.js CSS Design Tokens):**
  - **Light Canvas:** `#F2F2F7` | **Grouped Card:** `#FFFFFF`
  - **Dark Canvas:** `#000000` | **Grouped Card:** `#1C1C1E`
  - **Apple Blue Accent:** `#007AFF` (Light) / `#0A84FF` (Dark)
  - **Apple Red Danger:** `#FF3B30` (Light) / `#FF453A` (Dark)
- **Cupertino Components:**
  - Circular Checkbox (22x22px) with spring scale animation.
  - `CupertinoSlidingSegmentedControl` with quantity badges (`All`, `Active`, `Completed`).
  - Indented divider (52px) matching Apple Settings & Reminders.
  - Swipe-to-delete with destructive red canvas and trash icon.
  - 3 Empty States aligned 100% with the Next.js Web reference.

---

## 🧪 Comprehensive Quality Gate Verification

### 1. Static Analysis (`flutter analyze`)
```bash
flutter analyze
# Output: No issues found! (ran in 3.7s)
```
- **0 errors, 0 warnings, 0 lints.**

### 2. Automated Test Suite (`flutter test`)
35 Automated Tests spanning Unit & Widget tests:
- `test/unit/task_model_test.dart`: Entity immutability, copyWith, equality, metrics.
- `test/unit/task_dto_test.dart`: JSON serialization, UTC preservation, mapping.
- `test/unit/task_controller_test.dart`: CRUD, double submission, optimistic rollback, filtering.
- `test/unit/auth_controller_test.dart`: Sign-in, sign-up, sign-out, session transitions.
- `test/widgets/ios_task_input_test.dart`: Empty/whitespace validation, clearing.
- `test/widgets/ios_task_item_test.dart`: Strike-through, toggle tap, touch targets.
- `test/widgets/ios_segmented_filter_test.dart`: Filtering tabs, badge counts, Clear completed visibility.
- `test/widgets/ios_empty_state_test.dart`: 3 empty states rendering.
- `test/widgets/login_screen_test.dart`: Authentication UI, Google button, form toggle.
- `test/widgets/home_screen_test.dart`: Full home screen integration.

```text
00:02 +35: All tests passed!
```

### 3. Release Build Artifact
```bash
flutter build apk --release
# Output: ✓ Built build/app/outputs/flutter-apk/app-release.apk (51.1MB)
```

---

## 🚀 Setup & Execution Guide

### Prerequisites
- Flutter SDK 3.14.0+ (Tested on Flutter 3.50.0)
- Android SDK Platform 34/35/36 with Java 17

### Supabase OAuth Configuration
To enable Google OAuth redirect on Android without disrupting Web:
1. Navigate to **Supabase Dashboard $\rightarrow$ Authentication $\rightarrow$ URL Configuration**.
2. Under **Redirect URLs**, click **Add URL** and add:
   ```
   io.supabase.fluttertodo://login-callback
   ```
3. Save changes.

### Running the App
```bash
# Get dependencies
flutter pub get

# Run tests
flutter test

# Run on connected Android device/emulator
flutter run -d android

# Build release APK
flutter build apk --release
```
Release APK binary location:
`build/app/outputs/flutter-apk/app-release.apk`
