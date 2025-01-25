class MInventoryStage {
  final num id;
  num batchId;
  num finishedProductId;
  num warehouseId;
  num existingStock;
  num currentStock;
  num totalAvailableStock;
  String comments;

  MInventoryStage({
    required this.id,
    required this.batchId,
    required this.finishedProductId,
    required this.warehouseId,
    required this.existingStock,
    required this.currentStock,
    required this.totalAvailableStock,
    required this.comments,
  });

  factory MInventoryStage.fromJson(Map<String, dynamic> json) {
    return MInventoryStage(
      id: json['id'] ?? 0,
      batchId: json['batch_id'] ?? 0,
      finishedProductId: json['finished_product_id'] ?? 0,
      warehouseId: json['warehouse_id'] ?? 0,
      existingStock: json['existing_stock'] ?? 0,
      currentStock: json['current_stock'] ?? 0,
      totalAvailableStock: json['total_available_stock'] ?? 0,
      comments: json['comments'] ?? '',
    );
  }

  factory MInventoryStage.copy(MInventoryStage json) {
    return MInventoryStage(
      id: json.id,
      batchId: json.batchId,
      finishedProductId: json.finishedProductId,
      warehouseId: json.warehouseId,
      existingStock: json.existingStock,
      currentStock: json.currentStock,
      totalAvailableStock: json.totalAvailableStock,
      comments: json.comments,
    );
  }

  Map<String, dynamic> toMapCreate() {
    return {
      "batch_id": batchId,
      "finished_product_id": finishedProductId,
      "warehouse_id": warehouseId,
      "existing_stock": existingStock,
      "current_stock": currentStock,
      "comments": comments
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      "id": id,
      "batch_id": batchId,
      "finished_product_id": finishedProductId,
      "warehouse_id": warehouseId,
      "existing_stock": existingStock,
      "current_stock": currentStock,
      "comments": comments
    };
  }
}
