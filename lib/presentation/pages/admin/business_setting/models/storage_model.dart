import 'package:rice_milling_mobile/application/app_business.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/presentation/pages/admin/business_setting/models/business_setting_model.dart';

class StoreBusinessSetting {
  StoreBusinessSetting._privateConstructor();
  static final StoreBusinessSetting instance =
      StoreBusinessSetting._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MBusinessSetting> {
  @override
  Future<MBaseNextPage<MBusinessSetting>?> getApiNextPage() async {
    return await AppBusiness.businessSettings();
  }
}