import 'package:rice_milling_mobile/application/stage/app_mixing.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/mixing_stage/models/mixing_model.dart';

class StoreMixing {
  StoreMixing._privateConstructor();
  static final StoreMixing instance =
      StoreMixing._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MMixingStage> {
  @override
  Future<MBaseNextPage<MMixingStage>?> getApiNextPage() async {
    return await AppMixing.fetch();
  }
}