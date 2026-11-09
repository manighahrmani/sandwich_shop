# Worksheet 8 — AI-assisted development with Copilot

## Table of contents

- [Getting help](#getting-help)
- [Getting started](#getting-started)
  - [Continue from Worksheet 7](#continue-from-worksheet-7)
  - [Set up Copilot](#set-up-copilot)
  - [Connect Dart tools with MCP](#connect-dart-tools-with-mcp)
- [Working with an AI assistant](#working-with-an-ai-assistant)
  - [Understand the task and write your prompt](#understand-the-task-and-write-your-prompt)
  - [Plan before making changes](#plan-before-making-changes)
  - [Make a small change and test it](#make-a-small-change-and-test-it)
  - [Review and explain the result](#review-and-explain-the-result)
  - [Review changes, discard if needed, question anything unclear and commit when satisfied](#review-changes-discard-if-needed-question-anything-unclear-and-commit-when-satisfied)
- [Debugging with evidence](#debugging-with-evidence)
  - [Introduce a defect to investigate](#introduce-a-defect-to-investigate)
  - [Start a debugging session and set breakpoints](#start-a-debugging-session-and-set-breakpoints)
  - [Step through execution and inspect state](#step-through-execution-and-inspect-state)
  - [Diagnose layout issues with the Flutter Inspector](#diagnose-layout-issues-with-the-flutter-inspector)
  - [Use visual debugging aids and the property editor](#use-visual-debugging-aids-and-the-property-editor)
  - [Fix the defect and verify with hot reload](#fix-the-defect-and-verify-with-hot-reload)
- [Giving Copilot context and updating the README](#giving-copilot-context-and-updating-the-readme)
  - [Attach files and plan the document](#attach-files-and-plan-the-document)
  - [Check the generated instructions and diff](#check-the-generated-instructions-and-diff)
- [Storing order items in a related table](#storing-order-items-in-a-related-table)
  - [Understand the relationship](#understand-the-relationship)
  - [Plan an upgrade that keeps existing orders](#plan-an-upgrade-that-keeps-existing-orders)
  - [Implement the changes in small steps](#implement-the-changes-in-small-steps)
  - [Verify with tests and the emulator](#verify-with-tests-and-the-emulator)
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

### Connect Dart tools with MCP

Model Context Protocol (MCP) lets Copilot call development tools. The [Dart and Flutter MCP server](https://github.com/dart-lang/ai/tree/main/pkgs/dart_mcp_server) appears in VS Code as **Dart SDK MCP Server**. It can help Copilot look up code and inspect a running Flutter app; it does not replace your own review or tests.

Click **Open Customizations** (the puzzle icon) in the Chat panel, select **MCP Servers** and search for `dart`. Enable **Dart SDK MCP Server** using its toggle, as shown below. If it is already enabled, leave it enabled rather than adding a second copy.

![The Customizations view showing Dart SDK MCP Server enabled under MCP Servers after searching for dart](images/8/dart_mcp_server.png)

If the server is missing, check that you have Dart 3.9 or later and version 3.114 or later of the Dart extension. The [Dart extension setting](https://dartcode.org/docs/settings/#dartmcpserver) `dart.mcpServer` should be enabled.

Review any trust request before approving it. Use the server's menu to start it or view its output if needed; the [VS Code server controls](https://code.visualstudio.com/docs/agents/run/manage-mcp-servers) explain these actions.

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

Copilot may ask you for permission to run commands as shown below. Use the **Explain** button to understand why it needs to run the command before granting permission. Select **Allow Once** to approve the command for that single execution; avoid selecting **Allow all** so that you remain in control of what executes in your environment.

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

## Debugging with evidence

As you know already, your application will not run if it has errors and warnings will show up with `dart analyze` or in the IDE's problems panel, providing immediate feedback on potential issues in your code.

However if your app runs but produces unexpected behaviour, such as incorrect calculations or layout issues, you will need to employ debugging techniques to identify and resolve the underlying problems.

In this section, we will deliberately introduce an issue (bug) into the app and demonstrate how to use debugging tools to identify and resolve it. As you will see, running the app under a debugger lets you pause execution, inspect runtime state, step through control flow and explore layout constraints directly.

Flutter's [debugging guide](https://docs.flutter.dev/testing/debugging), [VS Code running and debugging guide](https://docs.flutter.dev/tools/vs-code#running-and-debugging) and [Flutter DevTools documentation](https://docs.flutter.dev/tools/devtools) describe these capabilities in detail. Feel free to visit these resources at your own time.

### Introduce a defect to investigate

Suppose we want to show a live subtotal on the order screen before adding an item to the basket. Open `lib/screens/order_screen.dart`, locate the `build` method in `_OrderScreenState`, and add this subtotal row directly above the `PrimaryButton`:

```dart
Row(
  children: [
    Text(
      'Current order subtotal for ${widget.sandwich.name}:',
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    const SizedBox(width: 8),
    Text(
      '£$widget.sandwich.price * _quantity',
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ],
),
const SizedBox(height: 12),
```

Save the file and run the app. On the emulator, you will notice two problems immediately: the subtotal prints raw text instead of calculating the price, and the row overflows the right edge of the screen with yellow-and-black hazard stripes, as shown below.

![The order screen displaying raw widget text and a RenderFlex overflow on the emulator](images/8/debug_layout_overflow.png)

This happens because Dart's `$` interpolates only the identifier directly after it unless enclosed in curly braces `${...}`, treating `.sandwich.price * _quantity` as literal text. Because the resulting string is so long and the `Row` does not constrain its children, the text exceeds the screen width. We will now diagnose both issues using the debugger and Flutter DevTools.

### Start a debugging session and set breakpoints

Make sure your Android emulator is selected in the bottom-right corner of the VS Code status bar, or open the Command Palette with **Ctrl + Shift + P** on Windows or **⌘ + Shift + P** on macOS and run **Flutter: Select Device**.

Start debugging by pressing **F5** or selecting **Run > Start Debugging**. Alternatively click on the **Debug** button on top of the `main` function in `lib/main.dart` as shown below:

![Click the Debug button on top of the main function in lib/main.dart to start debugging](images/8/debug_start.png)

The status bar turns orange and the debug toolbar appears as shown below:

![The VS Code status bar turns orange and the debug toolbar appears when starting a debugging session](images/8/debug_toolbar.png)

A breakpoint pauses execution at a specific line so you can inspect variables before that line runs. In `lib/screens/order_screen.dart`, click the gutter margin next to the line number of the subtotal `Row` inside `build()` to set a breakpoint. See below:

![Setting a breakpoint in the gutter margin next to the subtotal Row in order_screen.dart](images/8/debug_set_breakpoint.png)

In the emulator, tap any sandwich from the menu. Execution halts at your breakpoint, as shown below.

![VS Code paused at the breakpoint in order_screen.dart](images/8/debug_breakpoint_paused.png)

### Step through execution and inspect state

The floating debug toolbar lets you control execution: **Continue** that has a play icon resumes execution.
You also see **Step Over** that looks like a curved arrow pointing down and to the right advances to the next line. **Step Into** that looks like an arrow pointing down enters a called method. **Step Out** that looks like an arrow pointing up exits the current method. The last button is **Hot Restart** which restarts the app.

In the **Run and Debug** view on the left, open the **VARIABLES** panel and expand `this` to inspect `_quantity` and `widget.sandwich.price` as shown below:

![Inspecting variables in the VARIABLES panel](images/8/debug_variables.png)

In the **WATCH** panel, click **+** and add `widget.toString()` and `widget.sandwich.price * _quantity` to compare the raw widget string with the intended calculation. See below:

![Watch expressions showing widget.toString() and widget.sandwich.price * _quantity](images/8/debug_watch.png)

You can also evaluate expressions in the `Debug Console` (**Ctrl + Shift + Y** on Windows or **⌘ + Shift + Y** on macOS). Type `widget.sandwich.price * _quantity` at the `>` prompt and press **Enter** to see the result, as shown below.

![Inspecting variables, watch expressions and evaluated expressions](images/8/debug_variables_watch.png)

### Diagnose layout issues with the Flutter Inspector

Press **Continue** to let the screen finish rendering. Notice the hazard stripes and the error in the `Debug Console` reporting that a `RenderFlex` overflowed by 176 pixels.

In Command Palette type in **Flutter DevTools: Inspector: Focus on View** to to open the Flutter DevTools. Alternatively you can click on its icon on the sidebar or by clicking on the DevTools button in the debug toolbar (the blue icon with a magnifying glass) as shown below:

![Flutter DevTools icon in the sidebar](images/8/debug_devtools_icon.png)

Click **Select Widget Mode** (the crosshair icon) in DevTools and tap the overflowing text on the emulator. The inspector selects the `Text` and its parent `Row` in the widget tree.

![DevTools showing the selected Text widget and its parent Row](images/8/debug_selected_widget.png)

Open the **Layout Explorer** tab as shown below.

![Flutter DevTools Layout Explorer highlighting the RenderFlex overflow](images/8/debug_layout_explorer.png)

Then switch to the Flex Explorer tab to get a detailed view of the flex layout and the constraints applied to each child. It visualises the flex layout of the `Row`, displays the constraints of its children, and highlights the overflow in red with the exact number of overflowed pixels, as shown below.

![Flutter DevTools Flex Explorer showing the detailed flex layout and constraints](images/8/debug_flex_explorer.png)

This shows why the overflow happens: the children of an unconstrained `Row` try to take all the width they need. Because the text is not wrapped in a flexible container, it cannot shrink or wrap onto multiple lines.

### Use visual debugging aids and the property editor

Flutter includes several visual debugging aids you can toggle from the Command Palette:

Run **Flutter: Toggle Debug Painting** (or click **Show Guidelines** in DevTools) to display render boxes, padding margins and tap boundaries on the screen, as shown below.

![The emulator displaying visual debug painting guidelines and bounds](images/8/debug_painting_guidelines.png)

### Fix the defect and verify with hot reload

Now that we understand both issues, update the subtotal row in `lib/screens/order_screen.dart` to enclose the calculation in curly braces and wrap the label in an `Expanded` widget:

```dart
Row(
  children: [
    Expanded(
      child: Text(
        'Current order subtotal for ${widget.sandwich.name}:',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    Text(
      '£${(widget.sandwich.price * _quantity).toStringAsFixed(2)}',
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ],
),
const SizedBox(height: 12),
```

Save the file and click **Hot Reload** in the debug toolbar.

Flutter updates the running app immediately without losing screen state. The hazard stripes disappear, the text wraps neatly within the screen, and the subtotal updates accurately as you tap **Add** and **Remove**, as shown below.

![The resolved order screen displaying the subtotal with correct constraints and calculations](images/8/debug_resolved_fix.png)

Remove your breakpoint by clicking the red dot in the gutter margin before moving on otherwise you have to click on the Continue button every time you add or remove an item from the order.

## Giving Copilot context and updating the README

It's time to update the project documentation of our sandwich shop. A `README.md` file helps another person understand the app, install dependencies, run it and test it.

As an example, check out the README of Flutter itself: [Flutter README](https://github.com/flutter/flutter/blob/main/README.md)

This page gets opened when someone visits the GitHub repository of Flutter: [Flutter GitHub Repository](https://github.com/flutter/flutter)

Similarly, for Sandwich Shop, the current README at the main branch is [Sandwich Shop README](https://github.com/manighahrmani/sandwich_shop/blob/main/README.md) which is essentially the home page for our module's website.

Instead we would like it to document the actual features and usage of our Sandwich Shop app accurately. Rather than asking Copilot to guess the features and behaviour, we will provide it with the relevant files so it can generate precise and context-aware documentation.

### Attach files and plan the document

Only share files needed for the README update, and check that they contain no passwords or personal data before attaching them. Listing a file in `.gitignore` does not prevent you from sharing it with Copilot by the way. (`.gitignore` lists files such as build outputs, temporary cache files, and personal configuration files that Git should ignore and not upload to GitHub.)

Type `#` or click **Add Context** to attach the files relevant to the completed feature: `README.md`, `pubspec.yaml`, `lib/main.dart` and the folder `lib/screens/`, as shown below. The [context guide](https://code.visualstudio.com/docs/chat/copilot-chat-context) explains the available attachment types.

![Copilot Chat with README.md and relevant project files attached as context](images/8/readme_file_context.png)

Write your prompt asking Copilot to inspect the attached files and outline an accurate update for `README.md`. Ask it to focus strictly on the details of the app as implemented in the attached files, without assuming any unimplemented features. You can also ask it to leave placeholders for images as shown in our prompt below:

![Prompt asking Copilot to outline the README with image attachments](images/8/app_features.png)

### Check the generated instructions and diff

Once you approve the outline, ask Copilot to draft the changes to `README.md`. Read every claim carefully against your project:

- Check supported platforms: does it state the app runs on Android, or does it incorrectly claim browser or desktop support?
- Check setup and run commands: do they match the commands you actually ran?
- Check test instructions: does it distinguish emulator-dependent tasks from unit tests?

Try any instruction you have not already verified. Correct inaccuracies yourself or give Copilot specific feedback. Review the diff in **Source Control** to confirm the edits are limited to `README.md`.

You can preview the README by clicking on the **Open Preview** button in the top right corner of the editor, or by pressing **Ctrl + Shift + V** on Windows or **⌘ + Shift + V** on macOS.

![Preview the README to check your updates](images/8/readme_preview.png)

To add images (screenshots) to your README, place them in the `images` folder and reference them using the Markdown syntax `![Alt text](images/filename.png)` (Alt text describes the image for accessibility, in case the image cannot be displayed or the user is using a screen reader). Take a look at ours:

![Example of adding images to the README](images/8/readme_images_example.png)

Once satisfied, commit and push your updated `README.md`. Remember to keep this document updated as you add new features and tests throughout this worksheet's tasks as well as the following worksheets.

## Storing order items in a related table

### Understand the relationship

Worksheet 7 stores an order's items in one summary string. That is easy to display but awkward to query: counting how many of one sandwich were sold would require interpreting text.

Our next task is to store each purchased item separately while keeping it linked to its order. One order can have several items; this is a one-to-many relationship. Consider an example order with two basket lines before asking Copilot to plan it. See the screenshot below with the basket containing two lines (the sandwiches and the nachos):

![Example basket with two lines](images/8/basket_two_lines.png)

Think about how each line would be represented in the new `order_items` table and how it relates to the parent order in `orders`. We can use an `order_items` table whose `order_id` refers to the `id` primary key in `orders`. This is a foreign key. It uses the database row id, not the displayed order number.

The new table can record a sandwich id, its name and unit price at purchase, and its quantity. These are snapshots: changing the current menu must not change a past purchase. Our current app has no bread or size selections, so do not ask Copilot, the AI agent, to invent those fields.

Here is the relationship in SQL, which you should hopefully be familiar with before asking Copilot to implement it:

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

With all this in mind, let's ask Copilot to plan the implementation of the `order_items` table and the necessary changes to save and read related rows in transactions.

### Plan an upgrade that keeps existing orders

You can try **Interactive** or **Autopilot** mode in Copilot later, although we don't recommend Autopilot at this stage because it may generate changes that are not fully aligned with the existing project structure and conventions.

So in the Chat pannel, switch Copilot to **Plan** mode or type `/plan` in Copilot Chat. Provide Copilot with the necessary context by attaching the relevant files. Since we are planning a database migration that affects multiple files, it is crucial to attach all related files to give Copilot the full context.

Attach the following files in Copilot Chat: `#lib/database/sandwich_db.dart`, `#lib/models/order_record.dart`, `#lib/models/cart_item.dart`, `#lib/screens/basket_screen.dart`, and `#lib/screens/orders_screen.dart`. Close unrelated editor tabs so Copilot focuses only on the relevant files.

Write a specific prompt that defines the requirements and constraints clearly:

- Upgrade the SQLite database from version 1 to 2 (see above discussion on migration strategy)
- Create an `order_items` table with foreign key `order_id` referencing `orders(id)`.
- Enable SQLite foreign keys in `onConfigure` with `PRAGMA foreign_keys = ON`.
- Add an `onUpgrade` migration path that preserves all existing version 1 orders without data loss.
- Wrap checkout saves in a database transaction so an order and its items save together, rolling back if an insert fails.

The more details you specify in your prompt, the better Copilot can generate an accurate and reliable migration plan that aligns with your project requirements and preserves existing data. See below our prompt:

![Our prompt for Copilot to plan the database migration](images/8/copilot_db_plan_prompt.png)

Review the plan Copilot proposes. Make sure it preserves existing order records, uses transactions for multi-row writes, and explains how to test the migration, as shown below.

![Copilot proposing a migration plan for the database with context files attached](images/8/copilot_db_plan_proposal.png)

### Implement the changes in small steps

Approve the plan once happy or switch Copilot to **Agent** mode to execute the plan. Rather than asking Copilot to generate all changes at once, guide it through small, verifiable steps:

Ideally, you should first, ask Copilot to update the model classes to represent individual order items alongside the parent order. Review the generated code to ensure field types and nullability match your schema.

In our case, Copilot updated README. This is good as you want to ensure that the documentation reflects the new database structure and any changes in how orders and order items are represented, which helps maintain clarity for future developers and for testing purposes. However, as shown below, we have asked Copilot to reduce the over-writing and verbosity, keeping the README concise.

![Copilot updating the README to reflect the new database structure](images/8/copilot_readme_update.png)

Have Copilot implement the database, checkout and order history changes from the approved plan, as shown below. Check that existing orders and totals are preserved, failed saves leave the basket intact, and new orders display their saved item details.

![Copilot implementing the database upgrade in small steps](images/8/copilot_db_implementation.png)

Inspect every changed file in **Source Control** before accepting it. If Copilot introduces unfamiliar syntax or unnecessary packages, ask it to explain the code or rephrase your prompt to follow existing project conventions.

### Verify with tests and the emulator

AI-generated code requires validation. Ask Copilot to write automated tests that prove the migration and transactions work as intended:

1. A migration test that creates a file-backed version 1 database containing sample orders, closes it and reopens it through the application's version 2 migration code. Verify that the existing orders remain intact; a fresh in-memory database cannot prove this.
2. A transaction test verifying that saving an order with multiple items inserts rows into both `orders` and `order_items`.
3. A rollback test proving that if an item insert fails, the parent order is not saved.

Run your test suite in the terminal to verify the implementation:

```bash
flutter test
```

Once tests pass, launch the app on your emulator without clearing app storage. Place a new order with multiple items, open past orders to verify that both your older purchases and the new itemised order are displayed, and inspect the database, as shown below.

![The emulator displaying preserved past orders alongside newly itemised purchases](images/8/db_migration_orders_verified.png)

## Auditing tests and checking coverage

<!-- TODO: Done till here -->

### Check what the assertions prove

Tests can pass without checking the behaviour that matters. A test that finds a settings title does not prove the larger font size setting is saved. A history test that finds a seeded order does not prove checkout saved a new one.

Ask Copilot to review the assertions for one changed feature before requesting more tests. Compare each assertion with the requirement yourself. Check success, empty and error paths where they apply.

In a disposable change, break one important line and run its focused test. It should fail for the missing behaviour. Restore the line immediately and confirm the test passes again. This checks the assertion's usefulness, not just whether the line ran.

### Inspect test coverage

Coverage reports which source lines executed during tests. It does not tell you whether the assertions were strong. A project can have 100% line coverage and still have bugs.

Generate the report with:

```bash
flutter test --coverage
```

Flutter writes `coverage/lcov.info`. We have added the [Flutter Coverage extension](https://marketplace.visualstudio.com/items?itemName=Flutterando.flutter-coverage) to the workspace recommendations in `.vscode/extensions.json`. When prompted by VS Code, click **Install**, or open the Extensions view (**Ctrl + Shift + X** on Windows or **⌘ + Shift + X** on macOS), filter by `@recommended` and install it.

Once installed, open the **Testing** view in the sidebar to inspect the coverage tree. It reports coverage by folder and file, as shown below.

<!-- Capture: The Flutter Coverage extension showing coverage by folder and file in the Testing view. -->
![The Flutter Coverage extension showing coverage by folder and file in the Testing view](images/8/flutter_coverage_tree.png)

Its documented defaults look for `lcov.info` inside `coverage`. If the tree is empty, check `flutter-coverage.coverageFilePaths` and `flutter-coverage.coverageFileNames` against those values and follow the extension's instructions.

Inspect an uncovered model, repository, database helper or screen with Copilot. Decide which missing behaviour deserves a test before generating one. Give priority to methods, navigation, save/load paths and error handling, not trivial tests written only to increase a percentage.

After adding focused tests, regenerate the report once and compare it. Explain a gap you addressed and what its assertion now proves. Keep the test folder organisation from Worksheet 7.

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

1. Use test-driven development to add a saved dark mode setting across your cinema app using `ThemeMode` and `SharedPreferencesAsync`. Keep your existing profile settings and squared buttons intact (`shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)`), and verify that the theme persists across app restarts.

2. Practise using the debugging tools in your Southsea Cinema project. Set breakpoints to step through a user action, such as booking a ticket or updating settings, and inspect runtime variables. Open the Flutter Widget Inspector to explore the widget tree and examine layout constraints. During your Demo 4 assessment, the marker will ask an understanding question where they introduce an intentional defect or layout error into your app and ask you to inspect, diagnose and resolve it live using the debugger and Flutter Widget Inspector.

3. Update your cinema `README.md` with Copilot, following [Giving Copilot context and updating the README](#giving-copilot-context-and-updating-the-readme). Attach your cinema project files as context and verify every generated instruction against your actual codebase. Document the supported platform, prerequisites, how to run the app and how to execute the tests. You must showcase all the main features of your app with screenshots captured from your running app, each accompanied by a short explanation and descriptive alt text. Include browsing films, selecting tickets, managing the basket, completing a booking, viewing booking history, and using profile and settings features. Store the screenshots in your repository and embed them in the README using relative paths, then check that they display correctly in the preview. Keep the text and screenshots updated as you complete each exercise.

4. Give bookings related item rows in your SQLite database, mirroring [Storing order items in a related table](#storing-order-items-in-a-related-table). Create a `booking_items` table linked to `bookings` through a foreign key. Write an `onUpgrade` database migration that preserves all existing bookings, and use transactions to ensure no partial booking is saved if an item insert fails.

5. Generate test coverage for your Southsea Cinema app with `flutter test --coverage` and inspect the results in the Flutter Coverage extension, following [Auditing tests and checking coverage](#auditing-tests-and-checking-coverage). Identify uncovered branches in your models, repositories, database helpers and screens. Add meaningful tests that prove critical behaviour rather than trivial assertions to inflate percentages.

6. (Advanced) Add the `integration_test` package to your cinema app and ask Copilot to develop an end-to-end test for booking a cinema ticket, following [End-to-end integration testing with AI](#end-to-end-integration-testing-with-ai). Run the test on your emulator and verify that the booking reaches history and the basket is cleared.
