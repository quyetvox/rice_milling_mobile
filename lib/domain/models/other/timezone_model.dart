class MTimeZone {
  final num id;
  final String offset;
  final String name;
  final num isActive;

  MTimeZone({
    required this.id,
    required this.offset,
    required this.name,
    required this.isActive,
  });

  factory MTimeZone.fromJson(Map<String, dynamic> json) {
    return MTimeZone(
      id: json['id'] ?? 0,
      offset: json['offset'] ?? '',
      name: json['name'] ?? '',
      isActive: json['is_active'] ?? 0,
    );
  }
}