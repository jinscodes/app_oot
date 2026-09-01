# OOT

Flutter client and NestJS/MongoDB server for OOT.

## Run locally

Start the server in the first terminal:

```bash
cd server
npm run start
```

Start Flutter in another terminal:

```bash
flutter run
```

The client defaults to `http://localhost:3000/api/v1` on iOS, macOS, and web.
The Android emulator automatically uses `http://10.0.2.2:3000/api/v1`.

For another device or environment, provide the API URL at build time:

```bash
flutter run \
  --dart-define=OOT_API_BASE_URL=https://api.example.com/api/v1
```

## Authentication development flow

Phone authentication uses the real server endpoints. Until an SMS provider is
connected, the six-digit OTP is printed in the server terminal. Access and
refresh tokens are stored with the platform's secure storage. On launch, the
app validates the access token and rotates the refresh token when necessary.

Email verification in profile onboarding remains a local mock. It should not be
connected to the current sign-in endpoint because that would create a separate
email user instead of linking the email to the authenticated phone account.

When the user taps Start Exploring, the client saves the onboarding draft with
`PATCH /api/v1/profile`, then calls `POST /api/v1/profile/complete`. Profile
fields and photo comments are stored in MongoDB. The selected image bytes remain
on the device until an object-storage upload endpoint is added.

## Verification

```bash
flutter analyze
flutter test
```

Server-specific setup and verification are documented in `server/README.md`.
