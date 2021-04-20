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

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> curve;
  List<Pendulum> pendulums = [];
  Vector center = Vector(0, 0);
  bool velocity = false;
  bool play = true;
  Pendulum temp;
  int selected = -1;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    curve = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    timer();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pêndulo',
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
                      child: Workspace(pendulums + [temp], center, selected,
                          velocity: velocity),
                    );
                  },
                ),
                Positioned(
                  right: 10,
                  top: 20,
                  child: InkWell(
                    onTap: () => controller.forward(),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.menu),
                    ),
                  ),
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
                Builder(builder: (_) {
                  double width = MediaQuery.of(_).size.width;

                  return Transform.translate(
                    offset: Offset(width - curve.value * width * 0.45, 0),
                    child: Container(
                      width: width * 0.45,
                      color: Colors.blue.withOpacity(0.9),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () async {
                                await controller.reverse();
                                selected = -1;
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Icon(Icons.chevron_left),
                              ),
                            ),
                          ),
                          Container(
                            child: Text("Pêndulos",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w500)),
                          ),
                          SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: pendulums.length,
                            itemBuilder: (_, id) {
                              return (id == selected)
                                  ? pendulumInfo(id)
                                  : pendulumOption(id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget pendulumOption(int id) {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 5),
      child: Row(
        children: <Widget>[
          Text("Pêndulo ${id + 1}",
              style: TextStyle(fontWeight: FontWeight.w500)),
          Spacer(),
          InkWell(
            onTap: () => setState(() => selected = id),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.keyboard_arrow_down, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget pendulumInfo(int id) {
    Pendulum pendulum = pendulums[id];

    return Container(
      margin: EdgeInsets.only(left: 20, top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("Pêndulo ${id + 1}",
                  style: TextStyle(fontWeight: FontWeight.w500)),
              Spacer(),
              InkWell(
                onTap: () => setState(() => selected = -1),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.keyboard_arrow_up, size: 20),
                ),
              ),
            ],
          ),
          Text("Posição: ${pendulum.position()}"),
          Text("Ângulo: ${pendulum.angDegree().toStringAsFixed(0)}º"),
          Text("Velocidade: ${pendulum.velocity()}"),
          Text(
              "Velocidade angular: ${pendulum.velDegree().toStringAsFixed(0)}º/s"),
          SizedBox(height: 10),
          InkWell(
            onTap: () => setState(() {
              pendulums.removeAt(id);
              selected = -1;
            }),
            child: Row(
              children: <Widget>[
                Icon(Icons.delete, size: 18),
                SizedBox(width: 2),
                Text("Apagar"),
              ],
            ),
          ),
        ],
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
