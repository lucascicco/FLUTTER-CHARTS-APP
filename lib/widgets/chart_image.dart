import 'package:flutter/material.dart';
import '../models/chart_one.dart';
import '../widgets/chart_view.dart';

class ChartShow extends StatelessWidget {
  const ChartShow({Key key, this.chartOne}) : super(key: key);

  final ChartOne chartOne;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Text(chartOne.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Georgia',
                          fontWeight: FontWeight.bold,
                          fontSize: 25)),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(child: ChartView(chartOne: chartOne))
          ],
        ),
      );
    });
  }
}
