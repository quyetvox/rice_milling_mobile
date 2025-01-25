class MMaterialAllocation {
  int id;
  num materialId;
  num materialQty;
  num uomId;
  num availableStock;
  num remainingStock;
  String? uomShortName;

  MMaterialAllocation({
    required this.id,
    required this.materialId,
    required this.materialQty,
    required this.uomId,
    required this.availableStock,
    required this.remainingStock,
    this.uomShortName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'material_id': materialId,
      'material_qty': materialQty,
      'available_stock': availableStock,
      'remaining_stock': remainingStock,
      'uom_id': uomId,
      'uom_short_name': uomShortName,
    };
  }

  factory MMaterialAllocation.fromMap(Map<String, dynamic> map) {
    return MMaterialAllocation(
      id: int.parse((map['id'] ?? '0').toString()),
      materialId: int.parse((map['material_id'] ?? '0').toString()),
      materialQty: map['material_qty'] ?? 0,
      uomId: int.parse((map['uom_id'] ?? '0').toString()),
      availableStock: map['available_stock'] ?? 0,
      remainingStock: map['remaining_stock'] ?? 0,
    );
  }
}
