# Security Policy

## Overview

This repository contains the frontend client application built with Flutter for our dating platform. Because this application processes highly sensitive user data—including real-time geolocation, private messaging history, authentication tokens, and profile media—maintaining a hardened security posture is our highest priority.

This document outlines our security updates, vulnerability reporting process, and baseline client-side security standards.

---

## Supported Versions

We actively support and patch security vulnerabilities for the following deployment channels:

| Version | Supported          | Encryption Standards |
| ------- | ------------------ | -------------------- |
| 1.x.x   | :white_check_mark: | TLS 1.3 / AES-256    |
| < 1.0.0 | :x:                | Deprecated           |

---

## Reporting a Vulnerability

**Please do not open a public GitHub issue for security vulnerabilities.** If you discover a security vulnerability within this Flutter client or its interaction with our AWS/self-hosted backend, please report it privately through our disclosure pipeline:

1. **Email:** Send a detailed report to `security@yourdomain.com`.
2. **Encryption:** If possible, encrypt your email using our PGP key (fingerprint available at `https://yourdomain.com/security.txt`).
3. **Required Information:**
   - A description of the vulnerability and the potential impact.
   - Step-by-step instructions to reproduce the issue (including sample payloads or Dart code snippets if applicable).
   - The version of the client app and target platform (iOS, Android, Web) where the vulnerability was observed.

### Our Response Timeline

- **Acknowledgement:** Within 48 hours.
- **Triage & Evaluation:** Within 7 days.
- **Fix Target:** Critical vulnerabilities will be patched and pushed to the App Store / Play Store within 14 days of confirmation.

---

## Client Architecture Security Standards

Any developer contributing to the `lib/` directory must adhere to the following architectural security rules:

### 1. Data Storage & Local Caching

- **Sensitive Data:** Never store JWT tokens, API secrets, or user credentials in plain text via standard `shared_preferences` or file streams.
- **Implementation:** Always utilize encrypted storage implementations (such as the `flutter_secure_storage` package) which interact natively with iOS Keychain and Android Keystore hardware backends.
- **Chat Caching:** If historical chat payloads are cached locally inside `features/chat/data/`, the underlying SQLite/Hive database files must be fully encrypted at rest using an execution key derived securely at runtime.

### 2. Network & Transport Layer Security

- **Protocol Enforcement:** All outgoing communication via HTTP (`core/network/api_client.dart`) and WebSockets (`core/network/socket_client.dart`) must explicitly enforce HTTPS and WSS protocols. Plaintext HTTP transport configurations are strictly banned in production manifests.
- **SSL Pinning:** To prevent Man-In-The-Middle (MITM) proxy attacks, the production networking client must implement SSL Certificate Pinning against our designated AWS/Server certificate fingerprints.
- **Interceptors:** The `interceptors.dart` layer must automatically wipe expired JWT authentication states from memory upon receiving an upstream `401 Unauthorized` response packet from the backend.

### 3. Source Code Hardening (Reverse Engineering)

To protect our proprietary matchmaking algorithms, feature structures, and backend API routes from static decompilation tools, all production releases must apply code obfuscation.

Always compile production artifacts using the native Dart obfuscation flags:

```bash
flutter build apk --obfuscate --split-debug-info=/<directory>
flutter build ipa --obfuscate --split-debug-info=/<directory>
```
