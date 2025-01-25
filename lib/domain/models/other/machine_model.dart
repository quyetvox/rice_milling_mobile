class MMachine {
  final num id;
  final String machineName;
  final String type;
  final String fermentationTime;
  final String volume;
  final String dimension;
  final String weight;
  final String powerSupply;
  final String capacity;

  MMachine({
    required this.id,
    required this.machineName,
    required this.type,
    required this.fermentationTime,
    required this.volume,
    required this.dimension,
    required this.weight,
    required this.powerSupply,
    required this.capacity,
  });

  factory MMachine.fromJson(Map<String, dynamic> json) {
    return MMachine(
      id: json['id'] ?? 0,
      machineName: json['machine_name'] ?? '',
      type: json['type'] ?? '',
      fermentationTime: json['fermentation_time'] ?? '',
      volume: json['volume'] ?? '',
      dimension: json['dimension'] ?? '',
      weight: json['weight'] ?? '',
      powerSupply: json['power_supply'] ?? '',
      capacity: json['capacity'] ?? '',
    );
  }
}
