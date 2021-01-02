import 'package:flutter/material.dart';

class ListCharts extends StatefulWidget {
  ListCharts({Key key}) : super(key: key);

  static const routeName = '/list-charts';

  @override
  _ListChartsState createState() => _ListChartsState();
}

class _ListChartsState extends State<ListCharts> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: deviceSize.height,
        width: deviceSize.width,
        child: Center(
          child: Text('ChartList'),
        ),
      ),
    );
  }
}
