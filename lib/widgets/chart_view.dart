import 'package:flutter/material.dart';
import '../models/chart_one.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../models/chart_item_one.dart';

class ChartView extends StatelessWidget {
  const ChartView({Key key, @required this.chartOne, this.showSubtitle = true})
      : super(key: key);

  final ChartOne chartOne;
  final bool showSubtitle;

  Widget returnChart() {
    List<charts.Series<ItemChart, String>> _seriesData = [];
    List<charts.Series<ItemChart, int>> _seriesListData = [];

    _seriesData.add(charts.Series<ItemChart, String>(
      domainFn: (ItemChart x, _) => x.name,
      measureFn: (ItemChart x, _) => x.value,
      id: chartOne.title,
      colorFn: (ItemChart x, _) => charts.ColorUtil.fromDartColor(x.color),
      data: chartOne.values,
      labelAccessorFn: (ItemChart row, _) => showSubtitle ? '${row.value}' : '',
    ));

    if (chartOne.type == 0) {
      return new charts.BarChart(_seriesData,
          animate: showSubtitle,
          barGroupingType: charts.BarGroupingType.grouped,
          animationDuration: Duration(seconds: 2),
          barRendererDecorator: new charts.BarLabelDecorator<String>(
              labelPosition: charts.BarLabelPosition.inside),
          primaryMeasureAxis: new charts.NumericAxisSpec(
              renderSpec: new charts.GridlineRendererSpec(
                  // Tick and Label styling here.
                  labelStyle: new charts.TextStyleSpec(
                      fontSize: showSubtitle ? 18 : 0, // size in Pts.
                      color: charts.MaterialPalette.black),

                  // Change the line colors to match text color.
                  lineStyle: new charts.LineStyleSpec(
                      color: showSubtitle
                          ? charts.MaterialPalette.black
                          : charts.MaterialPalette.transparent))),
          domainAxis: new charts.OrdinalAxisSpec(
              showAxisLine: true,
              renderSpec: showSubtitle
                  ? charts.SmallTickRendererSpec(
                      minimumPaddingBetweenLabelsPx: 0,
                      labelStyle: charts.TextStyleSpec(
                          fontSize: 14, color: charts.MaterialPalette.black))
                  : new charts.NoneRenderSpec()));
    } else if (chartOne.type == 1) {
      return new charts.PieChart(_seriesData,
          animate: showSubtitle,
          animationDuration: Duration(seconds: 2),
          behaviors: [
            if (showSubtitle)
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
    } else {
      _seriesListData.add(charts.Series<ItemChart, int>(
        domainFn: (ItemChart x, _) => x.name,
        measureFn: (ItemChart x, _) => x.value,
        id: chartOne.title,
        colorFn: (ItemChart x, _) => charts.ColorUtil.fromDartColor(x.color),
        data: chartOne.values,
        labelAccessorFn: (ItemChart row, _) =>
            showSubtitle ? '${row.value}' : '',
      ));

      return new charts.LineChart(
        _seriesListData,
        animate: showSubtitle,
        defaultRenderer:
            new charts.LineRendererConfig(includeArea: true, stacked: true),
        animationDuration: Duration(seconds: 2),
        domainAxis: charts.NumericAxisSpec(
            showAxisLine: true,
            renderSpec: new charts.SmallTickRendererSpec(
              labelStyle: new charts.TextStyleSpec(
                  fontSize: showSubtitle ? 18 : 0, // size in Pts.
                  color: charts.MaterialPalette.black),
              lineStyle: new charts.LineStyleSpec(
                  color: showSubtitle
                      ? charts.MaterialPalette.black
                      : charts.MaterialPalette.transparent),
            )),
        primaryMeasureAxis: charts.NumericAxisSpec(
            renderSpec: new charts.SmallTickRendererSpec(
          labelStyle: new charts.TextStyleSpec(
              fontSize: showSubtitle ? 18 : 0, // size in Pts.
              color: charts.MaterialPalette.black),
          lineStyle: new charts.LineStyleSpec(
              color: showSubtitle
                  ? charts.MaterialPalette.black
                  : charts.MaterialPalette.transparent),
        )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return returnChart();
  }
}
