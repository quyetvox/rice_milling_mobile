import 'package:rice_milling_mobile/application/stage/app_incubation.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/incubation_stage/models/incubation_model.dart';

class StoreIncubation {
  StoreIncubation._privateConstructor();
  static final StoreIncubation instance =
      StoreIncubation._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MIncubationStage> {
  @override
  Future<MBaseNextPage<MIncubationStage>?> getApiNextPage() async {
    return await AppIncubation.fetch();
  }
}