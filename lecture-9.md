# Lecture 9 — Cloud services

> Draft for `finalised_lectures/lecture-9.pptx`. Slides are minimal; detail lives in Worksheet 9 and in what I say when each slide is shown.

## Overview

### PAPL (M30235) / UXDI (M32605)

Lecture 9:

- Why cloud
- Cloud providers and services
- Firebase and feedback

---

## Why cloud — tech news

Got tech news? Share it on Discord.

Set up job alerts so roles reach you first:

- Save searches on [LinkedIn Jobs](https://www.linkedin.com/jobs), [Gradcracker](https://www.gradcracker.com), [RateMyPlacement](https://www.ratemyplacement.co.uk) and [MyCareer](https://mycareer.port.ac.uk).
- Filter with terms such as `placement`, `industrial year`, `junior` or specific stacks.
- Turn on instant email or RSS alerts and route them to a dedicated inbox folder.

---

## Why cloud — building a job-hunt assistant

Provision simple cloud resources to speed up applications at minimal cost:

- Trigger a SaaS workflow ([Power Automate](https://make.powerautomate.com), [Make](https://www.make.com) or [Zapier](https://zapier.com)) whenever a job alert email arrives.
- Or build a lightweight cloud app using free student tiers (a database to track roles, cloud functions triggered by email/webhooks, and an LLM API).
- Have the agent read the job description against your CV and draft a tailored CV and cover letter.
- Review and edit every draft yourself, then apply while the listing is fresh.

---

## Why cloud — leaving a single device

- Local JSON files and SQLite stay trapped on one phone or browser.
- Cloud services store shared data and user accounts on remote servers.
- Why use cloud here and in other modules or side projects:
  - Live data updates for every user without shipping a new app release.
  - Customers keep their settings and history across phones and browsers.
  - No servers to buy, patch or maintain yourself.

---

## Cloud providers and services — choosing a provider

- [Firebase](https://firebase.google.com/pricing) (Google): best Flutter integration; free Spark plan (no card) covers auth, database and web hosting.
- [Microsoft Azure](https://azure.microsoft.com/free/students): strong for web APIs, `.NET` and AI models; [Azure for Students](https://azure.microsoft.com/free/students) gives \$100 free credit/year with no card.
- [Amazon AWS](https://aws.amazon.com/free): broadest enterprise cloud platform; free tier available (card required).
- [Supabase](https://supabase.com): open-source PostgreSQL backend with a free tier; suits relational SQL apps.

Matching needs to providers: quick Flutter mobile and web goes to Firebase; relational SQL goes to Supabase; Microsoft and AI stacks go to Azure.

---

## Cloud providers and services — service synonyms

Every cloud provider offers the same core services under different names:

| What your app needs | Firebase | Azure | AWS | Supabase |
| --- | --- | --- | --- | --- |
| User sign-in | Authentication | Microsoft Entra | Cognito | Auth |
| Database | Cloud Firestore | Cosmos DB / SQL | DynamoDB / RDS | PostgreSQL |
| Web hosting | Hosting | Static Web Apps | Amplify / S3 | External host |
| File storage | Cloud Storage | Blob Storage | S3 | Storage |
| Serverless code | Cloud Functions | Azure Functions | Lambda | Edge Functions |

---

## Firebase and feedback — building with Firebase

- Add web support alongside Android (`flutter create --platforms=web .`) and link with `flutterfire configure`.
- Authentication gives every signed-in user a unique `uid` (email/password, email link or Google sign-in).
- Cloud Firestore stores shared collections (public catalogue) and private collections per `uid` (settings, history).
- Security rules lock private paths so customers access only their own data.
- Fake Firebase packages (`firebase_auth_mocks`, `fake_cloud_firestore`) run tests offline; `firebase deploy --only hosting` publishes web apps free on Spark.

---

## Demo 5

- Assesses Worksheet 9 cloud services only (Worksheet 10 is not assessed).
- Demonstrate in your own timetabled practical session.
- You can only do one demo in each window.
- More information on the web page: [manighahrmani.github.io/sandwich_shop](https://manighahrmani.github.io/sandwich_shop/)

---

## Module feedback

Give us your feedback, comments, criticisms, or insults by filling out the following form.

- It is anonymous; you need to sign in with your student account, but your details are not recorded.
- Use this link or the QR code: [forms.cloud.microsoft/e/88jd4UGAui](https://forms.cloud.microsoft/e/88jd4UGAui)

---

## Live demo guide (for the lecturer)

Run this live during the lecture using the Sandwich Shop repository starting from branch `8`.

### Setup

1. Open VS Code on branch `8`:

    ```bash
    git checkout 8
    flutter pub get
    flutter test
    ```

2. Sign in to the Firebase dashboard with the `Sandwich Shop` Spark project open.

### Part 1 — Web support and connecting Firebase

1. Run `flutter create --platforms=web .` and delete the generated `test/widget_test.dart`.
2. Update `isSupportedPlatform()` in `lib/main.dart` to allow web alongside Android.
3. Add `firebase_core`, `firebase_auth` and `cloud_firestore`, run `flutterfire configure`, and initialise Firebase in `main()`.

### Part 2 — Live auth, Firestore and testing

1. Run the app in Chrome and sign in with a test account.
2. Update settings and place an order, showing the live updates appear under `users/<uid>` in Firestore.
3. Run `flutter test` with mocked Firebase packages to show fast offline unit and widget tests.
4. Optionally run `flutter build web` and `firebase deploy --only hosting` to show the live `.web.app` URL.

### Wrap-up notes for the lecturer

- Highlight how Firebase concepts translate directly to Azure, AWS and Supabase using the synonyms slide.
- Remind students about Azure for Students free credit and Spark hosting for their other modules and portfolio projects.
