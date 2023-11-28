import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'needle_pointer.dart';
import 'circle_pointer.dart';
import 'trapeze_pointer.dart';
import 'triangle_pointer.dart';

/// Describes the position (anchor) of the gauge pointer.
///
/// Used by [GaugePointerPosition] and [GaugePointer].
enum GaugePointerAnchor {
  /// The pointer is placed in the center of the indicator widget.
  center,

  /// The pointer is positioned above the surface of the indicator segments.
  surface,
}

/// Describes the pointer position with [anchor] and [offset].
class GaugePointerPosition extends Equatable {
  /// Position in which the indicator is anchored
  final GaugePointerAnchor anchor;

  /// The offset of the indicator in x,y coordinates.
  ///
  /// This will be applied before the indicator is rotated.
  ///
  /// By default [Offset.zero].
  final Offset offset;

  const GaugePointerPosition({
    this.anchor = GaugePointerAnchor.surface,
    this.offset = Offset.zero,
  });

  /// The pointer is placed in the center of the indicator widget.
  const GaugePointerPosition.center({
    this.offset = Offset.zero,
  }) : anchor = GaugePointerAnchor.center;

  /// The pointer is positioned above the surface of the indicator segments.
  ///
  /// To position the pointer below or above the segments, use the [offset]
  /// argument and move the pointer by the thickness of the axis.
  /// ```dart
  /// GaugePointerPosition.surface(
  ///   offset: Offset(0.0, axisThickness),  // below the segments
  /// );
  /// GaugePointerPosition.surface(
  ///   offset: Offset(0.0, -axisThickness), // above the segments
  /// )
  /// ```
  const GaugePointerPosition.surface({
    this.offset = Offset.zero,
  }) : anchor = GaugePointerAnchor.surface;

  @override
  List<Object?> get props => [anchor, offset];
}

@immutable
class GaugePointerBorder extends Equatable {
  final Color color;
  final double width;

  const GaugePointerBorder({
    required this.color,
    required this.width,
  }) : assert(width > 0, 'Width must be larger than 0.');

  @override
  List<Object?> get props => [color, width];
}

@immutable
abstract class GaugePointer {
  Path get path;
  Size get size;
  GaugePointerPosition get position;

  double get value;

  /// Either color or gradient must be provided.
  Color? get color;
  Gradient? get gradient;

  /// When null, the pointer shadow will not be rendered.
  Shadow? get shadow;

  /// When null, the pointer border will not be rendered.
  GaugePointerBorder? get border;

  /// Draws a needle pointer.
  const factory GaugePointer.needle({
    required double width,
    required double height,
    required Color color,
    double pointerValue,
    GaugePointerPosition position,
    GaugePointerBorder? border,
    double? borderRadius,
    Gradient? gradient,
    Shadow? shadow,
  }) = NeedlePointer;

  /// Draws a circle pointer.
  const factory GaugePointer.circle({
    required double radius,
    double pointerValue,
    Color? color,
    GaugePointerPosition position,
    GaugePointerBorder? border,
    Gradient? gradient,
    Shadow? shadow,
  }) = CirclePointer;

  /// Draws a triangle pointer.
  const factory GaugePointer.triangle({
    required double width,
    required double height,
    double pointerValue,
    Color? color,
    GaugePointerPosition position,
    GaugePointerBorder? border,
    double borderRadius,
    Gradient? gradient,
    Shadow? shadow,
  }) = TrianglePointer;

  /// Draws a trapeze pointer.
  const factory GaugePointer.trapeze({
    required double width,
    required double height,
    double pointerValue,
    Color? color,
    GaugePointerPosition position,
    GaugePointerBorder? border,
    double borderRadius,
    Gradient? gradient,
    Shadow? shadow,
  }) = TrapezePointer;
}
