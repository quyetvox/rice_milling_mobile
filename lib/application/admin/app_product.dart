import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/domain/models/admin/product_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/admin/api_product.dart';
import 'package:flutter/foundation.dart';

class AppProduct {
  static Future<MBaseNextPage<MProduct>?> fetch() async {
    try {
      final res = await ApiProduct.products();
      final datas = res.map((e) => MProduct.fromMap(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppProduct fetch error $e');
      }
      return null;
    }
  }

  static Future<MProduct?> fetchById(int id) async {
    try {
      final res = await ApiProduct.fetchById(id);
      if(res == null) return null;
      return MProduct.fromMap(res);
    } catch (e) {
      if (kDebugMode) {
        print('AppProduct fetch error $e');
      }
      return null;
    }
  }
}