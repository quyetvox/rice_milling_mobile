import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/stage/api_packaging.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/packaging_stage/models/packaging_model.dart';
import 'package:flutter/foundation.dart';

class AppPackaging {
  static Future<MBaseNextPage<MPackagingStage>?> fetch() async {
    try {
      final res = await ApiPackaging.fetch();
      final datas = res.map((e) => MPackagingStage.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppPackaging ingredients error $e');
      }
      return null;
    }
  }

  static Future<bool> insert(Map<String, dynamic> body) async {
    try {
      final res = await ApiPackaging.insert(body);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppPackaging insert error $e');
      }
      return false;
    }
  }

  static Future<bool> update(Map<String, dynamic> body, String id) async {
    try {
      final res = await ApiPackaging.update(body, id);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppPackaging update error $e');
      }
      return false;
    }
  }
}