class MIncubationStage {
  final num id;
  num batchId;
  num inputQty;
  num startTime;
  num endTime;
  num actualTemperature;
  num actualMoistureLevel;
  num machineId;
  num wastageQty;
  num finalOutcomeQty;
  String comments;

  MIncubationStage({
    required this.id,
    required this.batchId,
    required this.inputQty,
    required this.startTime,
    required this.endTime,
    required this.actualTemperature,
    required this.actualMoistureLevel,
    required this.machineId,
    required this.wastageQty,
    required this.finalOutcomeQty,
    required this.comments,
  });

  factory MIncubationStage.fromJson(Map<String, dynamic> json) {
    return MIncubationStage(
      id: json['id'] ?? 0,
      batchId: json['batch_id'] ?? 0,
      inputQty: json['input_qty'] ?? 0,
      startTime: json['start_time'] ?? 0,
      endTime: json['end_time'] ?? 0,
      actualTemperature: json['actual_temperature'] ?? 0,
      actualMoistureLevel: json['actual_moisture_level'] ?? 0,
      machineId: json['machine_id'] ?? 0,
      wastageQty: json['wastage_qty'] ?? 0,
      finalOutcomeQty: json['final_outcome_qty'] ?? 0,
      comments: json['comments'] ?? '',
    );
  }

  factory MIncubationStage.copy(MIncubationStage json) {
    return MIncubationStage(
      id: json.id,
      batchId: json.batchId,
      inputQty: json.inputQty,
      startTime: json.startTime,
      endTime: json.endTime,
      actualTemperature: json.actualTemperature,
      actualMoistureLevel: json.actualMoistureLevel,
      machineId: json.machineId,
      wastageQty: json.wastageQty,
      finalOutcomeQty: json.finalOutcomeQty,
      comments: json.comments,
    );
  }

  Map<String, dynamic> toMapCreate() {
    return {
      "batch_id": batchId,
      "input_qty": inputQty,
      "start_time": startTime,
      "end_time": endTime,
      "actual_temperature": actualTemperature,
      "actual_moisture_level": actualMoistureLevel,
      "machine_id": machineId,
      "wastage_qty": wastageQty,
      "comments": comments
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      "id": id,
      "batch_id": batchId,
      "input_qty": inputQty,
      "start_time": startTime,
      "end_time": endTime,
      "actual_temperature": actualTemperature,
      "actual_moisture_level": actualMoistureLevel,
      "machine_id": machineId,
      "wastage_qty": wastageQty,
      "comments": comments
    };
  }
}
