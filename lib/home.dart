import 'package:flutter/material.dart';
import 'components/lateral_menu.dart';
import 'components/workspace.dart';
import 'utils/const.dart';
import 'models/pendulum.dart';
import 'models/vector.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> curve;
  List<Pendulum> pendulums = [];
  Vector center = Vector(0, 0);
  bool play = true;
  Pendulum temp;
  int selected = -1;
  double dt = ms / 1000;
  double drag = 0;

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
    return Scaffold(
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
                  child: Workspace(pendulums + [temp], center, selected),
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
                  play = !play;
                  if (play) timer();
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
                  child: Text("Apagar tudo", style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 30,
              child: InkWell(
                onTap: toogleAirResistance,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                      !airResistance
                          ? "Ativar resistência do ar"
                          : "Ignorar resistência do ar",
                      style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
            Builder(builder: (_) {
              double width = MediaQuery.of(_).size.width;

              return Transform.translate(
                offset: Offset(width - curve.value * width * 0.45, 0),
                child: LateralMenu(
                  pendulums: pendulums,
                  onSelected: (id) => setState(() => selected = id),
                  onTap: () async {
                    await controller.reverse();
                    selected = -1;
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Vector coord(Offset position) => Vector(position.dx, position.dy) - center;

  bool get airResistance => drag != 0;

  void toogleAirResistance() => drag = airResistance ? 0 : 0.3;

  void timer() {
    Future.delayed(Duration(milliseconds: ms)).then((_) {
      setState(() {
        for (var pendulum in pendulums) pendulum.update(drag, dt);
      });

      if (play) timer();
    });
  }
}
