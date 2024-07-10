library simple_timer;

import 'dart:math' as math;
import 'dart:math';
import 'package:flutter/material.dart';

class CustomWorkOutTimer extends StatefulWidget {
  const CustomWorkOutTimer({
    Key? key,
    required this.duration,
    this.child,
    this.onStart,
    this.onEnd,
    this.valueListener,
    this.progressTextFormatter,
    this.controller,
    this.status,
    this.progressTextStyle,
    this.delay = const Duration(seconds: 0),
    this.timerStyle = WOTimerStyle.ring,
    this.displayProgressIndicator = true,
    this.displayProgressText = true,
    this.progressTextCountDirection =
        WOTimerProgressTextCountDirection.countDown,
    this.progressIndicatorDirection =
        WOTimerProgressIndicatorDirection.clockwise,
    this.backgroundColor = Colors.grey,
    this.progressIndicatorColor = Colors.green,
    this.startAngle = math.pi * 1.5,
    this.strokeWidth = 5.0,
  })  : assert(!(status == null && controller == null),
            "No Controller or Status has been set; Please set either the controller (TimerController) or the status (TimerStatus) property - only should can be set"),
        assert(status == null || controller == null,
            "Both Controller and Status have been set; Please set either the controller (TimerController) or the status (TimerStatus) - only one should be set"),
        assert(displayProgressIndicator || displayProgressText,
            "At least either displayProgressText or displayProgressIndicator must be set to True"),
        super(key: key);

  /// The length of time for this timer.
  final Duration duration;
  final Duration delay;
  final WorkOutTimer? controller;
  final WOTimerStatus? status;
  final WOTimerStyle timerStyle;
  final String Function(Duration timeElapsed)? progressTextFormatter;
  final VoidCallback? onStart;

  final VoidCallback? onEnd;
  final void Function(Duration timeElapsed)? valueListener;

  final WOTimerProgressTextCountDirection progressTextCountDirection;

  final WOTimerProgressIndicatorDirection progressIndicatorDirection;

  final bool displayProgressText;

  final TextStyle? progressTextStyle;
  final bool displayProgressIndicator;

  /// The color of the animating progress indicator.
  final Color progressIndicatorColor;
  final Color backgroundColor;
  final double startAngle;
  final double strokeWidth;

  /// Add This Line
  final Widget? child;

  @override
  State<StatefulWidget> createState() {
    return TimerState();
  }
}

