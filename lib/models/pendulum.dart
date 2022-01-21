import 'package:flutter/material.dart';
import 'package:pendulum/main.dart';
import 'package:pendulum/models/vector.dart';
import 'dart:math';

class Pendulum {
  double length = 0;
  double angle = 0;
  double angularVelocity = 0;
  double angularAcceleration = 0;

  Pendulum(this.length, this.angle);

  Pendulum.vector(Vector position) {
    length = position.distance() / scale;
    angle = position.angle();
  }

  Vector position() => Vector.polar(length, angle);

  Vector velocity() =>
      Vector(length * cos(angle), -length * sin(angle)) * angularVelocity;

  Offset offset() => position().off();

  double angDegree() => angle * 180 / pi;

  double velDegree() => angularVelocity * 180 / pi;

  double kineticEnergy() => 0.5 * pow(angularVelocity * length, 2);

  double potentialEnergy() => (length - position().y) * G;

  double totalEnergy() => kineticEnergy() + potentialEnergy();

  // Actually using Verlet integration method
  void update(double Function() newAcceleration, double dt) {
    angle += angularVelocity * dt + angularAcceleration / 2 * pow(dt, 2);
    final a0 = angularAcceleration;
    angularAcceleration = newAcceleration();
    angularVelocity += (angularAcceleration + a0) / 2 * dt;
  }
}
