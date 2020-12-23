import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

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
      body: Container(
        child: Center(
          child: ElevatedButton(child: Text('Logout'), onPressed: logout),
        ),
      ),
    );
  }
}
