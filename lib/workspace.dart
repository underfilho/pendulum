import 'package:flutter/material.dart';
import 'package:pendulum/models/models.dart';
import 'package:pendulum/workspace_painter.dart';

class Workspace extends StatelessWidget {
  final List<Pendulum> pendulums;
  final bool velocity;
  final int selected;
  final Vector center;

  Workspace(this.pendulums, this.center, this.selected,
      {this.velocity = false});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WorkspacePainter(pendulums, center, selected, velocity),
      child: Container(
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
