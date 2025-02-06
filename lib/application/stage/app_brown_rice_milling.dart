
import 'package:flutter/foundation.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/stage/api_brown_rice_milling.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/brown_rice_milling/models/brown_rice_milling.dart';

class AppBrownRiceMilling {
  static Future<MBaseNextPage<MBrownRiceMilling>?> fetch() async {
    try {
      final res = await ApiBrownRiceMilling.fetch();
      final datas = res.map((e) => MBrownRiceMilling.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppBrownRiceMilling fetch error $e');
      }
      return null;
    }
  }

  static Future<bool> insert(Map<String, dynamic> body) async {
    try {
      final res = await ApiBrownRiceMilling.insert(body);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppBrownRiceMilling insert error $e');
      }
      return false;
    }
  }

  static Future<bool> update(Map<String, dynamic> body, String id) async {
    try {
      final res = await ApiBrownRiceMilling.update(body, id);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppBrownRiceMilling update error $e');
      }
      return false;
    }
  }
}
