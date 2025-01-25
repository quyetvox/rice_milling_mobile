import 'package:rice_milling_mobile/application/app_master.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/presentation/pages/admin/master_product/models/master_product_model.dart';

class StoreMasterProduct {
  StoreMasterProduct._privateConstructor();
  static final StoreMasterProduct instance =
      StoreMasterProduct._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MMasterProduct> {
  @override
  Future<MBaseNextPage<MMasterProduct>?> getApiNextPage() async {
    return await AppMaster.masterProducts();
  }
}