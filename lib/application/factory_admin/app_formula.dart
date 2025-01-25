import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/domain/models/formula_ingredient/formula_ingredient_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/factory_admin/api_formula.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/formula/models/formula_ingredient_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/formula/models/formula_model.dart';
import 'package:flutter/foundation.dart';

class AppFormula {
  static Future<MBaseNextPage<MFormula>?> formulas() async {
    try {
      final res = await ApiFormula.formulas();
      final datas = res.map((e) => MFormula.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppFormula formulas error $e');
      }
      return null;
    }
  }

  static Future<bool> insert(Map<String, dynamic> body) async {
    try {
      final res = await ApiFormula.insert(body);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppFormula insert error $e');
      }
      return false;
    }
  }

  static Future<bool> update(Map<String, dynamic> body,
      List<Map<String, dynamic>> formulaIngredients) async {
    try {
      final res = await ApiFormula.update(body, body['id'].toString());
      for (final e in formulaIngredients) {
        ApiFormula.updateFormulaIngredient(e, e['id'].toString());
      }
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppIngredient update error $e');
      }
      return false;
    }
  }

  static Future<List<MFormulaIngredient>> formulaIngredients(
      String formulaId) async {
    try {
      final res = await ApiFormula.formulaIngredients(formulaId);
      final datas = res.map((e) => MFormulaIngredient.fromJson(e)).toList();
      return datas;
    } catch (e) {
      if (kDebugMode) {
        print('AppFormula formulaIngredients error $e');
      }
      return [];
    }
  }

  static Future<MBaseNextPage<DFormulaIngredient>?>
      fetchListToCreateProductionPlanning() async {
    try {
      final res = await ApiFormula.fetchListToCreateProductionPlanning();
      final datas = res.map((e) => DFormulaIngredient.fromMap(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppFormula fetchListToCreateProductionPlanning error $e');
      }
      return null;
    }
  }
}
