import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class TrapezePointer extends Equatable implements GaugePointer {
  final double width;
  final double height;
  final double pointerValue;

  @override
  Size get size => Size(width, height);

  @override
  Path get path => roundedPoly([
        // bottom left
        VertexDefinition(width / 4, height, radius: width / 2),
        // bottom right
        VertexDefinition(width * 3 / 4, height, radius: width / 2),
        // top left
        VertexDefinition(width, 0, radius: width),
        // top right
        VertexDefinition(0, 0, radius: width),
      ], borderRadius);

  @override
  final Color? color;
  @override
  final GaugePointerPosition position;
  @override
  final GaugePointerBorder? border;
  final double borderRadius;
  @override
  final Gradient? gradient;
  @override
  final Shadow? shadow;

  const TrapezePointer({
    required this.width,
    required this.height,
    this.pointerValue = 0,
    this.color,
    this.position = const GaugePointerPosition.surface(),
    this.borderRadius = 2,
    this.border,
    this.gradient,
    this.shadow,
  }) : assert(
          (color != null && gradient == null) ||
              (gradient != null && color == null),
          'Either color or gradient must be provided.',
        );

  @override
  List<Object?> get props => [
        size,
        color,
        border,
        borderRadius,
        position,
        pointerValue,
      ];

  @override
  double get value => pointerValue;
}
