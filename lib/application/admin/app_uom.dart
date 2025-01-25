import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/domain/models/other/uom_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/admin/api_uom.dart';
import 'package:flutter/foundation.dart';

class AppUom {
  static Future<MBaseNextPage<MUom>?> fetch() async {
    try {
      final res = await ApiUom.uoms();
      final datas = res.map((e) => MUom.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppUom uoms error $e');
      }
      return null;
    }
  }
}