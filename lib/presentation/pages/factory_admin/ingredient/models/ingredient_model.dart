// ignore_for_file: public_member_api_docs, sort_constructors_first
class MIngredient {
  final num id;
  String materialId;
  String materialName;
  num categoryId;
  num uomId;
  num initialStockQty;
  num stockQty;
  num totalCurrentStockQty;
  num minimumStockQtyAlert;
  num businessLocationId;
  num expiryDate;

  MIngredient({
    required this.id,
    required this.materialId,
    required this.materialName,
    required this.categoryId,
    required this.uomId,
    required this.initialStockQty,
    required this.stockQty,
    required this.totalCurrentStockQty,
    required this.minimumStockQtyAlert,
    required this.businessLocationId,
    required this.expiryDate,
  });

  factory MIngredient.fromJson(Map<String, dynamic> json) {
    return MIngredient(
      id: json['id'] ?? 0,
      materialId: json['material_id'] ?? '',
      materialName: json['material_name'] ?? '',
      categoryId: json['category_id'] ?? 0,
      uomId: json['uom_id'] ?? 0,
      initialStockQty: json['initial_stock_qty'] ?? 0,
      stockQty: json['stock_qty'] ?? 0,
      totalCurrentStockQty: json['total_current_stock_qty'] ?? 0,
      minimumStockQtyAlert: json['minimum_stock_qty_alert'] ?? 0,
      businessLocationId: json['business_location_id'] ?? 0,
      expiryDate: json['expiry_date'] ?? 0,
    );
  }

  factory MIngredient.copy(MIngredient data) {
    return MIngredient(
      id: data.id,
      materialId: data.materialId,
      materialName: data.materialName,
      categoryId: data.categoryId,
      uomId: data.uomId,
      initialStockQty: data.initialStockQty,
      stockQty: data.stockQty,
      totalCurrentStockQty: data.totalCurrentStockQty,
      minimumStockQtyAlert: data.minimumStockQtyAlert,
      businessLocationId: data.businessLocationId,
      expiryDate: data.expiryDate,
    );
  }

  Map<String, dynamic> toMapCreate() {
    return <String, dynamic>{
      'material_id': materialId,
      'material_name': materialName,
      'category_id': categoryId,
      'uom_id': uomId,
      'initial_stock_qty': initialStockQty,
      'stock_qty': stockQty,
      'total_current_stock_qty': totalCurrentStockQty,
      'minimum_stock_qty_alert': minimumStockQtyAlert,
      'business_location_id': businessLocationId,
      'expiry_date': expiryDate,
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return <String, dynamic>{
      'id': id,
      'material_id': materialId,
      'material_name': materialName,
      'category_id': categoryId,
      'uom_id': uomId,
      'initial_stock_qty': initialStockQty,
      'stock_qty': stockQty,
      'total_current_stock_qty': totalCurrentStockQty,
      'minimum_stock_qty_alert': minimumStockQtyAlert,
      'business_location_id': businessLocationId,
      'expiry_date': expiryDate,
    };
  }
}
