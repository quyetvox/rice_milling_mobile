import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/stage/api_final_inventory.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/final_inventory/models/final_inventory.dart';
import 'package:flutter/foundation.dart';

class AppFinalInventory {
  static Future<MBaseNextPage<MFinalInventory>?> fetch() async {
    try {
      final res = await ApiFinalInventory.fetch();
      final datas = res.map((e) => MFinalInventory.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppFinalInventory fetch error $e');
      }
      return null;
    }
  }

  static Future<bool> insert(Map<String, dynamic> body) async {
    try {
      final res = await ApiFinalInventory.insert(body);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppFinalInventory insert error $e');
      }
      return false;
    }
  }

  static Future<bool> update(Map<String, dynamic> body, String id) async {
    try {
      final res = await ApiFinalInventory.update(body, id);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppFinalInventory update error $e');
      }
      return false;
    }
  }
}