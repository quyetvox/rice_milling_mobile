

import 'package:flutter/foundation.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/stage/api_drying.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/drying/models/drying.dart';

class AppDrying {
  static Future<MBaseNextPage<MDrying>?> fetch() async {
    try {
      final res = await ApiDrying.fetch();
      final datas = res.map((e) => MDrying.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppDrying fetch error $e');
      }
      return null;
    }
  }

  static Future<bool> insert(Map<String, dynamic> body) async {
    try {
      final res = await ApiDrying.insert(body);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppDrying insert error $e');
      }
      return false;
    }
  }

  static Future<bool> update(Map<String, dynamic> body, String id) async {
    try {
      final res = await ApiDrying.update(body, id);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppDrying update error $e');
      }
      return false;
    }
  }
}
