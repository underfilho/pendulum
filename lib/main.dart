import 'package:flutter/material.dart';
import 'package:pendulum/vector.dart';
import 'package:pendulum/pendulum.dart';
import 'package:pendulum/workspace.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Pendulum> pendulums = [];
  Vector center = Vector(0, 0);
  bool velocity = false;
  bool play = true;
  Pendulum temp;

  @override
  void initState() {
    super.initState();
    timer();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MaterialApp(
        home: Scaffold(
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                LayoutBuilder(
                  builder: (context, size) {
                    center = Vector(size.maxWidth / 2, size.maxHeight / 5);

                    return GestureDetector(
                      onPanStart: (touch) {
                        var position = coord(touch.globalPosition);
                        setState(() => temp = Pendulum.vector(position));
                      },
                      onPanUpdate: (drag) {
                        var position = coord(drag.globalPosition);
                        setState(() => temp = Pendulum.vector(position));
                      },
                      onPanEnd: (release) => setState(() {
                        pendulums.add(temp);
                        temp = null;
                      }),
                      child: Workspace(pendulums + [temp], center,
                          velocity: velocity),
                    );
                  },
                ),
                Positioned(
                  left: 10,
                  top: 20,
                  child: InkWell(
                    onTap: () {
                      if (play)
                        play = false;
                      else {
                        play = true;
                        timer();
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Icon(play ? Icons.pause : Icons.play_arrow),
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  bottom: 30,
                  child: InkWell(
                    onTap: () => setState(() => pendulums.clear()),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child:
                          Text("Apagar tudo", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 30,
                  child: InkWell(
                    onTap: () => velocity = !velocity,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                          !velocity
                              ? "Mostrar velocidades"
                              : "Ocultar velocidades",
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Vector coord(Offset position) => Vector(position.dx, position.dy) - center;

  void timer() {
    Future.delayed(Duration(milliseconds: 20)).then((_) {
      setState(() {
        for (var pendulum in pendulums)
          pendulum.update(-1 * sin(pendulum.angle) / pendulum.length);
      });

      if (play) timer();
    });
  }
}
