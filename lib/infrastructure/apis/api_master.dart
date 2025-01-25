import 'dart:convert';

import 'package:rice_milling_mobile/domain/configs/app_config.dart';
import 'package:rice_milling_mobile/domain/network/api_request/api_platform.dart';
import 'package:flutter/foundation.dart';

class ApiMaster {
  static Future<List<dynamic>> masterProducts() async {
    try {
      String url = ('${AppConfig.BASE_URL}/product');
      final response = await ApiRequest.get(url: url);
      if (response.statusCode == 200) {
        return json.decode(response.body)['data'] ?? [];
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print("ApiMaster masterProducts error: $e");
      }
      return [];
    }
  }
}
