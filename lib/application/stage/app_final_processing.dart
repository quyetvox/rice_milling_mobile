import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/stage/api_final_processing.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/final_processing_stage/models/final_processing_model.dart';
import 'package:flutter/foundation.dart';

class AppFinalProcessing {
  static Future<MBaseNextPage<MFinalProcessingStage>?> fetch() async {
    try {
      final res = await ApiFinalProcessing.fetch();
      final datas = res.map((e) => MFinalProcessingStage.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppFinalProcessing fetch error $e');
      }
      return null;
    }
  }

  static Future<bool> insert(Map<String, dynamic> body) async {
    try {
      final res = await ApiFinalProcessing.insert(body);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppFinalProcessing insert error $e');
      }
      return false;
    }
  }

  static Future<bool> update(Map<String, dynamic> body, String id) async {
    try {
      final res = await ApiFinalProcessing.update(body, id);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppFinalProcessing update error $e');
      }
      return false;
    }
  }
}