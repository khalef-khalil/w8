# w8

**w8** (pronounced “weight”) is a mobile weight-tracking app for people with a clear goal—e.g. *gain 15 kg in 6 months*—who weigh themselves regularly (e.g. daily on a home scale) and want a simple, goal-oriented view of their progress.

---

## What Problem Does w8 Solve?

### 1. **Daily weight is noisy**

Weight fluctuates day to day (water, food, sleep, etc.). Looking only at raw daily values makes it hard to see the real trend.

**w8’s approach:**  
- Store every weigh-in (date + time).  
- Use **weekly medians** (and optional smoothing) to reduce noise.  
- Progress, charts, and insights are based on these smoothed series, not raw daily numbers.

### 2. **“Am I on track?” is unclear**

It’s not obvious whether you’re gaining/losing at the right pace to hit your goal by the target date.

**w8’s approach:**  
- You set a **goal** (initial weight, target weight, start date, duration, type: gain / lose / maintain).  
- The app computes a **required rate** (e.g. kg per week).  
- It compares your **actual rate** (from recent data) to the required one and shows **On track** / **Ahead** / **Behind**, plus **days ahead or behind** when you have enough data.

### 3. **Typos and outliers distort everything**

A wrong entry (e.g. 95 instead of 75 kg) can wreck trends and projections.

**w8’s approach:**  
- **Smart validation** when adding or editing:  
  - Basic range checks (e.g. 0–300 kg or 0–660 lbs).  
  - Implausible jumps (e.g. >5 kg in a day) are rejected.  
  - Suspicious jumps (e.g. >2 kg in a day) trigger a confirmation.  
  - Warnings if you’re moving in the **opposite direction** of your goal (e.g. losing while gaining).  
  - Optional checks vs. recent trend (e.g. outliers vs. last few entries).  
- You can **edit** or **delete** any weigh-in; fixes apply immediately across the app.

### 4. **Units and locale**

People use kg or lbs and prefer different languages and calendar habits (e.g. week starts on Monday vs Sunday).

**w8’s approach:**  
- **Units:** kg or lbs everywhere (display and input). Stored internally in kg.  
- **i18n:** English (default) and French; language chosen in onboarding and changeable in Settings.  
- **Week start:** Configurable (Monday through Sunday) for weekly medians and charts.

### 5. **Scattered or overwhelming UX**

Either progress is buried, or the app dumps too much at once.

**w8’s approach:**  
- **Focused screens:** Home (overview), Progress (goal + chart), Insights (rates + prediction), History (list), Settings.  
- **Quick actions:** Add weigh-in from Home (or FAB on Progress/Insights); History from Home app bar.  
- **Onboarding** sets language, goal, preferences, and first entry so you can start tracking immediately.

---

## Goals of the App

- **Goal-centric:** Everything revolves around a single, user-defined goal (gain / lose / maintain over a set period).  
- **Robust to noise:** Use medians and smoothing so that normal daily variation doesn’t hide real progress.  
- **Honest about progress:** Clear “on track / ahead / behind” and, when possible, “X days ahead/behind” or “goal reached around date X.”  
- **Safe data entry:** Validation and confirmations to avoid typos and outliers.  
- **Accessible:** Support kg/lbs, multiple languages, and configurable week start.  
- **Simple to use:** Add weigh-ins quickly, review history, edit/delete when needed, and adjust settings without restarting.

---

## Features (Detailed)

### Onboarding

First-time users go through a short flow before reaching the main app.

1. **Welcome**  
   - Short intro to w8 and main features (weekly median, smart tracking, clear progress).  
   - “Get Started” → language selection.

2. **Language**  
   - Choose **English** or **Français**.  
   - Default: English.  
   - Stored and used app-wide; can be changed later in Settings.

3. **Goal configuration**  
   - **Goal type:** Gain / Lose / Maintain.  
   - **Initial weight** and **Target weight** (2 decimals, kg or lbs depending on preferences set next).  
   - **Goal start date** and **Duration** (months).  
   - Summary and validation (e.g. target vs initial consistent with goal type, realistic change per month).

4. **Preferences**  
   - **Weight unit:** kg or lbs.  
   - **Week starts on:** Any weekday (Monday–Sunday).  
   - Used for weekly medians, charts, and calendar-style logic.

5. **First weigh-in**  
   - Enter the first weight (and optionally date/time).  
   - Can default to configured initial weight.  
   - Validation (including “very different from initial” warning).  
   - On save, onboarding is marked complete and the user is taken to the main app.

If onboarding isn’t completed, the app redirects to `/onboarding` until the flow is finished.

---

### Home

- **Overview card**  
  - Current weight (from latest weekly median or last entry).  
  - Progress bar and % toward goal.  
  - “X kg/lbs gained (or lost) / target” and start vs goal.  
  - All weights in the user’s chosen unit.

- **Actions**  
  - **Add** (app bar): go to Add Weight.  
  - **History** (app bar): go to full History screen.  
  - Pull-to-refresh to reload data.

- **Empty state**  
  - If no weigh-ins yet, a prompt to add the first one.

---

### Progress

- **Goal vs actual**  
  - Side-by-side current weight and goal weight.  
  - Progress bar and percentage.

