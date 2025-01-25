class DFormulaIngredient {
  DFormulaIngredient({
    required this.fId,
    required this.fiId,
    required this.iId,
    required this.formulaName,
    required this.materialName,
    required this.qtyRequired,
    required this.totalCurrentStockQty,
    required this.uomId,
  });

  final int fId;
  final int fiId;
  final int iId;
  final String formulaName;
  final String materialName;
  final num qtyRequired;
  final num totalCurrentStockQty;
  final num uomId;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'f_id': fId,
      'fi_id': fiId,
      'i_id': iId,
      'uom_id': uomId,
      'formula_name': formulaName,
      'material_name': materialName,
      'total_current_stock_qty': totalCurrentStockQty,
      'qty_required': qtyRequired,
    };
  }

  factory DFormulaIngredient.fromMap(Map<String, dynamic> map) {
    return DFormulaIngredient(
      fId: int.parse((map['f_id'] ?? 0).toString()),
      fiId: int.parse((map['fi_id'] ?? 0).toString()),
      iId: int.parse((map['i_id'] ?? 0).toString()),
      uomId: int.parse((map['uom_id'] ?? 0).toString()),
      formulaName: (map['formula_name'] ?? '').toString(),
      materialName: (map['material_name'] ?? '').toString(),
      qtyRequired: num.parse((map['qty_required'] ?? 0).toString()),
      totalCurrentStockQty:
          num.parse((map['total_current_stock_qty'] ?? 0).toString()),
    );
  }

  double calculateRemainingStock(
      String uom, double totalBatchQty) {
    switch (uom.toLowerCase()) {
      case '%':
        return totalCurrentStockQty - (totalBatchQty * (qtyRequired / 100));
      case 'ppm':
        return totalCurrentStockQty -
            ((totalBatchQty / 1000) * (qtyRequired / 1000));
      default:
        return totalCurrentStockQty - (totalBatchQty * qtyRequired);
    }
  }
}
