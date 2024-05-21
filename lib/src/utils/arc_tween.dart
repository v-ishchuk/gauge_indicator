import 'package:flutter/animation.dart';

Tween<double> arcTween(double degrees) {
  if(degrees == 359.99){
    return Tween<double>(
      begin: -90,
      end: 269.99,
    );
  }

  final angleShift = (degrees - 180) / 2;
  return Tween<double>(
    begin: -180.0 - angleShift,
    end: 0.0 + angleShift,
  );
}
