import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/stage/api_screening.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/screening_stage/models/screening_model.dart';
import 'package:flutter/foundation.dart';

class AppScreening {
  static Future<MBaseNextPage<MScreeningStage>?> fetch() async {
    try {
      final res = await ApiScreening.fetch();
      final datas = res.map((e) => MScreeningStage.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppScreening ingredients error $e');
      }
      return null;
    }
  }

  static Future<bool> insert(Map<String, dynamic> body) async {
    try {
      final res = await ApiScreening.insert(body);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppScreening insert error $e');
      }
      return false;
    }
  }

  static Future<bool> update(Map<String, dynamic> body, String id) async {
    try {
      final res = await ApiScreening.update(body, id);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppScreening update error $e');
      }
      return false;
    }
  }
}