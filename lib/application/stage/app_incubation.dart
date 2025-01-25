import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/stage/api_incubation.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/incubation_stage/models/incubation_model.dart';
import 'package:flutter/foundation.dart';

class AppIncubation {
  static Future<MBaseNextPage<MIncubationStage>?> fetch() async {
    try {
      final res = await ApiIncubation.fetch();
      final datas = res.map((e) => MIncubationStage.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppIncubation fetch error $e');
      }
      return null;
    }
  }

  static Future<bool> insert(Map<String, dynamic> body) async {
    try {
      final res = await ApiIncubation.insert(body);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppIncubation insert error $e');
      }
      return false;
    }
  }

  static Future<bool> update(Map<String, dynamic> body, String id) async {
    try {
      final res = await ApiIncubation.update(body, id);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppIncubation update error $e');
      }
      return false;
    }
  }
}