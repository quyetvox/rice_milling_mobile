import 'package:rice_milling_mobile/application/stage/app_final_processing.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/final_processing_stage/models/final_processing_model.dart';

class StoreFinalProcessing {
  StoreFinalProcessing._privateConstructor();
  static final StoreFinalProcessing instance = StoreFinalProcessing._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MFinalProcessingStage> {
  @override
  Future<MBaseNextPage<MFinalProcessingStage>?> getApiNextPage() async {
    return await AppFinalProcessing.fetch();
  }
}
