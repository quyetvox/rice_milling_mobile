import 'dart:convert';

import 'package:rice_milling_mobile/domain/configs/app_config.dart';
import 'package:rice_milling_mobile/domain/network/api_request/api_platform.dart';
import 'package:flutter/foundation.dart';

class ApiOther {
  static Future<List<dynamic>> currencies() async {
    try {
      String url = ('${AppConfig.BASE_URL}/master/currencies');
      final response = await ApiRequest.get(url: url);
      return json.decode(response.body)['data'] ?? [];
    } catch (e) {
      if (kDebugMode) {
        print("ApiOther currencies error: $e");
      }
      return [];
    }
  }

  static Future<List<dynamic>> timezones() async {
    try {
      String url = ('${AppConfig.BASE_URL}/master/timezones');
      final response = await ApiRequest.get(url: url);
      return json.decode(response.body)['data'] ?? [];
    } catch (e) {
      if (kDebugMode) {
        print("ApiOther timezones error: $e");
      }
      return [];
    }
  }

  static Future<List<dynamic>> countries() async {
    try {
      String url = ('${AppConfig.BASE_URL}/master/countries');
      final response = await ApiRequest.get(url: url);
      return json.decode(response.body)['data'] ?? [];
    } catch (e) {
      if (kDebugMode) {
        print("ApiOther countries error: $e");
      }
      return [];
    }
  }

  static Future<List<dynamic>> provinces(int id) async {
    try {
      String url = ('${AppConfig.BASE_URL}/master/provinces?country_id=$id');
      final response = await ApiRequest.get(url: url);
      return json.decode(response.body)['data'] ?? [];
    } catch (e) {
      if (kDebugMode) {
        print("ApiOther provinces error: $e");
      }
      return [];
    }
  }

  static Future<List<dynamic>> districts(int id) async {
    try {
      String url = ('${AppConfig.BASE_URL}/master/districts?province_id=$id');
      final response = await ApiRequest.get(url: url);
      return json.decode(response.body)['data'] ?? [];
    } catch (e) {
      if (kDebugMode) {
        print("ApiOther districts error: $e");
      }
      return [];
    }
  }

  static Future<Map<String, dynamic>> preStage() async {
    try {
      String url = ('${AppConfig.BASE_URL}/master/pre_stages');
      final response = await ApiRequest.get(url: url);
      return json.decode(response.body)['data'] ?? {};
    } catch (e) {
      if (kDebugMode) {
        print("ApiOther preStage error: $e");
      }
      return {};
    }
  }
}