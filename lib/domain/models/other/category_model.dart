class MCategory {
  final num id;
  final String categoryName;
  final String categoryCode;
  final String description;

  MCategory({
    required this.id,
    required this.categoryName,
    required this.categoryCode,
    required this.description,
  });

  factory MCategory.fromJson(Map<String, dynamic> json) {
    return MCategory(
      id: json['id'] ?? 0,
      categoryName: json['category_name'] ?? '',
      categoryCode: json['category_code'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
