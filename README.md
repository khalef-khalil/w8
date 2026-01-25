# w8

**w8** (pronounced "weight") is a mobile weight-tracking app for people with a clear goal—e.g. *gain 15 kg in 6 months*—who weigh themselves regularly (e.g. daily on a home scale) and want a simple, goal-oriented view of their progress.

---

## What Problem Does w8 Solve?

### 1. **Daily weight is noisy**

Weight fluctuates day to day (water, food, sleep, etc.). Looking only at raw daily values makes it hard to see the real trend.

**w8's approach:**  
- Store every weigh-in (date + time).  
- Use **weekly medians** (and optional smoothing) to reduce noise.  
- Progress, charts, and insights are based on these smoothed series, not raw daily numbers.

### 2. **"Am I on track?" is unclear**

It's not obvious whether you're gaining/losing at the right pace to hit your goal by the target date.

**w8's approach:**  
- You set a **goal** (initial weight, target weight, start date, duration, type: gain / lose / maintain).  
- The app computes a **required rate** (e.g. kg per week).  
- It compares your **actual rate** (from recent data) to the required one and shows **On track** / **Ahead** / **Behind**, plus **days ahead or behind** when you have enough data.

### 3. **Typos and outliers distort everything**

A wrong entry (e.g. 95 instead of 75 kg) can wreck trends and projections.

**w8's approach:**  
- **Smart validation** when adding or editing:  
  - Basic range checks (e.g. 0–300 kg or 0–660 lbs).  
  - Implausible jumps (e.g. >5 kg in a day) are rejected.  
  - Suspicious jumps (e.g. >2 kg in a day) trigger a confirmation.  
  - Warnings if you're moving in the **opposite direction** of your goal (e.g. losing while gaining).  
  - Optional checks vs. recent trend (e.g. outliers vs. last few entries).  
- You can **edit** or **delete** any weigh-in; fixes apply immediately across the app.

### 4. **Units and locale**

People use kg or lbs and prefer different languages and calendar habits (e.g. week starts on Monday vs Sunday).

**w8's approach:**  
- **Units:** kg or lbs everywhere (display and input). Stored internally in kg.  
- **i18n:** English (default) and French; language chosen in onboarding and changeable in Settings.  
- **Week start:** Configurable (Monday through Sunday) for weekly medians and charts.

### 5. **Scattered or overwhelming UX**

Either progress is buried, or the app dumps too much at once.

**w8's approach:**  
- **Focused screens:** Overview (consolidated home/progress/insights), History (list), Settings.  
- **Quick actions:** Add weigh-in from Overview (or FAB on History); History from Overview app bar.  
- **Onboarding** sets language, goal, preferences, and first entry so you can start tracking immediately.

---

## Goals of the App

- **Goal-centric:** Everything revolves around a single, user-defined goal (gain / lose / maintain over a set period).  
- **Robust to noise:** Use medians and smoothing so that normal daily variation doesn't hide real progress.  
- **Honest about progress:** Clear "on track / ahead / behind" and, when possible, "X days ahead/behind" or "goal reached around date X."  
- **Safe data entry:** Validation and confirmations to avoid typos and outliers.  
- **Accessible:** Support kg/lbs, multiple languages, configurable week start, screen reader support, and WCAG AA compliance.  
- **Simple to use:** Add weigh-ins quickly, review history, edit/delete when needed, and adjust settings without restarting.
- **Local-only:** All data stored locally, no internet required, complete privacy.

---

## Features

### Onboarding

First-time users go through a short flow before reaching the main app.

1. **Welcome**  
   - Short intro to w8 and main features (weekly median, smart tracking, clear progress).  
   - "Get Started" → language selection.

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
   - Validation (including "very different from initial" warning).  
   - On save, onboarding is marked complete and the user is taken to the main app.

If onboarding isn't completed, the app redirects to `/onboarding` until the flow is finished.

---

### Overview Screen

The main screen consolidates Home, Progress, and Insights into a comprehensive view.

