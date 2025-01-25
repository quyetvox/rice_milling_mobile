import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/api_business.dart';
import 'package:rice_milling_mobile/presentation/pages/admin/business_location/models/business_location_model.dart';
import 'package:rice_milling_mobile/presentation/pages/admin/business_setting/models/business_setting_model.dart';
import 'package:flutter/foundation.dart';

class AppBusiness {
  static Future<MBaseNextPage<MBusinessSetting>?> businessSettings() async {
    try {
      final res = await ApiBusiness.businessSettings();
      final datas = res.map((e) => MBusinessSetting.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppBusiness businessSettings error $e');
      }
      return null;
    }
  }

  static Future<MBaseNextPage<MBusinessLocation>?> businessLocations() async {
    try {
      final res = await ApiBusiness.businessLocations();
      final datas = res.map((e) => MBusinessLocation.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppBusiness businessLocations error $e');
      }
      return null;
    }
  }
}
