class MScreeningStage {
  final num id;
  num batchId;
  num inputQty;
  num startTime;
  num endTime;
  String screenType;
  num machineId;
  num wastageQty;
  num fineMaterialOutputQty;
  String comments;

  MScreeningStage({
    required this.id,
    required this.batchId,
    required this.inputQty,
    required this.startTime,
    required this.endTime,
    required this.screenType,
    required this.machineId,
    required this.wastageQty,
    required this.fineMaterialOutputQty,
    required this.comments,
  });

  factory MScreeningStage.fromJson(Map<String, dynamic> json) {
    return MScreeningStage(
      id: json['id'] ?? 0,
      batchId: json['batch_id'] ?? 0,
      inputQty: json['input_qty'] ?? 0,
      startTime: json['start_time'] ?? 0,
      endTime: json['end_time'] ?? 0,
      screenType: json['screen_type'] ?? '',
      machineId: json['machine_id'] ?? 0,
      wastageQty: json['wastage_qty'] ?? 0,
      fineMaterialOutputQty: json['fine_material_output_qty'] ?? 0,
      comments: json['comments'] ?? '',
    );
  }

  factory MScreeningStage.copy(MScreeningStage json) {
    return MScreeningStage(
      id: json.id,
      batchId: json.batchId,
      inputQty: json.inputQty,
      startTime: json.startTime,
      endTime: json.endTime,
      screenType: json.screenType,
      machineId: json.machineId,
      wastageQty: json.wastageQty,
      fineMaterialOutputQty: json.fineMaterialOutputQty,
      comments: json.comments,
    );
  }

  Map<String, dynamic> toMapCreate() {
    return {
      "batch_id": batchId,
      "input_qty": inputQty,
      "start_time": startTime,
      "end_time": endTime,
      "screen_type": screenType,
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
      "screen_type": screenType,
      "machine_id": machineId,
      "wastage_qty": wastageQty,
      "comments": comments
    };
  }
}
