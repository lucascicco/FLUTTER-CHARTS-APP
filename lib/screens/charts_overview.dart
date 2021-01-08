import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../widgets/app_drawer.dart';
import '../screens/add_chart_screen.dart';
import '../widgets/search_widget.dart';
import '../providers/charts.dart';

class ChartOverview extends StatefulWidget {
  ChartOverview({Key key}) : super(key: key);

  @override
  _ChartOverviewState createState() => _ChartOverviewState();
}

class _ChartOverviewState extends State<ChartOverview> {
  Future<void> logout() async {
    await Provider.of<Auth>(context, listen: false).logout();
  }

  List<String> chartsList = <String>[
    'Sem filtro',
    'Barras',
    'Linhas',
    'Pizza',
  ];

  String filterCategory;

  void setFilter(String filter) {
    setState(() {
      filterCategory = filter;
    });

    //;
  }

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Charts>(context).getAllCharts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
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
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        child: Column(
          children: <Widget>[
            SearchChartWidget(
                filterSet: setFilter,
                chartsList: chartsList,
                selectedItem: filterCategory)
          ],
        ),
      ),
    );
  }
}
