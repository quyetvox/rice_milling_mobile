class MPackagingStage {
  final num id;
  num batchId;
  num productId;
  num qcApprovedProductQty;
  String packageSize;
  num totalPackage;
  num wastageQty;
  num fineProductQty;
  String comments;

  MPackagingStage({
    required this.id,
    required this.batchId,
    required this.productId,
    required this.qcApprovedProductQty,
    required this.packageSize,
    required this.totalPackage,
    required this.wastageQty,
    required this.fineProductQty,
    required this.comments,
  });

  factory MPackagingStage.fromJson(Map<String, dynamic> json) {
    return MPackagingStage(
      id: json['id'] ?? 0,
      batchId: json['batch_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      qcApprovedProductQty: json['qc_approved_product_qty'] ?? 0,
      packageSize: json['package_size'] ?? '',
      totalPackage: json['total_package'] ?? 0,
      wastageQty: json['wastage_qty'] ?? 0,
      fineProductQty: json['fine_product_qty'] ?? 0,
      comments: json['comments'] ?? '',
    );
  }

  factory MPackagingStage.copy(MPackagingStage json) {
    return MPackagingStage(
      id: json.id,
      productId: json.productId,
      batchId: json.batchId,
      qcApprovedProductQty: json.qcApprovedProductQty,
      packageSize: json.packageSize,
      totalPackage: json.totalPackage,
      wastageQty: json.wastageQty,
      fineProductQty: json.fineProductQty,
      comments: json.comments,
    );
  }

  Map<String, dynamic> toMapCreate() {
    return {
      "batch_id": batchId,
      "product_id": productId,
      "qc_approved_product_qty": qcApprovedProductQty,
      "package_size": packageSize,
      "wastage_qty": wastageQty,
      "comments": comments
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      "id": id,
      "batch_id": batchId,
      "product_id": productId,
      "qc_approved_product_qty": qcApprovedProductQty,
      "package_size": packageSize,
      "wastage_qty": wastageQty,
      "comments": comments
    };
  }
}
