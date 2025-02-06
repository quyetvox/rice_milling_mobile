import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/stage/api_pre_processing.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/pre_processing_qc/models/pre_processing.dart';
import 'package:flutter/foundation.dart';

class AppPreProcessing {
  static Future<MBaseNextPage<MPreProcessingQC>?> fetch() async {
    try {
      final res = await ApiPreProcessing.fetch();
      final datas = res.map((e) => MPreProcessingQC.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppPreProcessing fetch error $e');
      }
      return null;
    }
  }

  static Future<bool> insert(Map<String, dynamic> body) async {
    try {
      final res = await ApiPreProcessing.insert(body);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppPreProcessing insert error $e');
      }
      return false;
    }
  }

  static Future<bool> update(Map<String, dynamic> body, String id) async {
    try {
      final res = await ApiPreProcessing.update(body, id);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppPreProcessing update error $e');
      }
      return false;
    }
  }
}