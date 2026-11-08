# Worksheet 8 — AI-assisted development with Copilot

## Table of contents

- [Getting help](#getting-help)
- [Getting started](#getting-started)
  - [Continue from Worksheet 7](#continue-from-worksheet-7)
  - [Set up Copilot](#set-up-copilot)
- [Working with an AI assistant](#working-with-an-ai-assistant)
  - [Understand the task and write your prompt](#understand-the-task-and-write-your-prompt)
  - [Plan before making changes](#plan-before-making-changes)
  - [Make a small change and test it](#make-a-small-change-and-test-it)
  - [Review and explain the result](#review-and-explain-the-result)
  - [Review changes, discard if needed, question anything unclear and commit when satisfied](#review-changes-discard-if-needed-question-anything-unclear-and-commit-when-satisfied)
- [Giving Copilot context](#giving-copilot-context)
  - [Attach files and errors](#attach-files-and-errors)
  - [Use documentation and screenshots](#use-documentation-and-screenshots)
- [Choosing agents, commands and tools](#choosing-agents-commands-and-tools)
  - [Choose how to work](#choose-how-to-work)
  - [Run commands and inspect their output](#run-commands-and-inspect-their-output)
  - [Manage permissions](#manage-permissions)
  - [Understand usage and costs](#understand-usage-and-costs)
- [Using AI safely](#using-ai-safely)
  - [Protect private information](#protect-private-information)
  - [Preserve existing behaviour and data](#preserve-existing-behaviour-and-data)
- [Writing a README with Copilot](#writing-a-readme-with-copilot)
  - [Explore and plan the document](#explore-and-plan-the-document)
  - [Check the generated instructions](#check-the-generated-instructions)
- [Saving a reusable workflow](#saving-a-reusable-workflow)
  - [Add project instructions](#add-project-instructions)
  - [Use an agent skill](#use-an-agent-skill)
  - [Distinguish skills from prompt files](#distinguish-skills-from-prompt-files)
- [Connecting tools with MCP](#connecting-tools-with-mcp)
  - [Connect the Dart and Flutter tools](#connect-the-dart-and-flutter-tools)
  - [Use GitHub tools when needed](#use-github-tools-when-needed)
- [Adding dark mode test first](#adding-dark-mode-test-first)
  - [Understand test-driven development](#understand-test-driven-development)
  - [Plan the saved theme setting](#plan-the-saved-theme-setting)
  - [Write and run a failing test](#write-and-run-a-failing-test)
  - [Implement and review the feature](#implement-and-review-the-feature)
- [Debugging with evidence](#debugging-with-evidence)
  - [Pause and inspect a value](#pause-and-inspect-a-value)
  - [Investigate a missing saved setting](#investigate-a-missing-saved-setting)
  - [Investigate a failed checkout](#investigate-a-failed-checkout)
- [Storing order items in a related table](#storing-order-items-in-a-related-table)
  - [Understand the relationship](#understand-the-relationship)
  - [Plan an upgrade that keeps existing orders](#plan-an-upgrade-that-keeps-existing-orders)
  - [Save related rows together](#save-related-rows-together)
  - [Implement in small steps](#implement-in-small-steps)
- [Auditing tests and checking coverage](#auditing-tests-and-checking-coverage)
  - [Check what the assertions prove](#check-what-the-assertions-prove)
  - [Inspect test coverage](#inspect-test-coverage)
- [End-to-end integration testing with AI](#end-to-end-integration-testing-with-ai)
  - [Set up the integration test package](#set-up-the-integration-test-package)
  - [Plan and test a complete journey](#plan-and-test-a-complete-journey)
  - [Run the test on the emulator](#run-the-test-on-the-emulator)
- [Exercises](#exercises)

## Getting help

To get support with this worksheet, follow the [Discord guide](https://portdotacdotuk-my.sharepoint.com/:p:/g/personal/mani_ghahremani_port_ac_uk/IQCMJP6IiR_bQoYUMdXJSRDYAWnajEALZYEXFZyrJkHS1QU) and post your questions there. You can also attend your timetabled practical sessions and ask a member of teaching staff for guidance.

## Getting started

### Continue from Worksheet 7

Continue with your Sandwich Shop app from Worksheet 7. You should already be able to save an order, see past orders and keep them after closing and reopening the app. Use your Android emulator for the running app.

If you need the starting code, clone the [Sandwich Shop repository](https://github.com/manighahrmani/sandwich_shop) and switch to branch `7`:

```bash
git clone https://github.com/manighahrmani/sandwich_shop.git
cd sandwich_shop
git switch 7
```

Do not switch branches if you are continuing your own work. Run `flutter test` once before making changes. If it fails, investigate those failures first so that you can distinguish them from problems introduced later.

### Set up Copilot

This worksheet uses GitHub Copilot in VS Code. You do not need a separate Claude or Codex subscription, an API key or a paid upgrade. Follow [GitHub's student setup guide](https://docs.github.com/en/copilot/how-tos/copilot-on-github/set-up-copilot/enable-copilot/set-up-for-students) to activate your free student access. Education verification and Copilot activation are separate steps.

If your account still offers only paid options after verification, do not buy a plan. Follow the troubleshooting advice on that page and ask for help in your practical. Copilot Free is also available, but has a smaller allowance and limited features.

Open your project folder and follow the [VS Code Copilot setup guide](https://code.visualstudio.com/docs/setup/copilot) to sign in. In Command Palette, search for **Chat: Focus on Chat View** . Keep the permissions and model to their default settings.

Write a hello world prompt to test Copilot's response as shown below:

![The VS Code Chat view with Copilot, Agent, Auto and Manual permissions selected](images/8/copilot_chat_setup.png)

The current student plan uses **Auto** model selection (or "Copilot Fusion"). Use the choices your account provides rather than trying to select a particular paid model. The [Copilot plans page](https://docs.github.com/en/copilot/get-started/plans) lists the current entitlements. See below the list of the models that I have available to me at the time of writing this worksheet:

![List of available Copilot models](images/8/copilot_models.png)

You can also change settings of the model like effort level as shown below but note that this affects the quota and usage limits of your Copilot plan.

![Changing Copilot model settings](images/8/copilot_model_settings.png)

## Working with an AI assistant

We will use one workflow throughout this worksheet: understand the task, plan, make a small change, test, review and explain.

These are ordinary software engineering habits applied to an AI assistant. For this worksheet, we follow [GitHub's best practices](https://docs.github.com/en/copilot/get-started/best-practices) and the [VS Code workflow guidance](https://code.visualstudio.com/docs/agents/best-practices).

Copilot can read code, suggest changes and run tools, but you always remain responsible for the result. A working app is not enough for your demo: you need to understand the changes and show how you checked them.

### Understand the task and write your prompt

Run the app and look at the text on its screens. We want users to choose a font size in Settings, keep that choice after reopening the app and still use Android's accessibility text size.

Write a prompt describing that outcome and ask for a plan rather than code, as shown below. Use your own words; deciding what a task means is part of your work. GitHub's [prompt guide](https://docs.github.com/en/copilot/concepts/prompting-and-context/prompt-engineering) gives further advice.

<!-- Capture: enter your font-size request in Plan mode, before sending it. -->
![The font size request in Copilot Chat before planning begins](images/8/copilot_font_size_prompt.png)

### Plan before making changes

Change the agent mode to **Plan** or use `/plan` followed by your request to start Copilot's planning workflow as shown below:

![Starting Copilot planning workflow](images/8/copilot_plan_start.png)

This mode researches the project and proposes an approach before implementation. Read the affected files yourself and check that the plan uses the patterns you already know. You can also ask Copilot to provide you links to relevant documentation, code references or examples that explain the proposed changes.

Check whether the plan solves your task, includes meaningful tests and preserves existing behaviour. Challenge unnecessary packages, complicated code and changes outside the task. Ask for revisions before you approve it. (You should not blindly approve a plan without understanding it.)

The agent may also ask you for clarification or additional information to refine the plan before implementation. You should be able to review the full plan and submit feedback. Use **Approve Plan Only**, where offered, when you want to discuss one step before implementation. Follow the [planning guide](https://code.visualstudio.com/docs/agents/run/planning) for the controls in your version.

In the example below, we've asked Copilot to propose a plan for changing the font size of the application for users who have visual impairments.

Copilot asked us a question as shown below first:

![Copilot asking for clarification before proposing a plan](images/8/copilot_plan_question.png)

Once the questions are answered, Copilot checks the files and proposes the changes along with verification steps for your review. You can follow its thinking as shown below:

![Copilot proposing a plan with verification steps](images/8/copilot_plan_proposal.png)

It should then present you with a plan that you should be able to open and edit:

![The Copilot plan review showing proposed files and verification steps before approval](images/8/copilot_plan_review.png)

You can ask Copilot to change the suggested plan before approving it, as shown below.

![The revised Copilot font size plan with smaller steps and checks added after review feedback](images/8/copilot_plan_revised.png)

### Make a small change and test it

Click on the implement button or switch to **Interactive** and ask it to implement only the first agreed step, including its tests, then stop for review. For our revised plan, this is saving and loading the font-size choice, not completing the whole feature, as shown below.

![Copilot completing only the font size preference step and listing its changed files](images/8/font_size_first_step.png)

Copilot may ask you for permission to run commands as shown below. Use the **Explain** button to understand why it needs to run the command before granting permission.

![Copilot asking for permission to run commands](images/8/copilot_run_command_permission.png)

### Review and explain the result

As changes are being made to your code, view them by clicking on "files changed" in the chat as shown below:

![The "files changed" view in Copilot Chat showing the modified files for the font size preference step](images/8/files_changed_view.png)

Feel free to keep or discard any changes after reviewing them carefully. In our case, Copilot has created an `Enum` for the font size options. If you are not happy with this, you can modify the generated code or ask Copilot to make specific changes before committing. You can also ask it to explain any part of the code that is unclear. In our case, we've asked Copilot to explain the purpose and usage of the generated `Enum` so that we understand how it integrates with the rest of the code.

![Copilot explaining the purpose and usage of the generated `Enum`](images/8/font_size_enum_explanation.png)

Once you are happy with the changes in a particular step, proceed to review each changed file in **Source Control**. Open each changed file in **Source Control**. Read the added and removed lines, including the tests, and ask Copilot to explain anything unfamiliar, as shown below. **Keep** does not commit the changes; see the [review guide](https://code.visualstudio.com/docs/agents/run/review-code-edits).

![The font size preference diff beside Copilot's explanation of the selected code](images/8/font_size_diff_review.png)

Again, remember that if a change is unnecessary or hard to follow, edit it yourself or ask for a specific correction. Review the new diff before continuing, as shown below.

![A review comment and the revised font size code after a requested correction](images/8/font_size_review_correction.png)

### Review changes, discard if needed, question anything unclear and commit when satisfied

Ask Copilot to complete the remaining steps of the agreed plan, one by one, including their tests. Review the changed files as before. If you do not want Copilot to make a particular change, edit it or discard it before committing. In the example shown below, it changed `README.md` and we clicked **Undo** to discard the unwanted changes; we will update `README.md` later in this worksheet.

![Discarding unwanted changes before committing](images/8/discard_changes.png)

If any choice does not make sense, question it and seek clarification before proceeding. You can also ask for an alternative solution or approach before accepting the change. In the example below, we questioned why the `rendering.dart` library was imported.

![Questioning and seeking clarification about an unexpected change](images/8/question_clarification.png)

If you are unhappy with an implementation, ask Copilot to undo or modify the changes before committing. In the example below, instead of an `enum` used with a `ChoiceChip`, we asked for a simpler approach: a toggle switch to increase the font size.

![Undoing or modifying an unwanted implementation before committing](images/8/undo_modify_changes.png)

Remember to run `dart analyze` and `flutter test`. Expand the output to check the results, as shown below.

![Copilot completing the font size feature with analysis and test results](images/8/font_size_final_tests.png)

On the emulator, change the font size, visit each screen and close and reopen the app. Check that the choice is saved, text and controls fit, and your profile and basket still work, as shown below.

![The saved larger font size setting enabled on the Settings screen](images/8/font_size_emulator_check.png)

Once you understand the changes and the checks pass, stage all the files belonging to this feature in **Source Control**. Write your own commit message, then commit and push to your own branch, as shown below.

![The completed font size feature staged for a single commit and push](images/8/font_size_feature_commit.png)

## Giving Copilot context

<!-- TODO: done till here -->

Now extend the feature Copilot has just made with an extra-large font-size choice. Give it the relevant files so it can review and update its latest implementation. The [context guide](https://code.visualstudio.com/docs/chat/copilot-chat-context) explains the available attachments.

### Attach files and errors

Type `#` or use **Add Context** to attach `main.dart`, `settings_screen.dart`, the generated font-size type and their tests. Ask Copilot to review how these files work together and propose where the extra-large choice belongs before editing, as shown below.

<!-- Capture: attach the actual files involved in the font-size change using
Add Context. Ask it to review the latest implementation and plan an extra-large
choice without changing existing choices or Android accessibility scaling. -->
![Copilot Chat with the app, settings and font size test files attached](images/8/font_size_file_context.png)

Review its proposal, then ask it to update the feature and tests. If a test fails, include the command and error text in your feedback, as shown below.

<!-- Capture: approve the focused update, then show the extra-large choice diff
and its test result. Preserve tests for the existing choices and saved values. -->
![Copilot updating the font size choices and tests after reviewing the attached files](images/8/font_size_context_update.png)

### Use documentation and screenshots

Try the extra-large choice on the emulator. If it causes a layout problem, attach a cropped screenshot and ask Copilot to update the affected layout, as shown below. Use invented profile details and remove private information.

![Copilot Chat with relevant Dart files and a cropped emulator screenshot attached as context](images/8/copilot_context_attachments.png)

Ask Copilot to check its scaling approach against Flutter's [TextScaler documentation](https://api.flutter.dev/flutter/painting/TextScaler-class.html). Expand the web result to confirm it read the page, as shown below.

![Copilot retrieving a Flutter API documentation page and showing the result in chat](images/8/copilot_fetch_documentation.png)

Review and test the update, including reopening the app with the extra-large choice saved. Commit and push it separately from the original feature.

## Choosing agents, commands and tools

### Choose how to work

Use **Plan** to discuss the font-size approach and **Agent** to implement an agreed step. Keep the session in your local project so it can use your files and emulator. You do not need cloud or parallel agents for this change; the [agent guide](https://code.visualstudio.com/docs/agents/concepts/agents) explains those options.

### Run commands and inspect their output

For the final font-size checks, ask Copilot to run these commands in your project folder:

```bash
dart format lib test
dart analyze
flutter test
```

Expand the tool calls and check the working directory, command and result. Type `/` to see chat commands, which are different from terminal commands such as `flutter test`. See the [tools guide](https://code.visualstudio.com/docs/agents/run/tools) for the available controls.

### Manage permissions

Keep **Manual permissions**. When Copilot requests permission to run a font-size test, read the command and working directory before selecting **Allow Once**, as shown below. Previously approved actions may run without another prompt.

![A VS Code approval request showing the command and the Allow Once action](images/8/copilot_command_approval.png)

Approving a plan does not approve every tool action. Do not enable **Allow all** or disable university restrictions to bypass a problem. See the [permissions guide](https://code.visualstudio.com/docs/agents/run/approvals) and [security guidance](https://code.visualstudio.com/docs/agents/run/security).

### Understand usage and costs

Keep **Auto** selected and check your account's remaining usage. Student access is not unlimited; keep additional paid usage disabled. If you reach the limit, continue reviewing and testing yourself. The [billing page](https://docs.github.com/en/copilot/concepts/billing-and-usage/individuals/billing) and [usage guide](https://code.visualstudio.com/docs/agents/guides/optimize-usage) describe the current allowances.

## Using AI safely

### Protect private information

Running an agent locally does not mean its model runs locally. Attached code, prompts and tool results can be sent to a hosted service. Follow university rules and consult the [Copilot Trust Center](https://resources.github.com/copilot-trust-center/) for data handling, rather than assuming every account has the same policy.

Do not share passwords, API keys, recovery codes, student records or other people's private code. Use invented data for this app. A gitignored file is not automatically safe from being read by an agent or included in its context.

Documents, web pages and tool results can contain misleading instructions. This is called prompt injection when content tries to make the agent do something outside your request. Treat fetched content as evidence to inspect, not authority to grant permissions or expose secrets.

Check extension and MCP publishers before installation. Review their files, scripts and requested access. Use the [VS Code security guidance](https://code.visualstudio.com/docs/agents/run/security), and follow the module's rules for acknowledging AI assistance.

### Preserve existing behaviour and data

A change should add the agreed behaviour without breaking the rest of the app. This is why the [VS Code planning guide](https://code.visualstudio.com/docs/agents/run/planning) asks you to check compatibility and verification, and its [review guide](https://code.visualstudio.com/docs/agents/run/review-code-edits) asks you to inspect the complete diff.

For dark mode, existing profile settings should still load and save. For a database upgrade, orders saved before the change must still be readable. Include these requirements in your plan and check them, rather than assuming the agent will remember.

Git can restore source code, but not database contents lost by uninstalling the app. Do not accept deleting saved data as a migration strategy. The [sqflite documentation](https://pub.dev/packages/sqflite) describes database upgrades and transactions; we will use them below.

## Writing a README with Copilot

### Explore and plan the document

Now update the documentation to include the completed font-size setting. A `README.md` should help another person understand the app and run it. Ask Copilot to inspect the existing README, `pubspec.yaml`, `main.dart` and relevant tests before suggesting an outline.

Write your own prompt for an accurate README of the current Sandwich Shop app. Limit the proposed edit to the README and decide which setup, run and test instructions a new developer needs.

Read the outline before asking for the draft. It should describe what the app does now, not features planned later in this worksheet.

### Check the generated instructions

Read every claim against the project. Check the package name, supported platform, assets and test paths. A statement that the app works in a browser is wrong for our current setup, even if it sounds plausible for Flutter generally.

Try any setup or run instruction you have not already verified. Do not reinstall dependencies or run every test again merely to repeat a known result. Check that the README explains which commands need an emulator and which do not.

Correct inaccuracies yourself or give Copilot specific feedback. Review the final diff and explain one correction you made before accepting the document.

Compare an app-platform claim with the code that decides which platforms are supported, as shown below.

![The README diff beside the code that checks supported app platforms](images/8/readme_claim_review.png)

## Saving a reusable workflow

### Add project instructions

Project instructions record stable rules that should not be repeated in every prompt. Follow the [custom instructions guide](https://code.visualstudio.com/docs/agent-customization/custom-instructions). Open **Chat: Open Customizations** from the Command Palette and check whether the project already has an instructions file.

If it does, update that file rather than creating a competing copy. Otherwise, `.github/copilot-instructions.md` is a supported project location for Copilot. Describe the rules your project actually uses: beginner-readable Dart, existing dependencies, test commands and where code belongs.

Keep the file short and check that it appears under **Instructions** in a fresh session, as shown below. Then inspect whether the agent follows it on your next task. Instructions guide a model; tests and permission controls enforce checks and boundaries.

![The VS Code Agent Customizations editor showing the project Instructions list](images/8/copilot_project_instructions.png)

### Use an agent skill

A skill is a reusable procedure, loaded when relevant or selected as a slash command. It differs from project instructions because it describes how to perform a particular task. Follow the [skills guide](https://code.visualstudio.com/docs/agent-customization/agent-skills) and use **Chat: Open Customizations**, then **Skills**.

For example, a project skill called `review-change` could tell Copilot to inspect a diff, identify relevant tests and report evidence without editing code. Create it under `.github/skills/review-change/SKILL.md` with this metadata and a procedure you write yourself:

```yaml
---
name: review-change
description: Review a small code change and its test evidence without editing files.
---
```

Below the metadata, write what the skill should check and how it should report an unverified claim. Do not add a command you have not understood. Use `/review-change` on your next small change and inspect the result to confirm that it cites actual code and checks.

You can instead adapt a trusted existing skill. Review the whole skill folder, including scripts, before using it. Flutter publishes [official AI tools and skills](https://docs.flutter.dev/ai/get-started); choose a relevant one rather than installing everything.

After saving the skill, type `/review-change` in a new chat to check that it is available, as shown below.

![The Copilot slash-command menu showing the review-change skill](images/8/copilot_skill_command.png)

Then run the skill on a small change and check that its review refers to the actual diff, as shown below.

![The review-change skill reporting a finding against a small code diff](images/8/copilot_skill_review.png)

### Distinguish skills from prompt files

Prompt files save requests as `.prompt.md` files invoked with slash commands. In the current [prompt-file documentation](https://code.visualstudio.com/docs/agent-customization/prompt-files), these run in **Local** sessions, not the **Copilot** session used here.

Use a skill for this worksheet's reusable workflow. If an older tutorial tells you to create `.github/prompts`, check which session it targets before following it. A custom agent, a skill, a prompt and a terminal command are different things, even when some appear in the same menu.

## Connecting tools with MCP

MCP stands for Model Context Protocol. It connects an assistant to tools and data, such as live analyser results or a repository service. It is not another model, and installing a server does not improve the model's knowledge unless it uses that server's output.

The [VS Code MCP guide](https://code.visualstudio.com/docs/agent-customization/mcp-servers) recommends starting with existing tools. You do not need an external server to run `flutter test` in a terminal.

### Connect the Dart and Flutter tools

The [Dart and Flutter MCP server](https://github.com/dart-lang/ai/tree/main/pkgs/dart_mcp_server) supplies project diagnostics and other development tools. Check its current SDK requirements first. In the terminal, `dart --version` shows your installed version; `dart mcp-server --help` checks whether the command is available without starting a server.

With **Copilot** selected, run **MCP: Add Server** from the Command Palette. Choose **Command (stdio)**, enter `dart mcp-server` and name it `dart`. Select the personal **Copilot Global** destination where offered so this demonstration does not add machine-specific configuration to your repository.

Review the trust prompt before starting it. Ask Copilot to use the Dart MCP tools to report analyser issues in the current project without editing files. Expand the tool call and confirm that it came from that server and returned real diagnostics.

If the SDK or university policy prevents setup, report that limitation and run `dart analyze` instead. Do not bypass restrictions. Some runtime tools require a debug connection and additional setup; a successful diagnostics request does not prove every tool is available.

Check that Copilot called the Dart server and returned diagnostics from the open project, as shown below.

![The Copilot tool call showing Dart MCP diagnostics from the open Flutter project](images/8/dart_mcp_diagnostics.png)

### Use GitHub tools when needed

The [official GitHub MCP server](https://github.com/github/github-mcp-server) can retrieve repository information and perform write actions. Its remote endpoint is `https://api.githubcopilot.com/mcp/`. If it is not already available, use the MCP guided setup with **HTTP** and follow GitHub's sign-in instructions.

Try a read-only request about your repository's recent commits. Inspect the tool output and compare it with the history you see in **Source Control**. Do not paste a token into chat, and do not grant write access just to read history.

This connection is optional: `git log` provides local history without it. Disable unused servers after the demonstration. A server can use your account's permissions, so check its capabilities and available read-only options before approving actions.

## Adding dark mode test first

### Understand test-driven development

In test-driven development, or TDD, you write a test for the desired behaviour before implementing it. Run it and confirm that it fails for the right reason. Then make the smallest change that passes, and improve the code without changing its behaviour.

These stages are often called red, green and refactor. Red means the expected behaviour is missing, not that the test has a broken import. Green means the test passes. Refactoring improves the structure while the tests remain green.

Copilot can help write both tests and implementation, but you must judge the test independently. GitHub lists [generating tests for TDD](https://docs.github.com/en/copilot/get-started/best-practices) as a useful application. An agent that changes an assertion to fit its incorrect implementation has not completed TDD.

### Plan the saved theme setting

Our task is to give the Sandwich Shop a dark mode setting that survives closing the app. Before prompting, compare `main.dart`, `settings_screen.dart` and the existing settings tests. Read Flutter's [ThemeMode API](https://api.flutter.dev/flutter/material/ThemeMode.html) and [MaterialApp themeMode property](https://api.flutter.dev/flutter/material/MaterialApp/themeMode.html).

`ThemeMode` selects the light, dark or system theme. `MaterialApp` receives the light configuration through `theme`, the dark configuration through `darkTheme`, and the choice through `themeMode`. The app must rebuild when that choice changes.

Decide how you will demonstrate the setting: it should change the whole app, work in both directions and load at startup. Keep light mode as the default when nothing is saved. Existing profile values and the basket should remain intact.

Ask Copilot to plan this using `SharedPreferencesAsync` and the state and callbacks you already know. The saved choice must be connected to `MaterialApp`, not just to a switch on the settings page. Challenge a plan that adds a state-management package solely for this change.

### Write and run a failing test

Choose one visible behaviour from your plan and ask Copilot to add a test for it before editing `lib`. For example, a settings test can find the new switch by its label rather than assuming it is the only `Switch`.

Use the in-memory preferences setup from the existing tests. Read the arrange, action and assertions yourself, then run only the new test. Confirm that it fails because the feature is missing.

You may need to update an old assertion that counted one switch, because the new screen has two. Replace the generic finder with one that still checks the newsletter switch. Do not remove the old behaviour's test.

Once the first behaviour passes, repeat this process for saving the choice, loading it into a fresh app and changing the theme throughout navigation. Recreating only the settings page does not prove that startup applies the saved theme.

### Implement and review the feature

Let Copilot implement the first tested behaviour, leaving the agreed assertion unchanged. Review that step before continuing. Add the remaining behaviours in the same test-first order.

Test both enabled and disabled saved values, plus the missing-value default. Reuse the existing preference APIs and report a save or load error rather than hiding it. Check that existing profile tests still pass.

After the focused checks, run analysis and the full test suite once. Try the app on the emulator, switch themes, visit the other screens and fully close and reopen it. Hot reload is not a persistence check.

Use your review skill if it is helpful, but judge its findings yourself. Explain how the stored value reaches `MaterialApp` and why the app rebuilds when it changes.

First confirm that the new test fails because the app does not yet support the expected theme, as shown below.

![The new dark mode test failing before the feature is implemented](images/8/dark_mode_red_test.png)

After implementation, run the unchanged test and review the code that saves and loads the choice, as shown below.

![The dark mode test passing after the implementation, with the reviewed change visible](images/8/dark_mode_green_test.png)

Close and reopen the app to check the saved theme, as shown below.

![The reopened app displaying the saved dark theme with readable text and cards](images/8/dark_mode_after_restart.png)

## Debugging with evidence

Testing tells you that a result is wrong. Debugging helps you find why. The debugger pauses execution so you can inspect actual values instead of asking an agent to guess.

Flutter's [debugging guide](https://docs.flutter.dev/testing/debugging) and the [VS Code debugger guide](https://code.visualstudio.com/docs/debugtest/debugging) describe breakpoints, stepping and variable inspection. Keep your investigation to one symptom at a time.

### Pause and inspect a value

Open `order_screen.dart` and find `_addToBasket`. Click the margin beside its quantity check to set a breakpoint, then start the app through **Run and Debug** on your emulator. Open an order and try **Add to Basket** before increasing the quantity.

When execution pauses, inspect `_quantity` in **VARIABLES**. Use **Step Over** to see which branch executes, then **Continue** to resume the app. Try again after increasing the quantity and compare the result.

You should see why an order with quantity 0 is rejected. This is existing behaviour, not a bug to “fix”. Explain it before asking Copilot for help.

When the breakpoint pauses with `_quantity` set to 0, inspect the rejected path, as shown below.

![The Flutter debugger paused at the quantity check with _quantity set to 0](images/8/debug_quantity_zero.png)

Increase the quantity and repeat the check to compare the accepted path, as shown below.

![The Flutter debugger paused at the quantity check with _quantity set to 1](images/8/debug_quantity_one.png)

### Investigate a missing saved setting

If your new theme resets after reopening, do not request a rewrite of the settings screen. Break at the preference read and inspect the returned value after `await`. Compare the key used to save it with the key used to load it.

If the saved value is correct, follow how it reaches the app's theme. If it is missing, investigate the write path. Attach the relevant code and observed value to Copilot and ask for a diagnosis before a change.

In a disposable copy, use different keys to save and read the setting. Inspect the missing value, find the mismatch and add a test for loading the saved theme, as shown below.

![The debugger showing a missing preference value and the different save and read keys](images/8/debug_preference_key_mismatch.png)

### Investigate a failed checkout

When checkout fails, inspect the exception and the row being inserted before changing the UI. In `basket_screen.dart`, break at the save and in its error handler. Check whether the basket is cleared before or after the awaited save.

In a disposable test copy, an old table missing a required column can cause a real save failure even while in-memory tests pass against the current schema. Use that difference to ask Copilot which environment each test covers.

The correct result on failure is visible feedback with the basket retained. Do not silence the exception or show a success message to make the symptom disappear.

Use a disposable app copy with an old database schema to observe the failed save, error and retained basket, as shown below.

![The emulator showing checkout error feedback while the basket contents remain](images/8/debug_checkout_failure.png)

## Storing order items in a related table

### Understand the relationship

Worksheet 7 stores an order's items in one summary string. That is easy to display but awkward to query: counting how many of one sandwich were sold would require interpreting text.

Our next task is to store each purchased item separately while keeping it linked to its order. One order can have several items; this is a one-to-many relationship. Sketch an example order with two basket lines before asking Copilot to plan it.

We can use an `order_items` table whose `order_id` refers to the `id` primary key in `orders`. This is a foreign key. It uses the database row id, not the displayed order number.

The new table can record a sandwich id, its name and unit price at purchase, and its quantity. These are snapshots: changing the current menu must not change a past purchase. Our current app has no bread or size selections, so do not ask the agent to invent those fields.

Here is the relationship in SQL, which you should read before using it:

```sql
CREATE TABLE order_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  order_id INTEGER NOT NULL REFERENCES orders(id),
  sandwich_id TEXT NOT NULL,
  sandwich_name TEXT NOT NULL,
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  unit_price REAL NOT NULL
);
```

`REFERENCES` links the row to its parent order. `CHECK` rejects a quantity that is not positive. SQLite foreign-key enforcement must also be enabled when opening each connection with `PRAGMA foreign_keys = ON`; follow the [SQLite foreign-key documentation](https://www.sqlite.org/foreignkeys.html).

To read one order's items, use the open connection `db` and store the parent row id in `orderId`. `whereArgs` supplies the value separately rather than joining user input into SQL:

```dart
final List<Map<String, Object?>> rows = await db.query(
  'order_items',
  where: 'order_id = ?',
  whereArgs: <Object?>[orderId],
);
```

### Plan an upgrade that keeps existing orders

The app already has a version 1 database. Editing `onCreate` alone will not update that existing file. A migration changes its structure while preserving its contents.

Read the [sqflite migration example](https://github.com/tekartik/sqflite/blob/master/sqflite/doc/migration_example.md). Plan version 2 with both a fresh-install path and an `onUpgrade` path. Enable foreign keys in `onConfigure`, before creation or upgrade.

Keep existing order numbers, summaries, dates and totals. Old summaries do not reliably contain every new item field, so do not invent detailed rows by guessing from that text. Show the old summary when no detailed items exist; show stored items for new purchases.

Before approving the plan, require a test that opens a version 1 database containing an order, closes it and reopens it through the version 2 upgrade. Use a temporary file for this test: a new in-memory version 2 database cannot prove that an upgrade preserved version 1 data.

A development uninstall would erase the evidence you need. Verify on the existing emulator installation without uninstalling or clearing storage.

Compare the saved order before and after the upgrade, as shown below.

![The existing order record in the version 1 database before migration](images/8/order_before_migration.png)

![The same order preserved after migration, alongside the related order_items table](images/8/order_after_migration.png)

### Save related rows together

A transaction groups related database writes. If an item insert fails, the order and its other items should not be left half saved. The [sqflite transaction guidance](https://pub.dev/packages/sqflite#transaction) explains how an exception causes rollback.

The parent insert returns the id needed for the item rows. Ask Copilot to use the transaction object for every write inside the transaction, not the outer database connection. The latter can cause a deadlock.

The save must finish before the basket is cleared. Keep the existing failure feedback and basket-retention behaviour. Do not catch an item error inside the transaction and continue as though the whole purchase succeeded.

The order total can include delivery, so it need not equal just the item prices multiplied by quantities. Preserve the existing checkout calculation.

### Implement in small steps

Use the same workflow for this larger change. Agree on the model and conversion tests first, then the database upgrade and transaction tests, then the checkout and history screens.

Have Copilot implement one part at a time. Check new installs, upgrades, two items linked to one order, invalid parent ids and rollback when an item cannot be saved. The tests should call the application's actual schema and migration code, not a separately rewritten version.

Update screen tests to verify detailed items for new orders and the summary for older ones. Keep the existing empty state, navigation and failure checks. Finish by making a new purchase and reopening the app; both the older history and new details should remain.

Check that a new order with two items creates two linked rows and that a failed transaction leaves no partial order, as shown below.

![A new order and its two related item rows in the database inspector](images/8/order_with_related_items.png)

## Auditing tests and checking coverage

### Check what the assertions prove

Tests can pass without checking the behaviour that matters. A test that finds a settings title does not prove dark mode is saved. A history test that finds a seeded order does not prove checkout saved a new one.

Ask Copilot to review the assertions for one changed feature before requesting more tests. Compare each assertion with the requirement yourself. Check success, empty and error paths where they apply.

In a disposable change, break one important line and run its focused test. It should fail for the missing behaviour. Restore the line immediately and confirm the test passes again. This checks the assertion's usefulness, not just whether the line ran.

### Inspect test coverage

Coverage reports which source lines executed during tests. It does not tell you whether the assertions were strong. A project can have 100% line coverage and still have bugs.

Generate the report with:

```bash
flutter test --coverage
```

Flutter writes `coverage/lcov.info`. Install the [Flutter Coverage extension](https://marketplace.visualstudio.com/items?itemName=Flutterando.flutter-coverage) used for your demo and open its tree in the **Testing** view. It reports coverage by folder and file.

Its documented defaults look for `lcov.info` inside `coverage`. If the tree is empty, check `flutter-coverage.coverageFilePaths` and `flutter-coverage.coverageFileNames` against those values and follow the extension's instructions. Do not confuse this tree with coloured editor gutters supplied by a different extension.

Inspect an uncovered model, repository, database helper or screen with Copilot. Decide which missing behaviour deserves a test before generating one. Give priority to methods, navigation, save/load paths and error handling, not trivial tests written only to increase a percentage.

After adding focused tests, regenerate the report once and compare it. Explain a gap you addressed and what its assertion now proves. Keep the test folder organisation from Worksheet 7.

The extension's controls can differ by version. Follow the current extension instructions if a label or view is different from the example below.

![The Flutter Coverage extension showing coverage by folder and file in the Testing view](images/8/flutter_coverage_tree.png)

## End-to-end integration testing with AI

An integration test runs a complete journey in the real app on a device. Unlike our in-memory unit and widget tests, it can exercise Android plugins and the emulator's SQLite file. The [Flutter integration testing guide](https://docs.flutter.dev/testing/integration-tests) explains the setup.

### Set up the integration test package

Add `integration_test` from the Flutter SDK under the existing `dev_dependencies` in `pubspec.yaml`. Keep the other dependencies:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
```

Run `flutter pub get` after this dependency change. Put device tests in `integration_test`, separate from `test`. An ordinary `flutter test` run does not run that directory.

`IntegrationTestWidgetsFlutterBinding.ensureInitialized()` prepares the device test runner. You can start with this small check in `integration_test/app_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sandwich_shop/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('the menu opens', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text('Footlong Sub'), findsOneWidget);
  });
}
```

The import's `as app` gives the application code a name so we can call its `main` separately from the test's `main`. `app.main()` starts the real application. If your startup returns a `Future`, await it before checking the screen.

`pumpAndSettle` lets pending frames finish; it does not guarantee that every database or preference operation has completed. Check that the expected screen is ready. It can time out if the app has an animation that never stops; investigate that condition instead of blindly increasing waits.

### Plan and test a complete journey

Our task is to check a purchase from selection to saved history. Perform the journey manually first and decide which observations would prove it worked. Then write your own prompt with the relevant screens, test setup and device id.

Have Copilot plan the test before writing it. Read its finders and assertions. Branch `7` starts the order quantity at 0, so the test must increase it before adding to the basket. A generic **Order** finder can match several buttons; use a stable key or a finder scoped to the intended card.

Check that the test proves a new order was saved with the chosen item and correct total, and that the basket is empty afterwards. Seeded orders must not satisfy its assertions. The emulator retains data between runs, so do not assume that a fixed order number will always be new.

The earlier branch `7` test read the next order number before checkout and then looked for that exact order. This is one useful check, but it should be combined with the expected content and basket state. If your implementation needs a key for reliable selection, review that small source change separately.

Use real taps and scrolling where needed, not direct calls that bypass the UI. When the test fails, distinguish a wrong finder or timing problem from a real application bug. Do not remove assertions or alter the app's behaviour just to get a green result.

### Run the test on the emulator

Start your emulator and get its id with `flutter devices`. Run the selected file, replacing `emulator-5554` if your device has a different id:

```bash
flutter test integration_test/app_test.dart -d emulator-5554
```

Let Copilot run this command after you approve it and watch the journey on the emulator. Inspect the actual result. If it fails, supply the error and the screen where it stopped, then review the proposed correction.

Use a test installation with invented data. Do not let an agent erase the database to make its assumptions pass. Verify persistence separately with a full close and reopen; a navigation test alone does not prove restart persistence.

Keep a few integration tests for important journeys. They are slower than unit and widget tests and are not included in the coverage report from the ordinary `flutter test --coverage` command. Stop the debug run and any test processes when finished.

Run the integration test on the emulator and observe the purchase journey, as shown below.

![The emulator displaying the saved purchase after the integration test completes checkout](images/8/integration_test_checkout.png)

## Exercises

The exercises below apply this workflow to your Southsea Cinema coursework. Together with Worksheet 7, they prepare you for Demo 4. See the [Southsea Cinema coursework brief](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/IQDtIJB3bM7gQ4p03eLUngyyAd7JuhjhHuNA1l0H-qCy3Jw) for the formal requirements.

Use your own prompts and acceptance criteria. For each change, be ready to explain the plan, a decision you reviewed and the evidence that it works. Apply the [review workflow](#review-and-explain-the-result), including writing your own commit messages.

1. Write and verify your cinema README with Copilot, following [Writing a README with Copilot](#writing-a-readme-with-copilot). Correct any claim that does not match your app.

2. Use [TDD](#adding-dark-mode-test-first) to add a saved dark mode setting across your cinema app. Keep your existing profile and squared buttons working.

3. Give bookings related item rows. [Our order upgrade](#storing-order-items-in-a-related-table) shows the approach; your `booking_items` must preserve earlier bookings and leave no partial booking when saving fails.

4. Inspect your [coverage](#inspect-test-coverage) in the editor and address important gaps. Be ready to show what the new assertions prove.

5. Use the [debugger](#debugging-with-evidence) to investigate one behaviour in your app. Show an observed value and explain how it supports your diagnosis.

6. (Advanced) Ask Copilot to develop and run an [integration test](#end-to-end-integration-testing-with-ai) for booking a film. Prove that the new booking reaches history and the basket is cleared.
