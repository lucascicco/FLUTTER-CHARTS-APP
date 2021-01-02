import 'package:flutter/cupertino.dart';
import '../models/chart_one.dart';

class Charts with ChangeNotifier {
  Map _items = {0: [], 1: [], 2: []};

  Map get items {
    return _items;
  }

  List findByCategory(int categoryId) {
    return _items[categoryId];
  }

  findItemCategory(int categoryId, String title) {
    return _items[categoryId].where((item) => item.title == title);
  }

  addChart(int categoryId, ChartOne item) {
    _items[categoryId].push(item);
  }
}
