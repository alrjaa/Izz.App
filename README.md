# Izz.App

Arabic-first Flutter foundation for a specialized camel competition platform.

## Implemented scope

This repository now contains a real vertical slice for:

- sign-in with role-aware demo accounts
- owner profiles
- camel profiles linked to owners
- championship -> competition -> category -> round -> participant -> result
- organizer/admin approval of pending results
- official winner-card generation
- public winner-card verification route
- sponsor profiles linked to championships
- specialized feed with likes, comments, saves, follows, notifications, and reports
- Arabic RTL / English LTR switching

The database foundation is documented in:

- `docs/architecture.md`
- `supabase/migrations/20260919_000001_foundation.sql`

## Local development

### Requirements

- Flutter SDK
- Dart SDK

### Install dependencies

```bash
flutter pub get
```

### Run

```bash
flutter run
```

### Analyze and test

```bash
flutter analyze
flutter test
```

## Environment

Copy `.env.example` to `.env` and fill in only when wiring external services:

```bash
cp .env.example .env
```

Current app behavior does **not** require secrets in the client; the in-app seeded state exists to keep the vertical slice runnable before real backend integration.

## Supabase foundation

The schema migration included here models:

- profiles / roles
- owners
- camels / camel_media / achievements
- championships / competitions / categories / rounds / participants
- results / awards / winner_cards
- sponsors / sponsorships
- posts / comments / likes / saves / follows
- notifications / reports / verification_requests / audit_logs

## Notes

- No platform scaffold existed in the original repository.
- No verified backend implementation existed in the original repository.
- External services such as Supabase Auth, Storage, search, push notifications, QR generation, and CDN-backed video playback still need to be connected.