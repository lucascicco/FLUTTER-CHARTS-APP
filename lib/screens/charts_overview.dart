import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../widgets/app_drawer.dart';
import '../screens/add_chart_screen.dart';
import '../widgets/search_widget.dart';
import '../providers/charts.dart';
import '../widgets/charts_grid.dart';

class ChartOverview extends StatefulWidget {
  ChartOverview({Key key}) : super(key: key);

  @override
  _ChartOverviewState createState() => _ChartOverviewState();
}

class _ChartOverviewState extends State<ChartOverview> {
  var _isInit = true;
  var _isLoading = false;

  List<String> chartsList = <String>[
    'Barras',
    'Pizza',
  ];

  String filterCategory = '';
  String textFilter = '';

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

  Future<void> logout() async {
    await Provider.of<Auth>(context, listen: false).logout();
  }

  int get categoryId {
    return filterCategory.length > 0 ? chartsList.indexOf(filterCategory) : 3;
  }

  void setFilter(String filter) {
    setState(() {
      filterCategory = filter;
    });
  }

  void setText(String text) {
    setState(() {
      textFilter = text;
    });
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
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  SearchChartWidget(
                      filterSet: setFilter,
                      chartsList: chartsList,
                      selectedItem: filterCategory,
                      setText: setText,
                      filterCategory: filterCategory),
                  Expanded(
                      child: ChartsGrid(
                          categoryId: categoryId, textFilter: textFilter))
                ],
              ),
      ),
    );
  }
}