- **Streak card**  
  - Current streak (days in a row tracking).  
  - Longest streak.  
  - Days since last entry.  
  - Total days tracked.

- **Progress card**  
  - Current weight (from latest weekly median or last entry).  
  - Animated progress bar with milestone markers (25%, 50%, 75%).  
  - Progress percentage toward goal.  
  - "X kg/lbs gained (or lost) / target" and start vs goal.  
  - All weights in the user's chosen unit.

- **Goal vs actual**  
  - Side-by-side current weight and goal weight.  
  - Visual comparison.

- **On-track banner** (when there are ≥2 weigh-ins)  
  - **On track:** actual rate within ~90–110% of required rate.  
  - **Ahead:** above that range.  
  - **Behind:** below.  
  - Color-coded (e.g. green / orange) for quick reading.  
  - Shows days ahead/behind when available.

- **Stats row**  
  - **Progress %**  
  - **Weight to go / weight to lose** (remaining to target, in kg or lbs)  
  - **Weeks left** (from goal duration and elapsed time)

- **Weekly evolution chart**  
  - Interactive line chart of **weekly medians** over time.  
  - **Pinch-to-zoom** and **drag-to-pan** when zoomed.  
  - **Time range selector** (Last 4 weeks, 3 months, 6 months, All time).  
  - Optional horizontal reference lines for **initial** and **target** weight.  
  - Tooltips on touch (date + value in selected unit).  
  - Y-axis scale adapts to data and references; last N weeks shown to keep it readable.  
  - Respects "week starts on" and weight unit.  
  - Accessible data table for screen readers.

- **Insights card**  
  - Status (On track / Ahead / Behind).  
  - Current rate vs required rate comparison.  
  - Goal date prediction.  
  - **Actionable recommendations** based on progress status.

- **Progress vs time comparison**  
  - Compares **time elapsed** (e.g. 30% of duration) vs **weight progress** (e.g. 35% toward target).  
  - "Ahead by X%" / "Behind by X%" / "Perfectly in sync" when relevant.

- **Pattern insights** (when context data available)  
  - Correlations between context tags (sleep, stress, exercise, meal timing) and weight changes.  
  - Actionable suggestions based on detected patterns.  
  - Confidence scores for insights.

- **Actions**  
  - **Add** (app bar): go to Add Weight.  
  - **History** (app bar): go to full History screen.  
  - Pull-to-refresh to reload data.

- **Empty states**  
  - Motivational empty states with clear call-to-action buttons.  
  - Engaging illustrations and helpful guidance.

---

### History

- **List**  
  - All weigh-ins, most recent first.  
  - **Pagination:** Shows 20 items per page with "Load more" button.  
  - Each row: date (Today / Yesterday / weekday + date), time, weight in selected unit.  
  - **Context display:** Expandable entries showing tags (sleep quality, stress, exercise, meal timing) and notes.  
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

- **Context tracking (optional)**  
  - Collapsible section to add context:  
    - Sleep quality (1-5 rating).  
    - Stress level (1-5 rating).  
    - Exercised (yes/no).  
    - Meal timing (breakfast, lunch, dinner, late night).  
    - Notes (free text).  
  - Helps identify patterns and correlations with weight changes.

- **Edit mode**  
  - Opened from History when editing an entry.  
  - Form pre-filled; saving updates that entry (same or new date/time).  
  - Back returns to History.

- **Add mode**  
  - Default date/time = now.  
  - After save, navigates back to Overview (or previous context).  
  - Success feedback with animation.

- **Validation**  
  - Same smart checks as above (range, implausible jumps, goal consistency, optional trend checks).  
  - Errors block save; warnings can require confirmation.  
  - Edit validation excludes the **current** entry when checking for duplicates or outliers.

- **Celebrations**  
  - Automatic celebration overlays for milestones (first entry, streaks, progress percentages).  
  - Confetti animations and haptic feedback.  
  - Achievement unlocks with visual feedback.

---

### Settings

- **Appearance**  
  - **Theme:** Light, Dark, or System (follows device setting).  
  - Theme preference persists across app restarts.

