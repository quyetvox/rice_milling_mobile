import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/stage/api_mixing.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/mixing_stage/models/mixing_model.dart';
import 'package:flutter/foundation.dart';

class AppMixing {
  static Future<MBaseNextPage<MMixingStage>?> fetch() async {
    try {
      final res = await ApiMixing.fetch();
      final datas = res.map((e) => MMixingStage.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppMixing ingredients error $e');
      }
      return null;
    }
  }

  static Future<bool> insert(Map<String, dynamic> body) async {
    try {
      final res = await ApiMixing.insert(body);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppMixing insert error $e');
      }
      return false;
    }
  }

  static Future<bool> update(Map<String, dynamic> body, String id) async {
    try {
      final res = await ApiMixing.update(body, id);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppMixing update error $e');
      }
      return false;
    }
  }
}