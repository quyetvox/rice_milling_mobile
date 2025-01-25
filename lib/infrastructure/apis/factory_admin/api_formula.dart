import 'dart:convert';

import 'package:rice_milling_mobile/domain/configs/app_config.dart';
import 'package:rice_milling_mobile/domain/network/api_request/api_platform.dart';
import 'package:flutter/foundation.dart';

class ApiFormula {
  static Future<List<dynamic>> formulas() async {
    try {
      String url = ('${AppConfig.BASE_URL}/formula');
      final response = await ApiRequest.get(url: url);
      if (response.statusCode == 200) {
        return json.decode(response.body)['data'] ?? [];
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print("ApiFormula formula error: $e");
      }
      return [];
    }
  }

  static Future<bool> insert(Map<String, dynamic> body) async {
    try {
      String url = ('${AppConfig.BASE_URL}/formula');
      final response = await ApiRequest.post(url: url, body: jsonEncode(body));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("ApiFormula insert error: $e");
      }
      return false;
    }
  }

  static Future<bool> update(Map<String, dynamic> body, String id) async {
    try {
      String url = ('${AppConfig.BASE_URL}/formula/$id');
      final response = await ApiRequest.post(url: url, body: jsonEncode(body));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("ApiFormula update error: $e");
      }
      return false;
    }
  }

  static Future<List<dynamic>> formulaIngredients(String id) async {
    try {
      String url = ('${AppConfig.BASE_URL}/formula_ingredient?formula_id=$id');
      final response = await ApiRequest.get(url: url);
      if (response.statusCode == 200) {
        return json.decode(response.body)['data'] ?? [];
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print("ApiFormula formulaIngredients error: $e");
      }
      return [];
    }
  }

  static Future<bool> updateFormulaIngredient(Map<String, dynamic> body, String id) async {
    try {
      print(body);
      String url = ('${AppConfig.BASE_URL}/formula_ingredient/$id');
      final response = await ApiRequest.post(url: url, body: jsonEncode(body));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("ApiFormula updateFormulaIngredient error: $e");
      }
      return false;
    }
  }

  static Future<List<dynamic>> fetchListToCreateProductionPlanning() async {
    try {
      String url = ('${AppConfig.BASE_URL}/listing/formulas');
      final response = await ApiRequest.get(url: url);
      if (response.statusCode == 200) {
        return json.decode(response.body)['data'] ?? [];
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print("ApiFormula formula error: $e");
      }
      return [];
    }
  }
}
