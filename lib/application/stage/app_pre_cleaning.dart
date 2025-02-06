import 'package:flutter/foundation.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/stage/api_pre_cleaning.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/pre_cleaning/models/pre_cleaning.dart';

class AppPreCleaning {
  static Future<MBaseNextPage<MPreCleaning>?> fetch() async {
    try {
      final res = await ApiPreCleaning.fetch();
      final datas = res.map((e) => MPreCleaning.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppPreCleaning fetch error $e');
      }
      return null;
    }
  }

  static Future<bool> insert(Map<String, dynamic> body) async {
    try {
      final res = await ApiPreCleaning.insert(body);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppPreCleaning insert error $e');
      }
      return false;
    }
  }

  static Future<bool> update(Map<String, dynamic> body, String id) async {
    try {
      final res = await ApiPreCleaning.update(body, id);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppPreCleaning update error $e');
      }
      return false;
    }
  }
}
