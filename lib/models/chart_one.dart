import 'package:flutter/material.dart';
import './chart_item_one.dart';

class ChartOne {
  final String id;
  final String title;
  final int type;
  final List<ItemChart> values;

  ChartOne(
      {@required this.title,
      @required this.values,
      @required this.type,
      this.id});
}
