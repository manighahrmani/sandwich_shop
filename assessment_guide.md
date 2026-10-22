# Term 1 Assessment Guide

## How Item 1 is assessed: a portfolio

Your module has two assessments. The Southsea Cinema Flutter Coursework is
Item 1, and it is worth 50% of the overall module mark. The other 50% (Item 2)
is assessed separately and is not covered by this guide.

Item 1 is not a single submission. It is a portfolio in which you build the
Southsea Cinema app in five stages across the teaching block by completing the
exercises at the end of each weekly worksheet. Every two worksheets prepare you
for one demo (for example, Worksheets 1 and 2 prepare you for Demo 1). You
demonstrate each stage to a member of staff during your timetabled practical
session.

There are two things you must do.

1. Submit the link to your public GitHub repository on Moodle. You submit the
   repository link once, when instructed. You do not upload a zip file or
   source code, and you must keep the repository public (test it in a private
   or incognito browser window; you should not get a 404).
2. Attend your timetabled practical sessions and demonstrate your work. Marks
   are awarded only at the demo. If you do not attend, you get no marks for
   that demo unless you have an approved ECF (see below).

The demos take place in your timetabled practical sessions.

⚠️ You cannot attend a different session: your demo will only be recorded if
you attend the session you are timetabled in.

## The five demos and how they are counted

The app is built in five demos. However, only your best four demo marks count
towards Item 1.

Each demo is worth 25% of Item 1, which is 12.5% of the overall module. The
fifth demo is effectively a safety net: it means you can miss one, or score
poorly in one, without harming your mark.

At each demo you run your app and a member of staff assesses three things. The
percentages below are shares of Item 1:

- Functionality is worth 9%: you run your app and show that it implements the
  features expected for this stage from the worksheet exercises.
- Code quality is worth 8%: a member of staff inspects your code, looking at
  naming, formatting, structure, and separation of concerns. From Demo 4
  onwards, a significant portion of these marks is awarded for project
  structure and automated test coverage. Your `test/` folder must strictly
  mirror the organisation of folders in `lib/` (such as `test/models/`,
  `test/screens/`, `test/widgets/`, `test/repositories/`, `test/database/`),
  and you must generate coverage with `flutter test --coverage` and demonstrate
  it live using the Flutter Coverage extension in VS Code. Leaving test files
  unorganised in the root of `test/` or having inadequate test coverage will
  result in a substantial loss of marks.
- Understanding is worth 8%: you answer two questions about your own code and
  the decisions behind it.

For Demos 1 to 3, if any required functionality item scores zero, your final
demo mark is capped at 23 out of 25. A lower mark remains unchanged; this is
not an additional deduction for each missing feature. At Demo 3, one
understanding question comes from Worksheet 5 and one from Worksheet 6,
excluding advanced exercises.

Demo 3 covers Worksheets 5 and 6: themed navigation, the ticket basket,
profile forms, a JSON film catalogue and saved profile preferences.
Database-backed checkout and SQLite booking history are introduced in
Worksheet 7 for Demo 4. Provider and notifiers are not assessment requirements.

## Demo windows and missing a demo

Assessment takes place across five two-week demo windows (Weeks 1 and 2, Weeks
3 and 4, Weeks 5 and 6, Weeks 7 and 8, and Weeks 9 and 10). Three rules apply:

- You can perform at most one demo in any demo window.
- Demos must be completed in order. You cannot skip ahead to a later demo if you
  have missed an earlier one, because each stage builds on the previous codebase.
- Missing one demo window carries no mark penalty because only your best four demo
  marks count. Missing two or more windows reduces the number of demos you can
  complete.

## Extenuating Circumstances (ECF)

The University's Extenuating Circumstances procedure supports you if
circumstances beyond your control affect your study for more than one to two
weeks (for example physical or mental illness, accommodation issues, family
issues, or equipment breakdown). Follow the guidance and apply online at
<https://myport.port.ac.uk/my-course/exams/extenuating-circumstances#apply>.
You must submit supporting evidence with your claim.

An ECF applies to the whole of Item 1, the entire Flutter Coursework worth 50%
of the module. You cannot submit an ECF for a single demo.

⚠️ Once your ECF is approved, you must email me (<mani.ghahremani@port.ac.uk>).

Please still attend your timetabled practical sessions and complete as many
demos as possible during term time.

When completing an ECF, use the correct module code and item number (Item 1) as
given in the coursework brief.

## Retrieval of failure

The retrieval of failure period for Term 1 takes place in the week beginning
Monday 22 February 2027 (22/02/2027 to 26/02/2027). If your total mark across
all demos before the Christmas break is under 40%, you must arrange a meeting
with me during this period.

You do not need to start a new coursework: you continue and finish the same
Southsea Cinema coursework. If you have already completed some demos, you will
demonstrate the remaining demos during this meeting; if you have not completed
any demos, you demonstrate all of them (or as many as you can).

## Referral and deferral

Your mark during the retrieval period in February depends on whether you have an
approved ECF:

- If you have an approved ECF (deferral), your mark in February is uncapped.
- If you do not have an approved ECF (referral), your overall mark for Item 1 is
  capped at 40%.
