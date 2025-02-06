
import 'package:flutter/foundation.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/stage/api_de_stoning.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/de_stoning/models/de_stoning.dart';

class AppDeStoning {
  static Future<MBaseNextPage<MDeStoningQC>?> fetch() async {
    try {
      final res = await ApiDeStoning.fetch();
      final datas = res.map((e) => MDeStoningQC.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppDeStoning fetch error $e');
      }
      return null;
    }
  }

  static Future<bool> insert(Map<String, dynamic> body) async {
    try {
      final res = await ApiDeStoning.insert(body);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppDeStoning insert error $e');
      }
      return false;
    }
  }

  static Future<bool> update(Map<String, dynamic> body, String id) async {
    try {
      final res = await ApiDeStoning.update(body, id);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppDeStoning update error $e');
      }
      return false;
    }
  }
}
