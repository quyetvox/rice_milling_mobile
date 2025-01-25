import 'dart:convert';
import 'package:rice_milling_mobile/domain/configs/app_config.dart';
import 'package:rice_milling_mobile/domain/network/api_request/api_platform.dart';
import 'package:flutter/foundation.dart';

class ApiBusiness {
  static Future<List<dynamic>> businessSettings() async {
    try {
      String url = ('${AppConfig.BASE_URL}/business_setting');
      final response = await ApiRequest.get(url: url);
      if (response.statusCode == 200) {
        return json.decode(response.body)['data'] ?? [];
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print("ApiBusiness businessSettings error: $e");
      }
      return [];
    }
  }

  static Future<List<dynamic>> businessLocations() async {
    try {
      String url = ('${AppConfig.BASE_URL}/business_location');
      final response = await ApiRequest.get(url: url);
      if (response.statusCode == 200) {
        return json.decode(response.body)['data'] ?? [];
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print("ApiBusiness businessSettings error: $e");
      }
      return [];
    }
  }
}
