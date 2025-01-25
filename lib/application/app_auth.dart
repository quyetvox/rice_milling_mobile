import 'package:rice_milling_mobile/infrastructure/apis/api_auth.dart';
import 'package:rice_milling_mobile/infrastructure/locals/shared_manager.dart';
import 'package:flutter/foundation.dart';

class AppAuth {
  static Future<bool> login(String userName, String password) async {
    try {
      final body = {'username': userName, 'password': password};
      final result = await ApiAuth.login(body);
      if (result == null) throw Exception('data login is null!');
      await SharedPreferencesProvider.instance
          .setAccessToken(result.accessToken);
      await SharedPreferencesProvider.instance.setUserInfo(result);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('AppAuth login error $e');
      }
      return false;
    }
  }

  static Future<bool> logout() async {
    try {
      if (SharedPreferencesProvider.instance.accessToken.isEmpty) return true;
      ApiAuth.logout();
      SharedPreferencesProvider.instance.setAccessToken('');
      SharedPreferencesProvider.instance.setUserInfo(null);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('AppAuth logout error $e');
      }
      return false;
    }
  }
}
