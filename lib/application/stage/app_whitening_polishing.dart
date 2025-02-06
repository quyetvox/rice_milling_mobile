import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:flutter/foundation.dart';
import 'package:rice_milling_mobile/infrastructure/apis/stage/api_whitening_polishing.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/whitening_semi_polishing/models/whitening_semi_polishing.dart';

class AppWhiteningPolishing {
  static Future<MBaseNextPage<MWhiteningSemiPolishingQC>?> fetch() async {
    try {
      final res = await ApiWhiteningPolishing.fetch();
      final datas = res.map((e) => MWhiteningSemiPolishingQC.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppWhiteningPolishing fetch error $e');
      }
      return null;
    }
  }

  static Future<bool> insert(Map<String, dynamic> body) async {
    try {
      final res = await ApiWhiteningPolishing.insert(body);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppWhiteningPolishing insert error $e');
      }
      return false;
    }
  }

  static Future<bool> update(Map<String, dynamic> body, String id) async {
    try {
      final res = await ApiWhiteningPolishing.update(body, id);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppWhiteningPolishing update error $e');
      }
      return false;
    }
  }
}
