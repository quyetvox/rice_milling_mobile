import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/api_master.dart';
import 'package:rice_milling_mobile/presentation/pages/admin/master_product/models/master_product_model.dart';
import 'package:flutter/foundation.dart';

class AppMaster {
  static Future<MBaseNextPage<MMasterProduct>?> masterProducts() async {
    try {
      final res = await ApiMaster.masterProducts();
      final datas = res.map((e) => MMasterProduct.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppMaster masterProducts error $e');
      }
      return null;
    }
  }
}
