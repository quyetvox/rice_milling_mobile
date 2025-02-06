import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:flutter/foundation.dart';
import 'package:rice_milling_mobile/domain/models/other/milling_factory.dart';
import 'package:rice_milling_mobile/infrastructure/apis/admin/api_milling_factory.dart';

class AppMillingFactory {
  static Future<MBaseNextPage<MMillingFactory>?> fetch() async {
    try {
      final res = await ApiMillingFactory.fetch();
      final datas = res.map((e) => MMillingFactory.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppMillingFactory fetch error $e');
      }
      return null;
    }
  }
}