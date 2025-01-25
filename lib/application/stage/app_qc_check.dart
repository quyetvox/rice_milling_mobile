import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/stage/api_qc_check.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/qc_check_stage/models/qc_check_model.dart';
import 'package:flutter/foundation.dart';

class AppQCCheck {
  static Future<MBaseNextPage<MQCCheckStage>?> fetch() async {
    try {
      final res = await ApiQCCheck.fetch();
      final datas = res.map((e) => MQCCheckStage.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppQCCheck ingredients error $e');
      }
      return null;
    }
  }

  static Future<bool> insert(Map<String, dynamic> body) async {
    try {
      final res = await ApiQCCheck.insert(body);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppQCCheck insert error $e');
      }
      return false;
    }
  }

  static Future<bool> update(Map<String, dynamic> body, String id) async {
    try {
      final res = await ApiQCCheck.update(body, id);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppQCCheck update error $e');
      }
      return false;
    }
  }
}