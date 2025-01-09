import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

typedef GaugeLabelBuilder = Widget Function(
  BuildContext context,
  Widget? child,
  double value,
);

/// Animated [RadialGauge] widget.
class AnimatedRadialGauge extends ImplicitlyAnimatedWidget {
  /// The value from which the widget animation will start to [value].
  final double initialValue;
  final double value;
  final GaugeAxis axis;
  final Alignment alignment;
  final bool debug;
  final double? axisRadius;
  final double? progressRadius;
  final Widget? child;
  final GaugeLabelBuilder? builder;

  const AnimatedRadialGauge({
    Key? key,
    this.initialValue = 0.0,
    required Duration duration,
    required this.value,
    this.builder,
    this.axis = const GaugeAxis(),
    Curve curve = Curves.linear,
    this.alignment = Alignment.center,
    this.axisRadius,
    this.progressRadius,
    this.debug = false,
    this.child,
    VoidCallback? onEnd,
  }) : super(
          key: key,
          duration: duration,
          curve: curve,
          onEnd: onEnd,
        );

  @override
  AnimatedWidgetBaseState<AnimatedRadialGauge> createState() =>
      _AnimatedRadialGaugeState();
}

class _AnimatedRadialGaugeState
    extends AnimatedWidgetBaseState<AnimatedRadialGauge> {
  bool _isInitialAnimation = true;

  Tween<double>? _valueTween;
  Tween<double?>? _axisRadiusTween;
  Tween<double?>? _progressRadiusTween;
  List<Tween<double>> _segmentTweens = [];
  GaugeAxisTween? _axisTween;

  @override
  void initState() {
    super.initState();
    controller
      ..value = 0.0
      ..forward().whenCompleteOrCancel(() {
        _isInitialAnimation = false;
      });
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _axisTween = visitor(
      _axisTween,
      widget.axis,
      (dynamic value) => GaugeAxisTween(
        begin: value as GaugeAxis,
        end: value,
      ),
    ) as GaugeAxisTween;
    _valueTween = visitor(
      _valueTween,
      widget.value,
      (dynamic value) => Tween<double>(
        begin: widget.initialValue,
        end: widget.value,
      ),
    ) as Tween<double>;

    _axisRadiusTween = widget.axisRadius == null
        // If the radius is not specified, its animation is disabled.
        ? NullTween()
        : visitor(
            _axisRadiusTween,
            widget.axisRadius,
            (dynamic value) => Tween<double?>(
              begin: value,
              end: value,
            ),
          ) as Tween<double?>;

    _progressRadiusTween = widget.progressRadius == null
        // If the radius is not specified, its animation is disabled.
        ? NullTween()
        : visitor(
            _progressRadiusTween,
            widget.progressRadius,
            (dynamic value) => Tween<double?>(
              begin: value,
              end: value,
            ),
          ) as Tween<double?>;

    final filledSectors = widget.axis.segments.where((e) => e.fillSector);
    _segmentTweens = filledSectors.isEmpty
        ? []
        : filledSectors.mapIndexed((i, e) {
            return visitor(
              _safeGet(_segmentTweens, i),
              e.to,
              (dynamic value) => Tween<double>(
                begin: e.from,
                end: e.to,
              ),
            ) as Tween<double>;
          }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Builder(
        builder: (context) {
          final value = _valueTween!.evaluate(animation).clamp(
                widget.axis.min,
                widget.axis.max,
              );

          final axisRadius = _axisRadiusTween!.evaluate(animation);
          final progressRadius = _progressRadiusTween!.evaluate(animation);
          final computedAxis = _axisTween!.evaluate(animation)!.flatten();

          final filledSectors = widget.axis.segments.where((e) => e.fillSector);
          final otherSegments =
              widget.axis.segments.where((e) => !e.fillSector);
          final animatedFilledSectors = filledSectors.mapIndexed((i, e) {
            return e.copyWith(
                to: _safeGet(_segmentTweens, i)?.evaluate(animation));
          }).toList();

          final axis = computedAxis
              .transform(
            range: GaugeRange(widget.axis.min, widget.axis.max),
            progress: controller.value,
            value: value,
            isInitial: _isInitialAnimation,
          )
              .copyWith(segments: [...animatedFilledSectors, ...otherSegments]);

          return RadialGauge(
            debug: widget.debug,
            value: value,
            axisRadius: axisRadius,
            progressRadius: progressRadius,
            alignment: widget.alignment,
            axis: axis,
            child: widget.builder?.call(context, widget.child, value),
          );
        },
      ),
    );
  }

  T? _safeGet<T>(List<T> list, int index) {
    if (index >= 0 && index < list.length) {
      return list[index];
    }
    return null;
  }
}
