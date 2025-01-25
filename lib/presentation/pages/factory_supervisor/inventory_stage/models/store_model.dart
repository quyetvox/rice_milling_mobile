import 'package:rice_milling_mobile/application/stage/app_inventory.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/inventory_stage/models/inventory_model.dart';

class StoreInventory {
  StoreInventory._privateConstructor();
  static final StoreInventory instance = StoreInventory._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MInventoryStage> {
  @override
  Future<MBaseNextPage<MInventoryStage>?> getApiNextPage() async {
    return await AppInventory.fetch();
  }
}
