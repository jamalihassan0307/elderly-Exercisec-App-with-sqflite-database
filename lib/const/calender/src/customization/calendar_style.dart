import 'package:ex_app/Core/color.dart';
import 'package:flutter/material.dart';

class CalendarStyle {
  /// Maximum amount of single event marker dots to be displayed.
  final int markersMaxCount;
  final bool canMarkersOverflow;
  final bool markersAutoAligned;
  final double markersAnchor;
  final double? markerSize;
  final double markerSizeScale;
  // final PositionedOffset markersOffset;
  final AlignmentGeometry markersAlignment;
  final Decoration markerDecoration;
  final EdgeInsets markerMargin;
  final EdgeInsets cellMargin;
  final EdgeInsets cellPadding;
  final AlignmentGeometry cellAlignment;
  final double rangeHighlightScale;
  final Color rangeHighlightColor;
  final bool outsideDaysVisible;
  final bool isTodayHighlighted;
  final TextStyle todayTextStyle;
  final Decoration todayDecoration;
  final TextStyle selectedTextStyle;
  final Decoration selectedDecoration;
  final TextStyle outsideTextStyle;
  final Decoration outsideDecoration;
  final TextStyle weekendTextStyle;
  final Decoration weekendDecoration;
  final TextStyle defaultTextStyle;

  /// Decoration for day cells that do not match any other styles.
  final Decoration defaultDecoration;

  /// Decoration for each interior row of day cells.
  final Decoration rowDecoration;

  /// Border for the internal `Table` widget.
  final TableBorder tableBorder;

  /// Creates a `CalendarStyle` used by `TableCalendar` widget.
  const CalendarStyle({
    this.isTodayHighlighted = true,
    this.canMarkersOverflow = true,
    this.outsideDaysVisible = true,
    this.markersAutoAligned = true,
    this.markerSize,
    this.markerSizeScale = 0.2,
    this.markersAnchor = 0.7,
    this.rangeHighlightScale = 1.0,
    this.markerMargin = const EdgeInsets.symmetric(horizontal: 0.3),
    this.markersAlignment = Alignment.bottomCenter,
    this.markersMaxCount = 4,
    this.cellMargin = const EdgeInsets.all(6.0),
    this.cellPadding = const EdgeInsets.all(0),
    this.cellAlignment = Alignment.center,
    this.rangeHighlightColor = const Color(0xFFBBDDFF),
    this.markerDecoration = const BoxDecoration(
      color: Colors.red,
      shape: BoxShape.circle,
    ),
    this.todayTextStyle = const TextStyle(
      color: Color(0xFF000000),
      fontSize: 16.0,
    ), //
    this.todayDecoration = const BoxDecoration(
      border: Border(
        top: BorderSide(color: blue),
        bottom: BorderSide(color: blue),
        right: BorderSide(color: blue),
        left: BorderSide(color: blue),
      ),
      shape: BoxShape.circle,
    ),
    this.selectedTextStyle = const TextStyle(
      color: Color(0xFFFAFAFA),
      fontSize: 16.0,
    ),
    this.selectedDecoration = const BoxDecoration(
      color: blue,
      boxShadow: [
        BoxShadow(
          color: blueShadow,
          offset: Offset(0, 3),
          blurRadius: 5,
        )
      ],
      shape: BoxShape.circle,
    ),
    this.outsideTextStyle = const TextStyle(color: Color(0xFFAEAEAE)),
    this.outsideDecoration = const BoxDecoration(shape: BoxShape.circle),
    this.weekendTextStyle = const TextStyle(color: Color(0xFF5A5A5A)),
    this.weekendDecoration = const BoxDecoration(shape: BoxShape.circle),
    this.defaultTextStyle = const TextStyle(),
    this.defaultDecoration = const BoxDecoration(shape: BoxShape.circle),
    this.rowDecoration = const BoxDecoration(),
    this.tableBorder = const TableBorder(),
  });
}
