import 'package:flutter/material.dart';
import '../widgets/chart_image.dart';
import '../models/chart_one.dart';

class ShowChart extends StatelessWidget {
  const ShowChart({Key key, this.chartOne}) : super(key: key);

  final ChartOne chartOne;

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Colors.blueGrey,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/');
        },
      ),
    );

    return Scaffold(appBar: appBar, body: ChartShow(chartOne: chartOne));
  }
}
