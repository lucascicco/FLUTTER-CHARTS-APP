import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../widgets/app_drawer.dart';
import '../screens/add_chart_screen.dart';

class ChartOverview extends StatefulWidget {
  ChartOverview({Key key}) : super(key: key);

  @override
  _ChartOverviewState createState() => _ChartOverviewState();
}

class _ChartOverviewState extends State<ChartOverview> {
  Future<void> logout() async {
    await Provider.of<Auth>(context, listen: false).logout();
  }

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
      body: Container(
        child: Center(child: Text('go!')),
      ),
    );
  }
}
