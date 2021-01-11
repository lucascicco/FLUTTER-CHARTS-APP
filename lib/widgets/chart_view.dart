import 'package:flutter/material.dart';
import '../models/chart_one.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../models/chart_item_one.dart';

class ChartView extends StatelessWidget {
  const ChartView({Key key, @required this.chartOne}) : super(key: key);

  final ChartOne chartOne;

  Widget returnChart() {
    List<charts.Series<ItemChart, String>> _seriesData = [];

    _seriesData.add(charts.Series<ItemChart, String>(
      domainFn: (ItemChart x, _) => x.name,
      measureFn: (ItemChart x, _) => x.value,
      id: chartOne.title,
      colorFn: (ItemChart x, _) => charts.ColorUtil.fromDartColor(x.color),
      data: chartOne.values,
      labelAccessorFn: (ItemChart row, _) => '${row.value}',
    ));

    if (chartOne.type == 0) {
      return new charts.BarChart(
        _seriesData,
        animate: true,
        barGroupingType: charts.BarGroupingType.grouped,
        animationDuration: Duration(seconds: 2),
      );
    } else {
      return new charts.PieChart(_seriesData,
          animate: true,
          animationDuration: Duration(seconds: 2),
          behaviors: [
            new charts.DatumLegend(
              outsideJustification: charts.OutsideJustification.endDrawArea,
              horizontalFirst: false,
              desiredMaxRows: 2,
              cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
              entryTextStyle: charts.TextStyleSpec(
                  color: charts.MaterialPalette.black,
                  fontFamily: 'Georgia',
                  fontSize: 15),
            )
          ],
          defaultRenderer: new charts.ArcRendererConfig(
              arcWidth: 100,
              arcRendererDecorators: [
                new charts.ArcLabelDecorator(
                    labelPosition: charts.ArcLabelPosition.inside)
              ]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return returnChart();
  }
}
