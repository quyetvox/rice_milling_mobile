import 'package:rice_milling_mobile/application/stage/app_qc_check.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/qc_check_stage/models/qc_check_model.dart';

class StoreQCCheck {
  StoreQCCheck._privateConstructor();
  static final StoreQCCheck instance = StoreQCCheck._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MQCCheckStage> {
  @override
  Future<MBaseNextPage<MQCCheckStage>?> getApiNextPage() async {
    return await AppQCCheck.fetch();
  }
}