- **On-track banner** (when there are ≥2 weigh-ins)  
  - **On track:** actual rate within ~90–110% of required rate.  
  - **Ahead:** above that range.  
  - **Behind:** below.  
  - Color-coded (e.g. green / orange) for quick reading.  
  - Not shown with only one entry to avoid “7 days behind” right after the first weigh-in.

- **Stats row**  
  - **Progress %**  
  - **Weight to go / weight to lose** (remaining to target, in kg or lbs)  
  - **Weeks left** (from goal duration and elapsed time)

- **Weekly evolution chart**  
  - Line chart of **weekly medians** over time.  
  - Optional horizontal reference lines for **initial** and **target** weight.  
  - Tooltips on touch (date + value in selected unit).  
  - Y-axis scale adapts to data and references; last N weeks shown to keep it readable.  
  - Respects “week starts on” and weight unit.

- **FAB**  
  - Add weigh-in.

---

### Insights

- **Status**  
  - Same On track / Ahead / Behind logic as Progress.  
  - **X days ahead** or **X days behind** when available (only with enough data).

- **Speed of progress**  
  - **Current rate** vs **required rate** (e.g. kg/week or lbs/week).  
  - Progress bar showing % of required rate.  
  - Units follow Settings.

- **Prediction**  
  - If the app can extrapolate from current rate: **estimated date** to reach the goal.  
  - Optional note like “X days before/after expected” if it differs from the goal end date.

- **Progress vs time**  
  - Compares **time elapsed** (e.g. 30% of duration) vs **weight progress** (e.g. 35% toward target).  
  - “Ahead by X%” / “Behind by X%” / “Perfectly in sync” when relevant.

- **Empty state**  
  - “Not enough data” (and similar) when there are fewer than two weigh-ins.

---

### History

- **List**  
  - All weigh-ins, most recent first.  
  - Each row: date (Today / Yesterday / weekday + date), time, weight in selected unit.  
  - Pull-to-refresh.

- **Actions per entry**  
  - **Edit:** opens Add Weight in edit mode with that entry pre-filled.  
  - **Delete:** confirmation dialog → remove from storage → refresh list and show a short success message.

- **Add**  
  - Button to add a new weigh-in (navigates to Add Weight).  
  - Empty state when there are no entries.

---

### Add / Edit Weight

- **Form**  
  - Weight (2 decimals), date, time.  
  - Label and suffix reflect unit (kg or lbs).  
  - Validation rules depend on unit (e.g. 0–300 kg, 0–660 lbs).

- **Edit mode**  
  - Opened from History when editing an entry.  
  - Form pre-filled; saving updates that entry (same or new date/time).  
  - Back returns to History.

- **Add mode**  
  - Default date/time = now.  
  - After save, navigates back to Home (or previous context).  
  - Success snackbar.

- **Validation**  
  - Same smart checks as above (range, implausible jumps, goal consistency, optional trend checks).  
  - Errors block save; warnings can require confirmation.  
  - Edit validation excludes the **current** entry when checking for duplicates or outliers.

---

### Settings

- **Language**  
  - Same options as onboarding (e.g. English, French).  
  - Change applies immediately across the app (no restart).

- **Weight unit**  
  - kg or lbs.  
  - All relevant UI (Home, Progress, Insights, History, Add/Edit) uses the new unit immediately after refresh.

- **Week starts on**  
  - Dropdown: Monday through Sunday.  
  - Affects weekly medians and chart week boundaries.  
  - Applied without restart.

- **Persistence**  
  - Stored via the same goal/preferences backend as onboarding.  
  - Home (and thus Progress, Insights) refreshes when settings change so all screens stay in sync.

---

## Technical Overview

- **Framework:** Flutter (Material 3).  
- **State:** Riverpod (`StateNotifier` / `AsyncValue` for loading/data/error).  
- **Navigation:** `go_router` (declarative routes, redirect for onboarding).  
- **Storage:** Hive (local DB) for:  
  - Weigh-ins (date → `WeightEntry`).  
  - Goal configuration and app preferences (including language, unit, week start).  
- **i18n:** `flutter_localizations` + `intl`; ARB files for English and French; generated `AppLocalizations`.  
- **Charts:** `fl_chart` for the weekly evolution line chart.  
- **Architecture:** Feature-based structure (e.g. `home`, `progress`, `insights`, `history`, `add_weight`, `onboarding`, `settings`) with view models and shared `core` (routing, services, models, utils).

---

## Getting Started

### Requirements

- Flutter SDK (e.g. 3.x).  
- A device or emulator (e.g. Android).

### Run

```bash
cd /path/to/w8
flutter pub get
flutter run
```

To run on a specific device (e.g. Samsung):

```bash
flutter devices
flutter run -d <device_id>
```

### Build

```bash
flutter build apk        # Android
flutter build ios        # iOS (macOS/Xcode)
```

---

## Summary

**w8** helps you track weight toward a clear goal (gain, lose, or maintain) by:

- Using **weekly medians** (and smoothing) to cut through daily noise.  
- Showing **goal-centric progress** (on track / ahead / behind, rates, and optional goal-date prediction).  
- **Validating** entries to reduce typos and outliers, and allowing **edit/delete** when needed.  
- Supporting **kg/lbs**, **multiple languages**, and **configurable week start**, with settings that apply **without restart**.

The app is built for people who weigh themselves regularly and want a simple, honest view of whether they’re on pace to hit their target.
