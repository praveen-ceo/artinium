# ARTINIUM

Smart Home. Futuristic Living. — Flutter prototype, mock-data driven.

## Setup (run this locally — not runnable in the sandbox that generated it)

```bash
cd artinium
flutter pub get
flutter create . --platforms=android   # regenerates the android/ folder if missing
flutter analyze
flutter test
flutter run
```

This project ships **without** the `android/`, `ios/`, `web/`, etc. platform
folders — only `lib/`, `test/`, `pubspec.yaml`, and `assets/`. Run
`flutter create .` inside the project root first (it's safe — it only adds
the platform scaffolding around your existing `lib/`), then `flutter pub get`.

## What's implemented

- Full navigation: Splash → Login → Personalization → Main (Home / Rooms /
  Jarvis / Energy / Profile), Room Hub → Device Control, Profile → Settings.
- Design system: `lib/core/theme` (colors, spacing/radius/duration tokens,
  text styles, dark + light ThemeData).
- One reusable `ArtiniumLogo` widget used on Splash, Login, and anywhere
  else the brand mark appears — no duplicate logos.
- Data-driven rooms (8) and devices (24) via `MockData` → `RoomRepository` /
  `DeviceRepository`. `DeviceRepository` is a `ChangeNotifier`; toggling a
  device or changing fan speed/AC mode/brightness updates every screen
  watching it.
- Device control is capability-driven (`DeviceType` + `attributes` map), not
  one hardcoded class per device — fan/AC/light share `CircularDial` /
  `showTimerSheet` where it makes sense.
- Artinian AI: mock intent parser (`MockAiService`) maps free text to a
  `device_control` / `query_energy` / `run_automation` intent and mutates
  `DeviceRepository` accordingly. Mic button uses `MockVoiceService`
  (2s delay, canned transcript) — swap for a real STT plugin later.
- Energy: mock 7-day snapshot, power-target progress card (Tamil Nadu / 200
  units is a **user-editable demo value**, not a real tariff claim), a
  conservative single-line insight ("your X is your highest consumer").
- Automations (`MockData.automations`): Good Night, Morning, Away Mode,
  Energy Saver, Movie Mode — data-driven, applied via
  `DeviceRepository.applyAutomation`.
- Dark/Light theme toggle (`ThemeController`, Provider), defaults to Dark.
- Reusable empty/loading/offline/error states (`shared/widgets/state_views.dart`).
  Bathroom's exhaust fan is seeded `offline` so you can see it live.
- Service interfaces for everything the spec asks to be swap-ready later:
  `ApiService`, `MqttService`, `AiService`, `VoiceService`, `SensorService`,
  `EnergyService` — each has a `Mock*` implementation and nothing else in
  the app depends on the mock directly.
- Unit tests: fan speed clamping, device toggle, automation apply, energy/
  power-target math, mock login validation, personalization updates.

## Known gaps / next steps

- **No real imagery.** Room cards and headers use gradient + icon
  placeholders (`RoomCard._RoomImagePlaceholder`) instead of photography —
  drop files into `assets/images/` (paths already referenced in
  `MockData.rooms`) and swap the placeholder for `Image.asset`.
- **`ArtiniumLogo` is a `CustomPainter`,** not the exact reference artwork.
  It's built so a real SVG can replace `_MarkPainter` without changing any
  call site — add `assets/icons/artinium_mark.svg` and swap the body of
  `ArtiniumLogo.build`.
- **TV / Curtains / Air Purifier** currently reuse `LightControlView` for a
  basic on/off UI (per spec: "don't duplicate code unnecessarily"). Give
  them dedicated capability sets in `attributes` + a real view if you need
  more than on/off.
- **Not yet built:** onboarding for `flutter create .` platform folders,
  CI, real backend/MQTT/AI wiring (all interfaces are ready — see Services
  above), accessibility pass, golden/widget tests beyond the logic-level
  unit tests included.
- I could not run `flutter analyze` / `flutter test` / `flutter run` in the
  environment that generated this project (no Flutter SDK, no pub.dev
  access) — run those yourself as the first step after `pub get`.
