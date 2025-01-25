import 'package:rice_milling_mobile/application/stage/app_packaging.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/packaging_stage/models/packaging_model.dart';

class StorePackaging {
  StorePackaging._privateConstructor();
  static final StorePackaging instance = StorePackaging._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MPackagingStage> {
  @override
  Future<MBaseNextPage<MPackagingStage>?> getApiNextPage() async {
    return await AppPackaging.fetch();
  }
}
