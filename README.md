# QR Attendance App (Student)

Flutter application skeleton for QR-based student attendance tracking. The project follows the specification provided, covering authentication, QR scanning, attendance history, and profile management.

## Project Structure

```
lib/
├── main.dart
├── models/
│   ├── attendance_model.dart
│   └── user_model.dart
├── providers/
│   ├── attendance_provider.dart
│   └── auth_provider.dart
├── screens/
│   ├── attendance_history_screen.dart
│   ├── home_screen.dart
│   ├── login_screen.dart
│   └── profile_screen.dart
├── services/
│   ├── api_service.dart
│   └── auth_service.dart
├── utils/
│   └── constants.dart
└── widgets/
    ├── attendance_card.dart
    └── custom_button.dart
```

## Getting Started

1. Install Flutter SDK (3.19 or newer recommended).
2. Run `flutter pub get` to install dependencies.
3. Add platform-specific setup for `mobile_scanner` (camera permissions on Android/iOS).
4. Configure the backend API base URL in `lib/utils/constants.dart`.
5. Run the app with `flutter run`.

## Backend Integration Checklist

- [ ] Replace placeholder `ApiConstants.baseUrl` with the actual server URL.
- [ ] Wire up a real HTTP client with authorization headers in `ApiService`.
- [ ] Implement `/login`, `/attendance`, `/attendance/history`, and `/user/profile` endpoints in the backend.
- [ ] Map real response payloads to `User` and `AttendanceRecord` models.
- [ ] Handle token refresh and expiry logic in `AuthService`.
- [ ] Extend error messaging and offline handling in providers.

## Testing Recommendations

- Create unit tests for providers using mocked `ApiService` and `AuthService`.
- Add widget tests for each screen to verify layout and state transitions.
- Perform manual testing on physical devices to validate camera integration and permission flows.

## Future Enhancements

- Push notifications for low attendance.
- Offline-first caching for QR scans.
- Multi-language UI support (e.g. English/Georgian).
