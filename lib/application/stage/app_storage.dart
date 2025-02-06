import 'package:flutter/foundation.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/stage/api_storage.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/storage/models/storage.dart';

class AppStorage {
  static Future<MBaseNextPage<MStorage>?> fetch() async {
    try {
      final res = await ApiStorage.fetch();
      final datas = res.map((e) => MStorage.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppStorage fetch error $e');
      }
      return null;
    }
  }

  static Future<bool> insert(Map<String, dynamic> body) async {
    try {
      final res = await ApiStorage.insert(body);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppStorage insert error $e');
      }
      return false;
    }
  }

  static Future<bool> update(Map<String, dynamic> body, String id) async {
    try {
      final res = await ApiStorage.update(body, id);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppStorage update error $e');
      }
      return false;
    }
  }
}