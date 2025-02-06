import 'package:flutter/foundation.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/stage/api_husking.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/husking/models/husking.dart';

class AppHusking {
  static Future<MBaseNextPage<MHusking>?> fetch() async {
    try {
      final res = await ApiHusking.fetch();
      final datas = res.map((e) => MHusking.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppHusking fetch error $e');
      }
      return null;
    }
  }

  static Future<bool> insert(Map<String, dynamic> body) async {
    try {
      final res = await ApiHusking.insert(body);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppHusking insert error $e');
      }
      return false;
    }
  }

  static Future<bool> update(Map<String, dynamic> body, String id) async {
    try {
      final res = await ApiHusking.update(body, id);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppHusking update error $e');
      }
      return false;
    }
  }
}
