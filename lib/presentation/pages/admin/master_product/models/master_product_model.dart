class MMasterProduct {
  final num id;
  final String productName;
  final String sku;
  final num categoryId;
  final String productImage;
  final String productDescription;

  MMasterProduct({
    required this.id,
    required this.productName,
    required this.sku,
    required this.categoryId,
    required this.productImage,
    required this.productDescription,
  });

  factory MMasterProduct.fromJson(Map<String, dynamic> json) {
    return MMasterProduct(
      id: json['id'] ?? 0,
      productName: json['product_name'] ?? '',
      sku: json['sku'] ?? '',
      categoryId: json['category_id'] ?? 0,
      productImage: json['product_image'] ?? '',
      productDescription: json['product_description'] ?? '',
    );
  }
}
