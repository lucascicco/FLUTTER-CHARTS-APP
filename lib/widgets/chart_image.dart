import 'package:flutter/material.dart';
import '../models/chart_one.dart';
import '../widgets/chart_view.dart';

class ChartShow extends StatelessWidget {
  const ChartShow({Key key, this.chartOne}) : super(key: key);

  final ChartOne chartOne;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent),
          ),
          child: Column(
            children: <Widget>[
              Text(chartOne.title,
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Expanded(child: ChartView(chartOne: chartOne))
            ],
          ),
        ),
      );
    });
  }
}
