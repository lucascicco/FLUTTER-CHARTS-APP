import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import '../models/chart_one.dart';

import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Charts with ChangeNotifier {
  List _items = [];

  List get items {
    return _items;
  }

  List findByCategory(int categoryId) {
    return _items.where((item) => item.type == categoryId);
  }

  findItemCategory(String id) {
    return _items.where((item) => item.id == id);
  }

  Future<void> addChart(ChartOne item) async {
    final url = 'http://192.168.15.33:3000/create-charts';

    var bodyEncoded = json.encode(
        {'type': item.type, 'title': item.title, 'values': item.values});

    try {
      final response = await http.post(url,
          body: bodyEncoded, headers: {"Content-Type": "application/json"});

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _items.add(responseData);

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> getAllCharts() async {
    final url = 'http://192.168.15.33:3000/charts';

    try {
      final response = await http.get(url);

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
      final response =
          await http.delete(url, headers: {"Content-Type": "application/json"});

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
