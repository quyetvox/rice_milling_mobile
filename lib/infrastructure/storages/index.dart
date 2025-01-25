import 'package:rice_milling_mobile/application/admin/app_category.dart';
import 'package:rice_milling_mobile/application/admin/app_machine.dart';
import 'package:rice_milling_mobile/application/admin/app_product.dart';
import 'package:rice_milling_mobile/application/admin/app_uom.dart';
//import 'package:rice_milling_mobile/application/factory_admin/app_formula.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/domain/models/admin/product_model.dart';
//mport 'package:rice_milling_mobile/domain/models/formula_ingredient/formula_ingredient_model.dart';
import 'package:rice_milling_mobile/domain/models/other/category_model.dart';
import 'package:rice_milling_mobile/domain/models/other/machine_model.dart';
import 'package:rice_milling_mobile/domain/models/other/uom_model.dart';

class Storage {
  Storage._privateConstructor();
  static final Storage instance = Storage._privateConstructor();

  final uom = FData<MUom>(fetch: AppUom.fetch());
  final category = FData<MCategory>(fetch: AppCategory.fetch());
  final machine = FData<MMachine>(fetch: AppMachine.fetch());
  final product = FData<MProduct>(fetch: AppProduct.fetch());

  // final formulaIngredientDDown = FData<DFormulaIngredient>(
  //     fetch: AppFormula.fetchListToCreateProductionPlanning());
}

class FData<T> extends FetchingNextPage<T> {
  final Future<MBaseNextPage<T>?> fetch;

  FData({
    required this.fetch,
  });

  @override
  Future<MBaseNextPage<T>?> getApiNextPage() async {
    return await fetch;
  }
}
