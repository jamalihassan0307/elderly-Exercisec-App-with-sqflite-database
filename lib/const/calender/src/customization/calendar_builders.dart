import 'package:flutter/widgets.dart';

import '../shared/utils.dart' show DayBuilder, FocusedDayBuilder;

typedef SingleMarkerBuilder<T> = Widget? Function(
    BuildContext context, DateTime day, T event);
typedef MarkerBuilder<T> = Widget? Function(
    BuildContext context, DateTime day, List<T> events);
typedef HighlightBuilder = Widget? Function(
    BuildContext context, DateTime day, bool isWithinRange);

class CalendarBuilders<T> {
  final FocusedDayBuilder? prioritizedBuilder;
  final FocusedDayBuilder? todayBuilder;

  final FocusedDayBuilder? selectedBuilder;

  final FocusedDayBuilder? outsideBuilder;

  final FocusedDayBuilder? defaultBuilder;

  final HighlightBuilder? rangeHighlightBuilder;

  final SingleMarkerBuilder<T>? singleMarkerBuilder;

  final MarkerBuilder<T>? markerBuilder;

  final DayBuilder? dowBuilder;

  final DayBuilder? headerTitleBuilder;

  const CalendarBuilders({
    this.prioritizedBuilder,
    this.todayBuilder,
    this.selectedBuilder,
    this.outsideBuilder,
    this.defaultBuilder,
    this.rangeHighlightBuilder,
    this.singleMarkerBuilder,
    this.markerBuilder,
    this.dowBuilder,
    this.headerTitleBuilder,
  });
}
