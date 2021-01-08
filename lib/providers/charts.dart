import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import '../models/chart_one.dart';

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

  bool findExistingItem(int categoryId, String title) {
    return _items
        .where((item) => item.type == categoryId)
        .contains((element) => {element.title = title});
  }

  Future<void> addChart(ChartOne item) async {
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
        print('Erro achado');
        throw HttpException(responseData['error']);
      }

      final itemFull = ChartOne(
          title: item.title,
          values: item.values,
          type: item.type,
          id: responseData['id']);

      _items.add(itemFull);

      notifyListeners();
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

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _items = responseData;

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
        throw HttpException(responseData['error']['message']);
      }

      _items.removeWhere((item) => item.id == id);

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
