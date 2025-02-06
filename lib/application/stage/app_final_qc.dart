import 'package:flutter/foundation.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/stage/api_final_qc.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/final_qc/models/final_qc.dart';

class AppFinalQC {
  static Future<MBaseNextPage<MFinalQC>?> fetch() async {
    try {
      final res = await ApiFinalQC.fetch();
      final datas = res.map((e) => MFinalQC.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppFinalQC fetch error $e');
      }
      return null;
    }
  }

  static Future<bool> insert(Map<String, dynamic> body) async {
    try {
      final res = await ApiFinalQC.insert(body);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppFinalQC insert error $e');
      }
      return false;
    }
  }

  static Future<bool> update(Map<String, dynamic> body, String id) async {
    try {
      final res = await ApiFinalQC.update(body, id);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppFinalQC update error $e');
      }
      return false;
    }
  }
}
