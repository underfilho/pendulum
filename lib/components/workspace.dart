import 'package:flutter/material.dart';
import 'package:pendulum/models/models.dart';
import 'package:pendulum/components/workspace_painter.dart';

class Workspace extends StatelessWidget {
  final List<Pendulum> pendulums;
  final int selected;
  final Vector center;

  Workspace(this.pendulums, this.center, this.selected);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WorkspacePainter(pendulums, center, selected),
      child: Container(
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
