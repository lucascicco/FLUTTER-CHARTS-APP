import 'package:flutter/material.dart';

import '../models/chart_item_one.dart';
import '../models/chart_one.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class ChartShow extends StatelessWidget {
  const ChartShow({Key key, this.chartOne}) : super(key: key);

  final ChartOne chartOne;

  Widget returnChart() {
    List _seriesData;

    _seriesData.add(charts.Series<ItemChart, String>(
      domainFn: (ItemChart x, _) => x.name,
      measureFn: (ItemChart x, _) => x.value,
      id: chartOne.title,
      colorFn: (ItemChart x, _) => charts.ColorUtil.fromDartColor(x.color),
      data: chartOne.values,
      labelAccessorFn: (ItemChart row, _) => '${row.value}',
    ));

    if (chartOne.type == 0) {
      return charts.BarChart(
        _seriesData,
        animate: true,
        barGroupingType: charts.BarGroupingType.grouped,
        animationDuration: Duration(seconds: 5),
      );
    } else if (chartOne.type == 1) {
      return charts.LineChart(
        _seriesData,
        defaultRenderer:
            new charts.LineRendererConfig(includeArea: true, stacked: true),
        animate: true,
        animationDuration: Duration(seconds: 5),
      );
    } else {
      return charts.PieChart(_seriesData,
          animate: true,
          animationDuration: Duration(seconds: 5),
          behaviors: [
            new charts.DatumLegend(
              outsideJustification: charts.OutsideJustification.endDrawArea,
              horizontalFirst: false,
              desiredMaxRows: 2,
              cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
              entryTextStyle: charts.TextStyleSpec(
                  color: charts.MaterialPalette.purple.shadeDefault,
                  fontFamily: 'Georgia',
                  fontSize: 11),
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
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent),
              gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment(-0.4, -0.8),
                  stops: [0.0, 0.5, 0.5, 1],
                  colors: [
                    Colors.blueGrey,
                    Colors.blueGrey,
                    Colors.white,
                    Colors.white,
                  ],
                  tileMode: TileMode.repeated)),
          child: Column(
            children: <Widget>[Expanded(child: returnChart())],
          ),
        ),
      );
    });
  }
}
