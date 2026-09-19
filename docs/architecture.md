# Izz.App architecture audit

## Repository audit

### What existed before implementation
- The repository contained only `pubspec.yaml` and an empty `README.md`.
- The manifest indicates a Flutter application with Riverpod, GoRouter, Supabase, media packages, and i18n-related dependencies.
- No `lib/` application code, no tests, no database migrations, no environment template, and no platform scaffold were present.

### Key implications
- There was no runnable application entrypoint.
- There was no verified backend or schema implementation to preserve.
- The correct approach was to create a production-oriented foundation from scratch while keeping the implementation intentionally narrow and extensible.

## Implemented in this changeset

### Application foundation
- Flutter app entrypoint and app shell
- Riverpod state layer with role-aware auth/session state
- GoRouter-based navigation
- Arabic-first UI with locale switching between Arabic (`ar`) and English (`en`)
- Real RTL/LTR handling through locale-aware `Directionality`
- Responsive shell for mobile/tablet/desktop

### Domain vertical slice implemented
- Users and roles: follower, owner, sponsor, organizer, admin
- Owner profiles
- Camel profiles linked to owners
- Championship hierarchy:
  - championship
  - competition
  - category
  - round
  - participant
  - result
- Official approval workflow:
  - draft/pending results
  - organizer/admin approval
  - audit log entry generation
  - official winner-card generation with public verification code
- Sponsor profiles and sponsor links to championships
- Specialized content feed with domain-linked posts/videos metadata
- Likes, comments, replies, saves, follows, notifications, and reports using real in-app state transitions
- Search across owners, camels, championships, competitions, sponsors, and winner cards

### Database foundation
- A production-oriented relational schema was added at:
  - `supabase/migrations/20260919_000001_foundation.sql`
- The schema models the requested entities with foreign keys, uniqueness constraints, indexes, status fields, and room for future Supabase RLS/policies.

### Tests
- Focused controller tests were added for:
  - owner creation
  - camel creation
  - official result approval and winner-card generation
  - social interaction toggles and notifications

## Deliberately not implemented yet

The repository had no working backend, storage, or media infrastructure. To keep the change production-oriented instead of fake/demo-only, the following were **not** wired to external services yet:

- Real Supabase authentication and session persistence
- Real Postgres reads/writes
- Supabase Storage or CDN-backed media uploads
- Real push notifications
- Full moderation queue workflows and anti-spam heuristics
- QR code generation (verification route exists; QR can be layered later)
- Video streaming/autoplay engine tied to actual uploaded media
- Platform-specific mobile/web runner scaffolding

These capabilities are represented by clear abstractions and documented environment placeholders rather than fake client-side secrets or misleading buttons.

## Architectural decisions

### Why an in-app repository/state layer first
Because no backend implementation existed in the checkout, the app now uses a seeded Riverpod controller as a vertical-slice runtime. This allows real end-to-end behavior inside the app:
- sign-in
- role-based access
- CRUD-like owner/camel flows
- approval workflow
- winner-card verification
- interactions and notifications

The state layer is intentionally shaped so it can be replaced by Supabase repositories without changing the UI structure.

### Why the vertical slice is limited
The requested scope is much larger than a single-session implementation. Instead of adding shape-only pages, the app now implements one real operational slice:

`owner -> camel -> championship/competition/round -> pending result -> official approval -> winner card -> public verification`

This is supplemented by a working feed, search, follow, save, comment, notification, and reporting baseline.

## Recommended next steps

1. Connect auth/session flows to Supabase Auth.
2. Implement repository interfaces backed by Postgres + RLS.
3. Add media upload services for camel/profile/winner-card assets.
4. Add QR generation for winner-card verification.
5. Add pagination/query cursors for content and notifications.
6. Add full admin CRUD pages for all entities using server validation.
7. Add e2e tests once the Flutter toolchain/platform scaffold is available in CI.
