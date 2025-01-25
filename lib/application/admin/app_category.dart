import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/domain/models/other/category_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/admin/api_category.dart';
import 'package:flutter/foundation.dart';

class AppCategory {
  static Future<MBaseNextPage<MCategory>?> fetch() async {
    try {
      final res = await ApiCategory.categories();
      final datas = res.map((e) => MCategory.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppCategory categories error $e');
      }
      return null;
    }
  }
}