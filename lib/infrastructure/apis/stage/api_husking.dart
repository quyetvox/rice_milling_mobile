import 'dart:convert';

import 'package:rice_milling_mobile/domain/configs/app_config.dart';
import 'package:rice_milling_mobile/domain/network/api_request/api_platform.dart';
import 'package:flutter/foundation.dart';

class ApiHusking {
  static Future<List<dynamic>> fetch() async {
    try {
      String url = ('${AppConfig.BASE_URL}/stage/husking');
      final response = await ApiRequest.get(url: url);
      if (response.statusCode == 200) {
        return json.decode(response.body)['data'] ?? [];
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print("ApiHusking fetch error: $e");
      }
      return [];
    }
  }

  static Future<bool> insert(Map<String, dynamic> body) async {
    try {
      String url = ('${AppConfig.BASE_URL}/stage/husking');
      final response = await ApiRequest.post(url: url, body: jsonEncode(body));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("ApiHusking insert error: $e");
      }
      return false;
    }
  }

  static Future<bool> update(Map<String, dynamic> body, String id) async {
    try {
      String url = ('${AppConfig.BASE_URL}/stage/husking/$id');
      final response = await ApiRequest.post(url: url, body: jsonEncode(body));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("ApiHusking update error: $e");
      }
      return false;
    }
  }
}