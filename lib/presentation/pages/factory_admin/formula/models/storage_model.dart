import 'package:rice_milling_mobile/application/factory_admin/app_formula.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/domain/models/formula_ingredient/formula_ingredient_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/formula/models/formula_model.dart';

class StoreFormula {
  StoreFormula._privateConstructor();
  static final StoreFormula instance =
      StoreFormula._privateConstructor();

  final data = _FData();

  clear() => data.clear();
}

class _FData extends FetchingNextPage<MFormula> {
  @override
  Future<MBaseNextPage<MFormula>?> getApiNextPage() async {
    return await AppFormula.formulas();
  }
}

class StoreFormulaIngredientDDown {
  StoreFormulaIngredientDDown._privateConstructor();
  static final StoreFormulaIngredientDDown instance =
      StoreFormulaIngredientDDown._privateConstructor();

  final data = _FDataFormulaIngredientDDown();

  clear() => data.clear();
}

class _FDataFormulaIngredientDDown extends FetchingNextPage<DFormulaIngredient> {
  @override
  Future<MBaseNextPage<DFormulaIngredient>?> getApiNextPage() async {
    return await AppFormula.fetchListToCreateProductionPlanning();
  }
}