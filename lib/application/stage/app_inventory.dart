import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/stage/api_inventory.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/inventory_stage/models/inventory_model.dart';
import 'package:flutter/foundation.dart';

class AppInventory {
  static Future<MBaseNextPage<MInventoryStage>?> fetch() async {
    try {
      final res = await ApiInventory.fetch();
      final datas = res.map((e) => MInventoryStage.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppInventory fetch error $e');
      }
      return null;
    }
  }

  static Future<bool> insert(Map<String, dynamic> body) async {
    try {
      final res = await ApiInventory.insert(body);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppInventory insert error $e');
      }
      return false;
    }
  }

  static Future<bool> update(Map<String, dynamic> body, String id) async {
    try {
      final res = await ApiInventory.update(body, id);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppInventory update error $e');
      }
      return false;
    }
  }
}