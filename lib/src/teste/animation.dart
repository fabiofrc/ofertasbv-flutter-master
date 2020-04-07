import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StarAnimation extends StatefulWidget {
  @override
  State createState() {
    return StarState();
  }
}

class StarState extends State with SingleTickerProviderStateMixin {
  AnimationController _ac;
  final double _starSize = 300.0;

  @override
  void initState() {
    super.initState();

    _ac = new AnimationController(
      duration: Duration(milliseconds: 750),
      vsync: this,
    );
    _ac.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
        animation: _ac,
        builder: (BuildContext context, Widget child) {
          return DecoratedBox(
            child: Icon(Icons.stars, size: _ac.value * _starSize),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.indigo[700], Colors.deepPurple[400],],
                  tileMode: TileMode.mirror),
            ),
          );
        });
  }
}
