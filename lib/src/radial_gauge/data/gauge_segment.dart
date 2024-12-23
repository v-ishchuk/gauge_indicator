import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

@immutable
class GaugeSegment extends Equatable {
  final double from;
  final double to;
  final Color color;
  final GaugeAxisGradient? gradient;
  final GaugeBorder? border;
  final Shader? shader;
  final Radius cornerRadius;
  final bool fillSector;

  const GaugeSegment({
    required this.from,
    required this.to,
    this.color = const Color(0x00000000),
    this.gradient,
    this.border,
    this.shader,
    this.cornerRadius = Radius.zero,
    this.fillSector = false,
  });

  GaugeSegment copyWith({
    final double? from,
    final double? to,
    final Color? color,
    GaugeAxisGradient? gradient,
    Shader? shader,
    GaugeBorder? border,
    Radius? cornerRadius,
    bool? fillSector,
  }) =>
      GaugeSegment(
        from: from ?? this.from,
        to: to ?? this.to,
        color: color ?? this.color,
        gradient: gradient ?? this.gradient,
        shader: shader ?? this.shader,
        border: border ?? this.border,
        cornerRadius: cornerRadius ?? this.cornerRadius,
        fillSector: fillSector ?? this.fillSector,
      );

  static GaugeSegment lerp(GaugeSegment begin, GaugeSegment end, double t) =>
      GaugeSegment(
        from: lerpDouble(begin.from, end.from, t),
        to: lerpDouble(begin.to, end.to, t),
        color: Color.lerp(begin.color, end.color, t)!,
        gradient: end.gradient,
        shader: end.shader,
        border: GaugeBorder.lerp(begin.border, end.border, t),
        cornerRadius: Radius.lerp(begin.cornerRadius, end.cornerRadius, t)!,
        fillSector: end.fillSector,
      );

  @override
  List<Object?> get props =>
      [from, to, color, gradient, shader, cornerRadius, border, fillSector];
}
