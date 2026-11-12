# Worksheet 9 — Web and cloud services

<!-- DRAFT: outline only. Replace the TODO comments with prose, code and screenshots, then check them against branch 9. -->

## Table of contents

- [Getting help](#getting-help)
- [Getting started](#getting-started)
  - [Continue from Worksheet 8](#continue-from-worksheet-8)
- [Web services](#web-services)
  - [Requests and responses](#requests-and-responses)
  - [Choose an API](#choose-an-api)
  - [Fetch the data](#fetch-the-data)
  - [Show loading and errors](#show-loading-and-errors)
- [Cloud services](#cloud-services)
  - [Choose a service](#choose-a-service)
  - [Connect the app](#connect-the-app)
  - [Store and read data](#store-and-read-data)
- [Testing web code](#testing-web-code)
  - [Fake the network](#fake-the-network)
  - [Keep coverage high](#keep-coverage-high)
- [Exercises](#exercises)

## Getting help

To get support with this worksheet, follow the [Discord guide](https://portdotacdotuk-my.sharepoint.com/:p:/g/personal/mani_ghahremani_port_ac_uk/IQCMJP6IiR_bQoYUMdXJSRDYAWnajEALZYEXFZyrJkHS1QU) and post your questions there. You can also attend your timetabled practical sessions and ask a member of teaching staff for guidance.

## Getting started

### Continue from Worksheet 8

Continue with your Sandwich Shop app from [Worksheet 8](worksheet-8.md). Your tests should pass, and your coverage should sit close to 100% after the work in [Test coverage](worksheet-8.md#test-coverage). If you need the starting code, clone the [Sandwich Shop repository](https://github.com/manighahrmani/sandwich_shop) and switch to branch `8`.

<!-- TODO: add the clone and switch commands, as in Worksheet 8. -->

## Web services

So far the menu comes from a JSON asset bundled with the app, (see [Worksheet 6](worksheet-6.md)). In this worksheet the app asks a web service for its data instead, and then a cloud service for somewhere to keep it.

### Requests and responses

<!-- TODO: explain HTTP requests and responses, status codes, and why a web service returns JSON. Link to the JSON explanation in Worksheet 6 rather than repeating it. -->

### Choose an API

<!-- TODO: decide which service the Sandwich Shop uses (a small hosted JSON endpoint for the menu, or a public API) and which service the Southsea Cinema films use. Explain how to read its documentation. -->

### Fetch the data

<!-- TODO: add the http package, write a repository method that fetches and decodes the menu, and reuse Sandwich.fromJson from Worksheet 6. Keep the code in the explicit style of earlier worksheets (no arrow syntax). -->

### Show loading and errors

<!-- TODO: reuse the loading, error and empty states from Worksheet 6 and Worksheet 7. Cover what happens when the network is unavailable. -->

## Cloud services

A cloud service is a web service that someone else runs and scales for you, such as a hosted database or sign-in system. Your app talks to it with the same kind of requests as before, usually through a package that wraps them.

### Choose a service

<!-- TODO: decide the cloud service for the coursework (for example Firebase authentication and a cloud database) and explain the free tier and how to create a project. Keep it small enough for one worksheet. -->

### Connect the app

<!-- TODO: add the packages, configure the Android app, keep secrets out of the repository and explain what is safe to commit. -->

### Store and read data

<!-- TODO: save an order to the cloud and read it back, keeping the local SQLite history from Worksheet 7 as the fallback. Reuse the loading and error states from earlier. -->

## Testing web code

### Fake the network

<!-- TODO: test the repository with MockClient from package:http/testing.dart so that tests never use the real network. Cover a successful response, an error status and invalid JSON. -->

### Keep coverage high

<!-- TODO: run flutter test --coverage and check the new repository code and the new error states, using the steps from Test coverage in Worksheet 8. -->

## Exercises

The exercises below apply these concepts to your Southsea Cinema coursework and prepare you for Demo 5. For the full coursework specification and grading criteria, see the [Southsea Cinema coursework brief](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/IQDtIJB3bM7gQ4p03eLUngyyAd7JuhjhHuNA1l0H-qCy3Jw).

<!-- TODO: write numbered exercises. Suggested outline:
1. Fetch the cinema films from a web service instead of the JSON asset.
2. Show loading, error and empty states for the request.
3. Add the cloud service to the cinema app.
4. Test the repository with a fake client, including failures.
5. Keep coverage high with the Flutter Coverage extension.
-->
