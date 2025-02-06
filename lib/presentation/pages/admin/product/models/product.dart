import 'package:rice_milling_mobile/application/admin/app_product.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/domain/models/admin/product_model.dart';

class StoreProduct {
  StoreProduct._privateConstructor();
  static final StoreProduct instance =
      StoreProduct._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MProduct> {
  @override
  Future<MBaseNextPage<MProduct>?> getApiNextPage() async {
    return await AppProduct.fetch();
  }
}