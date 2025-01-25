import 'package:rice_milling_mobile/application/factory_admin/app_ingredient.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/ingredient/models/ingredient_model.dart';

class StoreIngredient {
  StoreIngredient._privateConstructor();
  static final StoreIngredient instance =
      StoreIngredient._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MIngredient> {
  @override
  Future<MBaseNextPage<MIngredient>?> getApiNextPage() async {
    return await AppIngredient.ingredients();
  }
}