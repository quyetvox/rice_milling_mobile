import 'package:rice_milling_mobile/application/app_business.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';

import 'business_location_model.dart';

class StoreBusinessLocation {
  StoreBusinessLocation._privateConstructor();
  static final StoreBusinessLocation instance =
      StoreBusinessLocation._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MBusinessLocation> {
  @override
  Future<MBaseNextPage<MBusinessLocation>?> getApiNextPage() async {
    return await AppBusiness.businessLocations();
  }
}