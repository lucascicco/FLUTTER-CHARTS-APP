import 'dart:convert';
import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import '../models/chart_one.dart';
import '../models/chart_item_one.dart';

import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Charts with ChangeNotifier {
  List<ChartOne> _items = [];

  String authToken;

  List get items {
    return _items;
  }

  void receiveToken(String token) {
    authToken = token;
  }

  List findByCategory(int categoryId) {
    return _items.where((item) => item.type == categoryId).toList();
  }

  List<ChartOne> filteredItems(int categoryId, String inputText) {
    print(inputText);
    print(categoryId);

    List<ChartOne> byText =
        _items.where((x) => x.title.contains(inputText.toUpperCase())).toList();

    print(byText.length);

    return categoryId != 2
        ? byText.where((x) => x.type == categoryId).toList()
        : byText;
  }

  bool findExistingItem(int categoryId, String title) {
    return _items
        .where((item) => item.type == categoryId)
        .contains((element) => {element.title == title});
  }

  Future<ChartOne> addChart(ChartOne item) async {
    final url = 'http://192.168.15.33:3000/create-charts';

    var valuesEncoded = item.values.map((e) => e.toJson()).toList();

    var bodyEncoded = json.encode({
      'title': item.title,
      'type': item.type,
      'values': valuesEncoded,
    });

    try {
      final response = await http.post(url, body: bodyEncoded, headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken',
      });

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      }

      final itemFull = ChartOne(
          title: item.title,
          values: item.values,
          type: item.type,
          id: responseData['_id']);

      _items.add(itemFull);

      notifyListeners();

      return itemFull;
    } catch (e) {
      throw e;
    }
  }

  Future<void> getAllCharts() async {
    final url = 'http://192.168.15.33:3000/charts';

    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken',
      });

      final responseData = json.decode(response.body);

      List<ChartOne> loadedCharts = [];

      if (responseData.length > 0) {
        responseData.forEach((element) {
          List<ItemChart> values = [];

          element['values'].forEach((e) {
            values.add(ItemChart(
                name: e['name'],
                color: new Color(e['color']),
                value: double.parse(e['value'].toString())));
          });

          loadedCharts.add(ChartOne(
            id: element['_id'],
            title: element['title'],
            type: element['type'],
            values: values,
          ));
        });
      }

      _items = loadedCharts;

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteChart(String id) async {
    final url = "http://192.168.15.33:3000/delete-chart/$id";

    try {
      final response = await http.delete(url, headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $authToken'
      });

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      }

      _items.removeWhere((item) => item.id == id);

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
