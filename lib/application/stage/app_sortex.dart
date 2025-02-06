import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/stage/api_sortex.dart';
import 'package:flutter/foundation.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/sortex/models/sortex.dart';

class AppSortex {
  static Future<MBaseNextPage<MSortexQC>?> fetch() async {
    try {
      final res = await ApiSortex.fetch();
      final datas = res.map((e) => MSortexQC.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppSortex fetch error $e');
      }
      return null;
    }
  }

  static Future<bool> insert(Map<String, dynamic> body) async {
    try {
      final res = await ApiSortex.insert(body);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppSortex insert error $e');
      }
      return false;
    }
  }

  static Future<bool> update(Map<String, dynamic> body, String id) async {
    try {
      final res = await ApiSortex.update(body, id);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppSortex update error $e');
      }
      return false;
    }
  }
}