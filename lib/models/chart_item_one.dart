import 'package:flutter/material.dart';

class ItemChart {
  final name;
  final Color color;
  final value;

  ItemChart({@required this.name, @required this.color, @required this.value});

  toJson() {
    return {'name': name, 'color': color.value, 'value': value};
  }
}
