import 'dart:convert';
import 'package:rice_milling_mobile/domain/configs/app_config.dart';
import 'package:rice_milling_mobile/domain/network/api_request/api_platform.dart';
import 'package:flutter/foundation.dart';

class ApiUom {
  static Future<List<dynamic>> uoms() async {
    try {
      String url = ('${AppConfig.BASE_URL}/uom');
      final response = await ApiRequest.get(url: url);
      if (response.statusCode == 200) {
        return json.decode(response.body)['data'] ?? [];
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print("ApiUom uoms error: $e");
      }
      return [];
    }
  }
}