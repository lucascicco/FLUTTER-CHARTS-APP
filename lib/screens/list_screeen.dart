import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import '../screens/add_chart_screen.dart';

import '../widgets/chart_list.dart';

class ListCharts extends StatelessWidget {
  static const routeName = '/list-charts';

  const ListCharts({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(AddChart.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Container(child: ChartList()),
    );
  }
}
