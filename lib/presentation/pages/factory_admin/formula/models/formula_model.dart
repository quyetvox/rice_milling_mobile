// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:rice_milling_mobile/presentation/pages/factory_admin/formula/models/formula_ingredient_model.dart';

class MFormula {
  final num id;
  String formulaId;
  String formulaName;
  String cloneFormulaId;
  num approxWastageQty;
  num expectedYieldPerBatch;

  List<MFormulaIngredient>? formulaIngredients;

  MFormula({
    required this.id,
    required this.formulaId,
    required this.formulaName,
    required this.cloneFormulaId,
    required this.approxWastageQty,
    required this.expectedYieldPerBatch,
  });

  factory MFormula.fromJson(Map<String, dynamic> json) {
    return MFormula(
      id: json['id'] ?? 0,
      formulaId: json['formula_id'] ?? '',
      formulaName: json['formula_name'] ?? '',
      cloneFormulaId: json['clone_formula_id'] ?? '',
      approxWastageQty: json['approx_wastage_qty'] ?? 0,
      expectedYieldPerBatch: json['expected_yield_per_batch'] ?? 0,
    );
  }

  factory MFormula.copy(MFormula data) {
    return MFormula(
      id: data.id,
      formulaId: data.formulaId,
      formulaName: data.formulaName,
      cloneFormulaId: data.cloneFormulaId,
      approxWastageQty: data.approxWastageQty,
      expectedYieldPerBatch: data.expectedYieldPerBatch,
    );
  }

  Map<String, dynamic> toMapCreate() {
    return <String, dynamic>{
      'formula_name': formulaName,
      'clone_formula_id': cloneFormulaId,
      'approx_wastage_qty': approxWastageQty,
      'expected_yield_per_batch': expectedYieldPerBatch,
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return <String, dynamic>{
      'id': id,
      'formula_name': formulaName,
      'clone_formula_id': cloneFormulaId,
      'approx_wastage_qty': approxWastageQty,
      'expected_yield_per_batch': expectedYieldPerBatch,
    };
  }
}
