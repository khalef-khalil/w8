import 'package:flutter/material.dart';

import '../extensions/l10n_context.dart';
import '../models/goal_configuration.dart';

String weekStartDayLabel(BuildContext context, WeekStartDay d) {
  final l10n = context.l10n;
  switch (d) {
    case WeekStartDay.monday:
      return l10n.monday;
    case WeekStartDay.tuesday:
      return l10n.tuesday;
    case WeekStartDay.wednesday:
      return l10n.wednesday;
    case WeekStartDay.thursday:
      return l10n.thursday;
    case WeekStartDay.friday:
      return l10n.friday;
    case WeekStartDay.saturday:
      return l10n.saturday;
    case WeekStartDay.sunday:
      return l10n.sunday;
  }
}
