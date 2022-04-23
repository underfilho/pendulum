import 'package:flutter/material.dart';
import 'package:pendulum/models/pendulum.dart';

import 'energy_indicator.dart';

class LateralMenu extends StatefulWidget {
  final List<Pendulum> pendulums;
  final void Function() onTap;
  final void Function(int id) onSelected;

  const LateralMenu(
      {Key key, @required this.pendulums, this.onTap, this.onSelected})
      : super(key: key);

  @override
  State<LateralMenu> createState() => _LateralMenuState();
}

class _LateralMenuState extends State<LateralMenu> {
  int selected = -1;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.45,
      color: Colors.blue.withOpacity(0.9),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: widget.onTap,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.chevron_left),
              ),
            ),
          ),
          Container(
            child: Text("Pêndulos",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
          ),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.pendulums.length,
            itemBuilder: (_, id) {
              return (id == selected) ? pendulumInfo(id) : pendulumOption(id);
            },
          ),
        ],
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
            onTap: () {
              setState(() => selected = id);
              widget.onSelected(id);
            },
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
    Pendulum pendulum = widget.pendulums[id];

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
                onTap: () {
                  setState(() => selected = -1);
                  widget.onSelected(-1);
                },
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
          Text("Energia potencial e cinética:"),
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 5, bottom: 10),
            child: EnergyIndicator(
              leftValue: pendulum.potentialEnergy(),
              rightValue: pendulum.kineticEnergy(),
            ),
          ),
          InkWell(
            onTap: () {
              widget.pendulums.removeAt(id);
              setState(() => selected = -1);
              widget.onSelected(-1);
            },
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
}
