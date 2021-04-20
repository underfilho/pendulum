import 'package:pendulum/pendulum.dart';
import 'package:flutter/material.dart';
import 'package:pendulum/vector.dart';

class Workspace extends StatelessWidget {
  final List<Pendulum> pendulums;
  final bool velocity;
  final Vector center;

  Workspace(this.pendulums, this.center, {this.velocity = false});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WorkspacePainter(pendulums, center, velocity),
      child: Container(
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}

class WorkspacePainter extends CustomPainter {
  final List<Pendulum> pendulums;
  final bool velocity;
  final Vector center;

  WorkspacePainter(this.pendulums, this.center, this.velocity);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(center.x, center.y);
    Paint pencil = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;
    Paint base = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 4
      ..color = Colors.black;
    Paint redpen = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.red;

    canvas.drawLine(Offset(-15, 0), Offset(15, 0), base);

    for (var pendulum in pendulums) {
      if (pendulum != null) {
        canvas.drawLine(Vector(0, 0).off(), pendulum.offset(), pencil);
        canvas.drawCircle(pendulum.offset(), 8, pencil);
        if (velocity) {
          Vector velocity = pendulum.position() + pendulum.velocity() * 3;
          canvas.drawLine(pendulum.offset(), velocity.off(), redpen);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
