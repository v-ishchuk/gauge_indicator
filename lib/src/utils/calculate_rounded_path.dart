import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:gauge_indicator/src/utils/arc_tween.dart';

Path calculateRoundedArcPath(
  Rect rect, {
  double? radius,
  double from = 0.0,
  double to = 1.0,
  double degrees = 180.0,
  double thickness = 10.0,
}) {
  final arcRadius = radius ?? rect.longestSide / 2;

  degrees = (degrees).clamp(10.0, 359.99);
  final part = to - from;
  final useDegrees = (degrees * part).clamp(10.0, 359.99);

  /// We are shifting arc angles to center it horizontally.
  final gaugeDegreesTween = arcTween(degrees);

  final circleCenter = rect.center;
  final halfThickness = thickness / 2;

  /// Can be helpful for multiple axes support.
  final startAngle = gaugeDegreesTween.transform(from);
  final endAngle = gaugeDegreesTween.transform(to);

  final innerRadius = arcRadius - thickness;
  final centerRadius = arcRadius - halfThickness;
  final outerRadius = arcRadius;

  final cornerAngle = getArcAngle(halfThickness, centerRadius);
  final largeArcMinAngle = 180.0 + toDegrees(cornerAngle * 2);

  final axisStartAngle =
      toRadians(startAngle) + (from > to ? -cornerAngle : cornerAngle);
  final axisEndAngle =
      toRadians(endAngle) - (from > to ? -cornerAngle : cornerAngle);

  final startOuterPoint =
      getPointOnCircle(circleCenter, axisStartAngle, outerRadius);
  final endOuterPoint =
      getPointOnCircle(circleCenter, axisEndAngle, outerRadius);
  final endInnerPoint =
      getPointOnCircle(circleCenter, axisEndAngle, innerRadius);
  final startInnerPoint =
      getPointOnCircle(circleCenter, axisStartAngle, innerRadius);

  final axisSurface = Path()
    ..moveTo(
      startOuterPoint.dx,
      startOuterPoint.dy,
    )
    ..arcToPoint(
      endOuterPoint,
      largeArc: useDegrees > largeArcMinAngle,
      radius: Radius.circular(outerRadius),
      clockwise: from < to,
    )
    ..arcToPoint(
      endInnerPoint,
      radius: Radius.circular(halfThickness),
      clockwise: from < to,
    )
    ..arcToPoint(
      startInnerPoint,
      largeArc: useDegrees > largeArcMinAngle,
      radius: Radius.circular(innerRadius),
      clockwise: from > to,
    )
    ..arcToPoint(
      startOuterPoint,
      radius: Radius.circular(halfThickness),
      clockwise: from < to,
    );

  return axisSurface;
}
