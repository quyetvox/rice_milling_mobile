import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/domain/models/other/machine_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/admin/api_machine.dart';
import 'package:flutter/foundation.dart';

class AppMachine {
  static Future<MBaseNextPage<MMachine>?> fetch() async {
    try {
      final res = await ApiMachine.machines();
      final datas = res.map((e) => MMachine.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppMachine machines error $e');
      }
      return null;
    }
  }
}