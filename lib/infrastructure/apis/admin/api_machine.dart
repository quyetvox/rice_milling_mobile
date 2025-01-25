import 'dart:convert';
import 'package:rice_milling_mobile/domain/configs/app_config.dart';
import 'package:rice_milling_mobile/domain/network/api_request/api_platform.dart';
import 'package:flutter/foundation.dart';

class ApiMachine {
  static Future<List<dynamic>> machines() async {
    try {
      String url = ('${AppConfig.BASE_URL}/machine');
      final response = await ApiRequest.get(url: url);
      if (response.statusCode == 200) {
        return json.decode(response.body)['data'] ?? [];
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print("ApiMachine machines error: $e");
      }
      return [];
    }
  }
}