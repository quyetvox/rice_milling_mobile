import 'package:rice_milling_mobile/application/factory_admin/app_production_planning.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/production_planning/models/production_planning_model.dart';

class StoreProductionPlanning {
  StoreProductionPlanning._privateConstructor();
  static final StoreProductionPlanning instance =
      StoreProductionPlanning._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MProductionPlanning> {
  @override
  Future<MBaseNextPage<MProductionPlanning>?> getApiNextPage() async {
    return await AppProductionPlanning.productionPlannings();
  }
}