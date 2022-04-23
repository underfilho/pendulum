import 'package:flutter/material.dart';

class EnergyIndicator extends StatefulWidget {
  final double leftValue;
  final double rightValue;
  final Color leftColor;
  final Color rightColor;

  EnergyIndicator({
    Key key,
    @required this.leftValue,
    @required this.rightValue,
    this.leftColor = Colors.red,
    this.rightColor = Colors.lightGreen,
  }) : super(key: key);

  @override
  _EnergyIndicatorState createState() => _EnergyIndicatorState();
}

class _EnergyIndicatorState extends State<EnergyIndicator> {
  String get totalEnergy =>
      (widget.leftValue + widget.rightValue).toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            Row(
              children: [
                Container(
                  width: calculatePercentage(widget.leftValue) *
                      constraints.maxWidth,
                  color: widget.leftColor,
                ),
                Container(
                  width: calculatePercentage(widget.rightValue) *
                      constraints.maxWidth,
                  color: widget.rightColor,
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                totalEnergy,
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ],
        );
      }),
    );
  }

  double calculatePercentage(double value) {
    final total = widget.leftValue + widget.rightValue;

    return value / total;
  }
}
