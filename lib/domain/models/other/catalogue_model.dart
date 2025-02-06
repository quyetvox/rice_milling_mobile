class MCatalogue {
  final int id;
  final String key;
  final List<String> values;

  MCatalogue({
    required this.id,
    required this.key,
    required this.values,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'key': key,
      'values': values,
    };
  }

  factory MCatalogue.fromMap(Map<String, dynamic> map) {
    return MCatalogue(
      id: int.parse((map['id'] ?? '0').toString()),
      key: (map['key'] ?? '').toString(),
      values: ((map['values'] ?? []) as List).map((e) => e.toString()).toList(),
    );
  }
}
