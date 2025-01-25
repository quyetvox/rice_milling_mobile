import 'dart:convert';

import 'package:rice_milling_mobile/domain/configs/app_config.dart';
import 'package:rice_milling_mobile/domain/network/api_request/api_platform.dart';
import 'package:flutter/foundation.dart';

class ApiProduct {
  static Future<List<dynamic>> products() async {
    try {
      String url = ('${AppConfig.BASE_URL}/product');
      final response = await ApiRequest.get(url: url);
      if (response.statusCode == 200) {
        return json.decode(response.body)['data'] ?? [];
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print("ApiProduct products error: $e");
      }
      return [];
    }
  }

  static Future<dynamic> fetchById(int id) async {
    try {
      String url = ('${AppConfig.BASE_URL}/product/$id');
      final response = await ApiRequest.get(url: url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("ApiProduct product error: $e");
      }
      return null;
    }
  }
}
