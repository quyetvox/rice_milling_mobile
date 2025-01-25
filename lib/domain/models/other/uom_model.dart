class MUom {
  final num id;
  final String name;
  final String shortName;
  final num allowDecimal;

  MUom({
    required this.id,
    required this.name,
    required this.shortName,
    required this.allowDecimal,
  });

  factory MUom.fromJson(Map<String, dynamic> json) {
    return MUom(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      shortName: json['short_name'] ?? '',
      allowDecimal: json['allow_decimal'] ?? 0,
    );
  }
}