- **Language**  
  - Same options as onboarding (e.g. English, French).  
  - Change applies immediately across the app (no restart).

- **Weight unit**  
  - kg or lbs.  
  - All relevant UI (Overview, History, Add/Edit) uses the new unit immediately after refresh.

- **Week starts on**  
  - Dropdown: Monday through Sunday.  
  - Affects weekly medians and chart week boundaries.  
  - Applied without restart.

- **Goal management**  
  - **Edit Goal:** Modify target weight, duration, start date, goal type.  
  - Recalculates progress when goal changes.  
  - Shows warning if goal change is significant.

- **Reminders**  
  - Enable/disable daily weight tracking reminders.  
  - Set reminder time.  
  - Notification actions: "Snooze" and "I've weighed in".  
  - Gentle, encouraging reminder messages.

- **Achievements**  
  - View unlocked achievement badges.  
  - Track consistency, streaks, and progress milestones.  
  - Visual display of achievements.

- **Tips & Education**  
  - Access educational content about weight tracking.  
  - Topics: Why weight fluctuates, Weekly medians, Best practices, Plateaus, Context tracking, Motivation.  
  - Helpful explanations to understand tracking better.

- **Data management**  
  - **Export data:** CSV or JSON format.  
  - All data stored locally, no cloud sync required.  
  - Complete privacy and data control.

- **Persistence**  
  - Stored via the same goal/preferences backend as onboarding.  
  - Overview (and thus all screens) refreshes when settings change so all screens stay in sync.

---

## Advanced Features

### Context Tracking

- **Optional tags** for each weight entry:  
  - Sleep quality (1-5 rating).  
  - Stress level (1-5 rating).  
  - Exercised (yes/no).  
  - Meal timing (breakfast, lunch, dinner, late night).  
  - Notes (free text).

- **Pattern recognition**  
  - Analyzes correlations between context tags and weight changes.  
  - Generates insights like "You tend to lose more after good sleep" or "High stress affects your progress".  
  - Provides actionable suggestions based on detected patterns.  
  - Confidence scores for each insight.

### Engagement Features

- **Streak tracking**  
  - Current streak (consecutive days tracking).  
  - Longest streak.  
  - Visual streak counter on Overview.

- **Celebrations**  
  - Automatic celebrations for milestones:  
    - First entry.  
    - Streak milestones (7, 30, 100 days).  
    - Progress milestones (25%, 50%, 75%, 100%).  
  - Confetti animations and haptic feedback.

- **Achievements**  
  - Unlockable badges for various accomplishments:  
    - Consistency (tracked X days).  
    - Streaks (7, 30, 100 days).  
    - Progress milestones.  
  - Visual achievement display in Settings.

- **Actionable recommendations**  
  - Contextual suggestions based on progress status.  
  - Encouragement messages.  
  - Actionable items to help stay on track.

### Educational Content

- **In-app education**  
  - Accessible from Settings and contextual help buttons.  
  - Topics cover:  
    - Why weight fluctuates daily.  
    - How weekly medians work.  
    - Best practices for tracking.  
    - Understanding plateaus.  
    - Why track context.  
    - Staying motivated.

### Performance & Accessibility

- **Performance optimizations**  
  - Pagination for history (20 items per page).  
  - Cached weekly medians (5-minute cache, auto-invalidated on data changes).  
  - Efficient rendering with ListView.builder.  
  - Optimized chart rendering.

- **Accessibility**  
  - Semantic labels for all interactive elements.  
  - Screen reader support (TalkBack, VoiceOver).  
  - Data table alternatives for charts.  
  - Minimum touch target sizes (44x44pt).  
  - WCAG AA contrast compliance.

- **Error handling**  
  - Global error handlers prevent app crashes.  
  - User-friendly error messages.  
  - Retry functionality for recoverable errors.  
  - Graceful degradation on initialization errors.

### UI/UX Polish

- **Smooth animations**  
  - Page transitions (fade + slide).  
  - Card entrance animations.  
  - Loading skeleton screens (instead of spinners).  
  - Haptic feedback for navigation and important actions.

