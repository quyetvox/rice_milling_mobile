import 'dart:convert';
import 'package:rice_milling_mobile/domain/configs/app_config.dart';
import 'package:rice_milling_mobile/domain/models/user/profile_info.dart';
import 'package:rice_milling_mobile/domain/network/api_request/api_platform.dart';
import 'package:flutter/foundation.dart';

class ApiAuth {
  static Future<MProfileInfo?> login(Map<String, dynamic> body) async {
    try {
      String url = ('${AppConfig.BASE_URL}/auth/login');
      final response = await ApiRequest.post(url: url, body: json.encode(body));
      if(response.statusCode == 200) {
        return MProfileInfo.fromJson(json.decode(response.body));
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("ApiAuth login error: $e");
      }
      return null;
    }
  }

  static Future<bool> logout() async {
    try {
      String url = ('${AppConfig.BASE_URL}/auth/logout');
      final response = await ApiRequest.post(url: url);
      if(response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("ApiAuth logout error: $e");
      }
      return false;
    }
  }
}
