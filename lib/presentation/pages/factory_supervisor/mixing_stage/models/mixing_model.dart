class MMixingStage {
  final num id;
  final num batchId;
  num productionBatchId;
  num startTime;
  num endTime;
  num machineId;
  num totalTargetQty;
  num wastageQty;
  num finalOutcomeQty;
  String comments;
  String productionPlanId;
  String machineName;

  MMixingStage({
    required this.id,
    required this.batchId,
    required this.productionBatchId,
    required this.startTime,
    required this.endTime,
    required this.machineId,
    required this.totalTargetQty,
    required this.wastageQty,
    required this.finalOutcomeQty,
    required this.comments,
    required this.productionPlanId,
    required this.machineName,
  });

  factory MMixingStage.fromJson(Map<String, dynamic> json) {
    return MMixingStage(
      id: json['id'] ?? 0,
      batchId: json['batch_id'] ?? 0,
      productionBatchId: json['production_batch_id'] ?? 0,
      startTime: json['start_time'] ?? 0,
      endTime: json['end_time'] ?? 0,
      machineId: json['machine_id'] ?? 0,
      totalTargetQty: json['total_target_qty'] ?? 0,
      wastageQty: json['wastage_qty'] ?? 0,
      finalOutcomeQty: json['final_outcome_qty'] ?? 0,
      comments: json['comments'] ?? '',
      productionPlanId: (json['production_plan_id'] ?? '').toString(),
      machineName: (json['machine_name'] ?? '').toString(),
    );
  }

  factory MMixingStage.copy(MMixingStage json) {
    return MMixingStage(
      id: json.id,
      batchId: json.batchId,
      productionBatchId: json.productionBatchId,
      startTime: json.startTime,
      endTime: json.endTime,
      machineId: json.machineId,
      totalTargetQty: json.totalTargetQty,
      wastageQty: json.wastageQty,
      finalOutcomeQty: json.finalOutcomeQty,
      comments: json.comments,
      productionPlanId: json.productionPlanId,
      machineName: json.machineName,
    );
  }

  Map<String, dynamic> toMapCreate() {
    return {
      "production_batch_id": productionBatchId,
      "start_time": startTime,
      "end_time": endTime,
      "machine_id": machineId,
      "total_target_qty": totalTargetQty,
      "wastage_qty": wastageQty,
      "comments": comments
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      "id": id,
      "production_batch_id": productionBatchId,
      "start_time": startTime,
      "end_time": endTime,
      "machine_id": machineId,
      "total_target_qty": totalTargetQty,
      "wastage_qty": wastageQty,
      "comments": comments
    };
  }
}