- **Interactive charts**  
  - Pinch-to-zoom.  
  - Drag-to-pan when zoomed.  
  - Time range selector.  
  - Tap-to-focus with tooltips.  
  - Reset zoom button.

---

## Technical Overview

- **Framework:** Flutter (Material 3).  
- **State:** Riverpod (`StateNotifier` / `AsyncValue` for loading/data/error).  
- **Navigation:** `go_router` (declarative routes, redirect for onboarding, custom page transitions).  
- **Storage:** Hive (local NoSQL DB) for:  
  - Weigh-ins (timestamp-based keys, supports multiple entries per day).  
  - Goal configuration and app preferences (including language, unit, week start, theme).  
  - Achievements.  
  - App settings.
- **i18n:** `flutter_localizations` + `intl`; ARB files for English and French; generated `AppLocalizations`.  
- **Charts:** `fl_chart` for the weekly evolution line chart with zoom/pan support.  
- **Notifications:** `flutter_local_notifications` for daily reminders.  
- **Animations:** `confetti` for celebrations, custom animations for UI polish.  
- **Architecture:** Feature-based structure (e.g. `home`, `history`, `add_weight`, `onboarding`, `settings`) with view models and shared `core` (routing, services, models, utils, widgets).

### Key Services

- **HiveStorageService:** Manages weight entries storage with timestamp-based keys.  
- **GoalStorageService:** Manages goal configuration and preferences.  
- **WeightValidationService:** Unit-aware validation with supportive messages.  
- **StatisticalCalculator:** Advanced statistical calculations (rates, smoothing).  
- **StreakService:** Calculates tracking streaks.  
- **CelebrationService:** Detects milestones and triggers celebrations.  
- **ReminderService:** Manages daily tracking reminders.  
- **AchievementService:** Tracks and unlocks achievements.  
- **PatternRecognitionService:** Analyzes context data for insights.  
- **InsightRecommendationsService:** Generates actionable recommendations.  
- **PreferencesService:** Manages user preferences (theme, etc.).  
- **MetricsCache:** Caches calculated metrics for performance.  
- **DataExportService:** Exports data to CSV/JSON.

### Key Widgets

- **AnimatedProgressBar:** Progress bar with milestone markers and animations.  
- **CelebrationOverlay:** Full-screen celebration with confetti.  
- **SuccessAnimation:** Animated checkmark for success feedback.  
- **EmptyState:** Motivational empty states.  
- **EducationOverlay:** Educational content display.  
- **LoadingSkeleton:** Skeleton loading screens.  
- **AnimatedCard:** Cards with subtle tap animations.  
- **ErrorBoundary:** Error handling utilities.

---

## Getting Started

### Requirements

- Flutter SDK (3.x or later).  
- A device or emulator (Android recommended for testing).

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

## Data Privacy

**w8** is designed with privacy in mind:

- **100% local storage:** All data is stored on your device only.  
- **No internet required:** The app works completely offline.  
- **No cloud sync:** Your data never leaves your device.  
- **Export capability:** You can export your data (CSV/JSON) at any time.  
- **Complete control:** You own and control all your data.

---

## Summary

**w8** helps you track weight toward a clear goal (gain, lose, or maintain) by:

- Using **weekly medians** (and smoothing) to cut through daily noise.  
- Showing **goal-centric progress** (on track / ahead / behind, rates, and optional goal-date prediction).  
- **Validating** entries to reduce typos and outliers, and allowing **edit/delete** when needed.  
- Supporting **kg/lbs**, **multiple languages**, **configurable week start**, and **theme preferences**, with settings that apply **without restart**.  
- Providing **context tracking** to identify patterns and correlations.  
- Offering **actionable insights** and **recommendations** to help you stay on track.  
- Celebrating **milestones** and **achievements** to keep you motivated.  
- Ensuring **accessibility** and **performance** for the best user experience.

The app is built for people who weigh themselves regularly and want a simple, honest view of whether they're on pace to hit their target, with complete privacy and local-only data storage.

---

## License

This project is private and proprietary.
