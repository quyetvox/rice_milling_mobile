class MFormulaIngredient {
  final int id;
  final num formulaId;
  final num uomId;
  final num materialId;
  final String materialName;
  final num qtyRequired;

  MFormulaIngredient({
    required this.id,
    required this.formulaId,
    required this.uomId,
    required this.materialId,
    required this.materialName,
    required this.qtyRequired,
  });

  factory MFormulaIngredient.fromJson(Map<String, dynamic> json) {
    return MFormulaIngredient(
      id: json['id'] ?? 0,
      formulaId: json['formula_id'] ?? 0,
      uomId: json['uom_id'] ?? 0,
      materialId: json['material_id'] ?? 0,
      materialName: json['material_name'] ?? '',
      qtyRequired: json['qty_required'] ?? 0,
    );
  }
}
