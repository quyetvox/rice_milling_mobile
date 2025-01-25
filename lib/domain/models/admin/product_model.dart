class MProduct {
  final int id;
  final String productName;
  final String sku;
  final int cateId;
  final String productImage;
  final String description;
  final num totalStockQty;

  MProduct({
    required this.id,
    required this.productName,
    required this.sku,
    required this.cateId,
    required this.productImage,
    required this.description,
    required this.totalStockQty,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'product_name': productName,
      'sku': sku,
      'category_id': cateId,
      'product_image': productImage,
      'product_description': description,
    };
  }

  factory MProduct.fromMap(Map<String, dynamic> map) {
    return MProduct(
      id: map['id'] as int,
      productName: map['product_name'] as String,
      sku: map['sku'] as String,
      cateId: map['category_id'] as int,
      productImage: map['product_image'] as String,
      description: map['product_description'] as String,
      totalStockQty: num.parse((map['total_stock_qty'] ?? 0).toString()),
    );
  }
}
