import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadListCategoria extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int offset = 0;
    int time = 800;

    return SafeArea(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (BuildContext context, int index) {
          offset += 5;
          time = 800 + offset;

          print(time);

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Shimmer.fromColors(
              highlightColor: Colors.white,
              baseColor: Colors.grey[300],
              child: ShimmerLayoutProduto(),
              period: Duration(milliseconds: time),
            ),
          );
        },
      ),
    );
  }
}

class ShimmerLayoutProduto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double containerWidth = 100;
    double containerHeight = 20;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
//          Container(
//            height: 110,
//            width: 110,
//            color: Colors.grey,
//          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 80,
                width: containerWidth,
                color: Colors.grey,
              ),
              SizedBox(height: 1),
              Container(
                height: 30,
                width: containerWidth,
                color: Colors.grey,
              ),
            ],
          )
        ],
      ),
    );
  }
}
