import 'package:flutter/material.dart';
import 'dart:math';

class Vector {
  double x;
  double y;

  Vector(this.x, this.y);

  Vector.polar(double distance, double angle) {
    x = distance * sin(angle);
    y = distance * cos(angle);
  }

  double distance() => sqrt(pow(x, 2) + pow(y, 2));

  double angle() => atan2(x, y);

  Offset off() => Offset(x, y);

  Vector operator +(Vector other) => Vector(other.x + x, other.y + y);

  Vector operator *(double scale) => Vector(x * scale, y * scale);

  Vector operator -(Vector other) => Vector(x, y) + other * (-1);

  @override
  String toString() =>
      '(' + x.toStringAsFixed(1) + ', ' + y.toStringAsFixed(1) + ')';
}
