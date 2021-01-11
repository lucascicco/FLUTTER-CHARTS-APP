import 'package:flutter/material.dart';

class ItemChart {
  final String name;
  final Color color;
  final double value;

  ItemChart({@required this.name, @required this.color, @required this.value});

  toJson() {
    return {'name': name, 'color': color.value.toString(), 'value': value};
  }
}