class TimerState extends State<CustomWorkOutTimer>
    with SingleTickerProviderStateMixin {
  late WorkOutTimer controller;

  bool _useLocalController = false;
  bool wasActive = false;

  @override
  void initState() {
    if (widget.controller == null) {
      controller = WorkOutTimer(this);
      _useLocalController = true;
    } else {
      controller = widget.controller!;
    }
    controller.duration = widget.duration;
    controller._setDelay(widget.delay);
    controller.addListener(_animationValueListener);
    controller.addStatusListener(_animationStatusListener);
    if (_useLocalController && (widget.status == WOTimerStatus.start)) {
      _startTimer(true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Align(
            alignment: FractionalOffset.center,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: <Widget>[
                  widget.displayProgressIndicator
                      ? AnimatedBuilder(
                          animation: controller,
                          builder: (context, _) {
                            return CustomPaint(
                              size: MediaQuery.of(context).size,
                              painter: TimerPainter(
                                  animation: controller,
                                  timerStyle: widget.timerStyle,
                                  progressIndicatorDirection:
                                      widget.progressIndicatorDirection,
                                  progressIndicatorColor:
                                      widget.progressIndicatorColor,
                                  backgroundColor: widget.backgroundColor,
                                  startAngle: widget.startAngle,
                                  strokeWidth: widget.strokeWidth),
                            );
                          },
                        )
                      : Container(),
                  widget.displayProgressText
                      ? Container(
                          margin: const EdgeInsets.all(5),
                          child: Align(
                            alignment: FractionalOffset.center,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: AnimatedBuilder(
                                  animation: controller,
                                  builder: (context, child) {
                                    // Edit this i'm
                                    return Column(
                                      children: [
                                        widget.child ?? Container(),
                                        Text(
                                          getProgressText() == '0'
                                              ? '60'
                                              : getProgressText(),
                                          style: getProgressTextStyle(),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            )));
  }

  TextStyle getProgressTextStyle() {
    return TextStyle(fontSize: Theme.of(context).textTheme.headline1!.fontSize)
        .merge(widget.progressTextStyle);
  }

  @override
  void didUpdateWidget(CustomWorkOutTimer oldWidget) {
    if (_useLocalController) {
      if (widget.status == WOTimerStatus.start &&
          oldWidget.status != WOTimerStatus.start) {
        if (controller.isDismissed) {
          _startTimer();
        } else {
          _startTimer(false);
        }
      } else if (widget.status == WOTimerStatus.pause &&
          oldWidget.status != WOTimerStatus.pause) {
        controller.pause();
      } else if (widget.status == WOTimerStatus.reset &&
          oldWidget.status != WOTimerStatus.reset) {
        controller.reset();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  void _startTimer([bool useDelay = true]) {
    if (useDelay && !controller._wasActive) {
      controller._wasActive = true;
      Future.delayed(widget.delay, () {
        if (mounted && (widget.status == WOTimerStatus.start)) {
          controller.forward();
        }
      });
    } else {
      controller.forward();
    }
  }

  void _animationValueListener() {
    if (widget.valueListener != null) {
      widget.valueListener!(controller.duration! * controller.value);
    }
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.forward && widget.onStart != null) {
      wasActive = true;
      widget.onStart!();
    } else if (status == AnimationStatus.completed && widget.onEnd != null) {
      widget.onEnd!();
    } else if (status == AnimationStatus.dismissed) {
      wasActive = false;
    }
  }

  String getProgressText() {
    Duration duration = controller.duration! * controller.value;
    if (widget.progressTextCountDirection ==
        WOTimerProgressTextCountDirection.countDown) {
      duration = Duration(
          seconds: controller.duration!.inSeconds - duration.inSeconds);
    } else if (widget.progressTextCountDirection ==
        WOTimerProgressTextCountDirection.singleCount) {
      duration = Duration(
          seconds: controller.duration!.inSeconds - duration.inSeconds);
      return "${(duration.inSeconds % 60)}";
    }
    if (widget.progressTextFormatter == null) {
      return "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, "0")}";
    }

    return widget.progressTextFormatter!(duration);
  }

  @override
  void dispose() {
    controller.stop();
    controller.removeStatusListener(_animationStatusListener);
    if (_useLocalController) {
      controller.dispose();
    }
    super.dispose();
  }
}

class TimerPainter extends CustomPainter {
  final Animation<double> animation;
  WOTimerProgressIndicatorDirection progressIndicatorDirection;
  WOTimerStyle timerStyle;
  Color progressIndicatorColor, backgroundColor;
  double startAngle;
  double strokeWidth;

  TimerPainter(
      {required this.animation,
      this.progressIndicatorDirection =
          WOTimerProgressIndicatorDirection.clockwise,
      this.progressIndicatorColor = Colors.green,
      this.backgroundColor = Colors.grey,
      this.timerStyle = WOTimerStyle.ring,
      this.startAngle = math.pi * 1.5,
      this.strokeWidth = 5.0})
      : super(repaint: animation);

  PaintingStyle getPaintingStyle() {
    switch (timerStyle) {
      case WOTimerStyle.ring:
        return PaintingStyle.stroke;
      case WOTimerStyle.expandingSector:
        return PaintingStyle.fill;
      case WOTimerStyle.expandingCircle:
        return PaintingStyle.fill;
      case WOTimerStyle.expandingSegment:
        return PaintingStyle.fill;
      default:
        timerStyle = WOTimerStyle.ring;
        return PaintingStyle.stroke;
    }
  }

  double getProgressRadius(double circleRadius) {
    if (timerStyle == WOTimerStyle.expandingCircle) {
      circleRadius = circleRadius * animation.value;
    }
    return circleRadius;
  }

  double getProgressSweepAngle() {
    double progress = 2 * math.pi;
    if (timerStyle == WOTimerStyle.expandingCircle) {
      return progress;
    }
    progress = animation.value * progress;
    if (progressIndicatorDirection ==
        WOTimerProgressIndicatorDirection.counterClockwise) {
      progress = -progress;
    }
    return progress;
  }

  double getStartAngle() {
    if (progressIndicatorDirection == WOTimerProgressIndicatorDirection.both) {
      return (startAngle - (math.pi * animation.value)).abs();
    }
    return startAngle;
  }

  bool shouldUseCircleCenter() {
    if (timerStyle == WOTimerStyle.ring) {
      return false;
    } else if (timerStyle == WOTimerStyle.expandingSegment) {
      return false;
    }
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double radius = math.min(size.width, size.height) / 2;
    final Offset center = size.center(Offset.zero);

    final Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = getPaintingStyle();

    canvas.drawCircle(center, radius, paint);

    Rect rect =
        Rect.fromCircle(center: center, radius: getProgressRadius(radius));
    paint.color = progressIndicatorColor;
    canvas.drawArc(rect, getStartAngle(), getProgressSweepAngle(),
        shouldUseCircleCenter(), paint);

    // For showing the point moving on the circle
    double progress = animation.value * 2 * -math.pi;
    final offset = Offset(
      center.dx + radius * cos(math.pi * 1.5 + progress),
      center.dy + radius * sin(math.pi * 1.5 + progress),
    );
    canvas.drawCircle(
      offset,
      7,
      Paint()
        ..strokeWidth = 5
        ..color = progressIndicatorColor
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) {
    return animation.value != oldDelegate.animation.value ||
        oldDelegate.progressIndicatorColor != progressIndicatorColor ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}

class WorkOutTimer extends AnimationController {
  bool _wasActive = false;

  Duration? _delay;

  WorkOutTimer(TickerProvider vsync) : super(vsync: vsync);

  Duration? get delay => _delay;

  void _setDelay(Duration delay) {
    _delay = delay;
  }

  double? _calculateStartValue(Duration? startDuration) {
    startDuration = (startDuration != null && (startDuration > duration!))
        ? duration
        : startDuration;
    return startDuration == null
        ? null
        : (1 - (startDuration.inMilliseconds / duration!.inMilliseconds));
  }

  void start({bool useDelay = true, Duration? startFrom}) {
    if (useDelay && !_wasActive && (_delay != null)) {
      _wasActive = true;
      Future.delayed(_delay!, () {
        forward(from: _calculateStartValue(startFrom));
      });
    } else {
      forward(from: _calculateStartValue(startFrom));
    }
  }

  void pause() {
    stop();
  }

  @override
  void reset() {
    _wasActive = false;
    super.reset();
  }

  void restart({bool useDelay = true, Duration? startFrom}) {
    reset();
    start(startFrom: startFrom);
  }

  void add(Duration duration,
      {bool start = false,
      Duration changeAnimationDuration = const Duration(seconds: 0)}) {
    duration = (duration > this.duration!) ? this.duration! : duration;
    double newValue =
        value - (duration.inMilliseconds / this.duration!.inMilliseconds);
    animateBack(newValue, duration: changeAnimationDuration);
    if (start) {
      forward();
    }
  }

  void subtract(Duration duration,
      {bool start = false,
      Duration changeAnimationDuration = const Duration(seconds: 0)}) {
    duration = (duration > this.duration!) ? this.duration! : duration;
    double newValue =
        value + (duration.inMilliseconds / this.duration!.inMilliseconds);
    animateTo(newValue, duration: changeAnimationDuration);
    if (start) {
      forward();
    }
  }
}

enum WOTimerStatus {
  start,
  pause,
  reset,
}

enum WOTimerProgressTextCountDirection { countDown, countUp, singleCount }

enum WOTimerProgressIndicatorDirection { clockwise, counterClockwise, both }

// test
enum WOTimerStyle { ring, expandingSector, expandingSegment, expandingCircle }
