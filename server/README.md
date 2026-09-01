# OOT Server

NestJS backend API for the OOT Flutter application.

## Local setup

1. Install dependencies:

   ```bash
   npm install
   ```

2. Create a local environment file:

   ```bash
   cp .env.example .env
   ```

3. Start the development server:

   ```bash
   npm run start:dev
   ```

The health endpoint is available at `http://localhost:3000/api/v1/health`.
The database readiness endpoint is available at
`http://localhost:3000/api/v1/ready`.
Swagger documentation is available at `http://localhost:3000/docs`.

`/health` reports whether the API process is alive. `/ready` also pings MongoDB
and returns `503 Service Unavailable` when the database cannot be reached.

`MONGODB_DATABASE` defaults to `oot` and is passed to the MongoDB driver
explicitly. This prevents a connection string without a database path from
silently using MongoDB's `test` database.

## Authentication

The first authentication slice supports passwordless phone or email OTP login:

- `POST /api/v1/auth/otp/request`
- `POST /api/v1/auth/otp/verify`
- `POST /api/v1/auth/refresh`
- `POST /api/v1/auth/logout`
- `GET /api/v1/auth/me` (Bearer access token required)

## Profiles

Authenticated onboarding data is saved with:

- `GET /api/v1/profile`
- `PATCH /api/v1/profile`
- `POST /api/v1/profile/complete`

In MongoDB Atlas, open the `oot-dev` project, choose **Database → Data
Explorer**, open database `oot`, and select the `profiles` collection. Each
document is keyed by `userId`. Authentication records are in `users`,
`otp_challenges`, and `refresh_sessions`.

Example development request:

```bash
curl -X POST http://localhost:3000/api/v1/auth/otp/request \
  -H 'Content-Type: application/json' \
  -d '{"channel":"email","identifier":"developer@example.com"}'
```

In development only, the OTP is printed to the server console by the placeholder
delivery adapter. Production refuses to use that adapter; connect an SMS/email
provider before deploying. OTPs and refresh tokens are stored as keyed hashes,
OTP attempts and resend frequency are limited, and refresh tokens rotate on use.

## Verification

```bash
npm run lint
npm test
npm run test:e2e
npm run build
```
