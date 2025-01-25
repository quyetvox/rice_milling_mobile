import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/factory_admin/api_ingredient.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/ingredient/models/ingredient_model.dart';
import 'package:flutter/foundation.dart';

class AppIngredient {
  static Future<MBaseNextPage<MIngredient>?> ingredients() async {
    try {
      final res = await ApiIngredient.ingredients();
      final datas = res.map((e) => MIngredient.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppIngredient ingredients error $e');
      }
      return null;
    }
  }

  static Future<bool> insert(Map<String, dynamic> body) async {
    try {
      final res = await ApiIngredient.insert(body);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppIngredient insert error $e');
      }
      return false;
    }
  }

  static Future<bool> update(Map<String, dynamic> body, String id) async {
    try {
      final res = await ApiIngredient.update(body, id);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppIngredient update error $e');
      }
      return false;
    }
  }
}
