import 'package:flutter/material.dart';
import 'package:pendulum/models/vector.dart';
import 'dart:math';

class Pendulum {
  double length = 0;
  double angle = 0;
  double angularVelocity = 0;
  double angularAcceleration = 0;

  Pendulum(this.length, this.angle);

  Pendulum.vector(Vector position) {
    length = position.distance();
    angle = position.angle();
  }

  Vector position() => Vector.polar(length, angle);

  Vector velocity() =>
      Vector(length * cos(angle), -length * sin(angle)) * angularVelocity;

  Offset offset() => position().off();

  double angDegree() => angle * 180 / pi;

  double velDegree() => angularVelocity * 180 / pi;

  void update(double acceleration) {
    angularAcceleration = acceleration;
    angularVelocity += angularAcceleration;
    angle += angularVelocity;
  }
}
