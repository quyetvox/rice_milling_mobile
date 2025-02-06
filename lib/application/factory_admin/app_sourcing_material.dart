import 'package:flutter/foundation.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/factory_admin/api_sourcing_raw.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/sourcing_material/models/sourcing_material.dart';

class AppSourcingMaterial {
  static Future<MBaseNextPage<MSourcingMaterial>?> fetch() async {
    try {
      final res = await ApiSourcingMaterial.fetch();
      final datas = res.map((e) => MSourcingMaterial.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppSourcingMaterial ingredients error $e');
      }
      return null;
    }
  }

  static Future<bool> insert(Map<String, dynamic> body) async {
    try {
      final res = await ApiSourcingMaterial.insert(body);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppSourcingMaterial insert error $e');
      }
      return false;
    }
  }

  static Future<bool> update(Map<String, dynamic> body, String id) async {
    try {
      final res = await ApiSourcingMaterial.update(body, id);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppSourcingMaterial update error $e');
      }
      return false;
    }
  }
}