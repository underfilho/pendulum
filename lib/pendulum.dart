import 'package:flutter/material.dart';
import 'package:pendulum/vector.dart';
import 'dart:math';

class Pendulum {
  double length = 0;
  double angle = 0;
  double angle_ = 0; //angular velocity
  double angle__ = 0; //angular acceleration

  Pendulum(this.length, this.angle);

  Pendulum.vector(Vector position) {
    length = position.distance();
    angle = position.angle();
  }

  Vector position() => Vector.polar(length, angle);
  Vector velocity() =>
      Vector(length * cos(angle), -length * sin(angle)) * angle_;

  Offset offset() => position().off();

  void update(double acceleration) {
    angle__ = acceleration;
    angle_ += angle__;
    angle += angle_;
  }

  @override
  String toString() => "(" + length.toString() + ", " + angle.toString() + ")";
}
