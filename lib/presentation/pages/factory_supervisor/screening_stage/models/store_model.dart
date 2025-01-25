import 'package:rice_milling_mobile/application/stage/app_screening.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/screening_stage/models/screening_model.dart';

class StoreScreening {
  StoreScreening._privateConstructor();
  static final StoreScreening instance = StoreScreening._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MScreeningStage> {
  @override
  Future<MBaseNextPage<MScreeningStage>?> getApiNextPage() async {
    return await AppScreening.fetch();
  }
}
