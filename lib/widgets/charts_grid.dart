import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/charts.dart';
import '../models/chart_one.dart';
import '../screens/show_chart.dart';
import '../widgets/chart_view.dart';

class ChartsGrid extends StatelessWidget {
  ChartsGrid({Key key, this.categoryId, this.textFilter}) : super(key: key);

  int categoryId;
  String textFilter;

  @override
  Widget build(BuildContext context) {
    final charts = Provider.of<Charts>(context);
    final arrayCharts = charts.filteredItems(categoryId, textFilter);

    Widget chartItem(ChartOne item) {
      return Card(
        elevation: 8.0,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return ShowChart(chartOne: item); //a screen
            }));
          },
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(item.title),
                Expanded(
                  child: ChartView(chartOne: item, showSubtitle: false),
                )
              ],
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(builder: (ctx, constraints) {
      return GridView.builder(
          padding: const EdgeInsets.all(10.0),
          shrinkWrap: true,
          itemCount: arrayCharts.length,
          itemBuilder: (ctx, i) {
            return chartItem(arrayCharts[i]);
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ));
    });
  }
}
