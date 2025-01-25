class MQCCheckStage {
  final num id;
  num batchId;
  num product;
  num sampleQty;
  num startTime;
  num endTime;
  String qcStatus;
  String issuesDetected;
  String correctiveActions;
  num fineMaterialOutputQty;
  String comments;

  MQCCheckStage({
    required this.id,
    required this.batchId,
    required this.product,
    required this.sampleQty,
    required this.startTime,
    required this.endTime,
    required this.qcStatus,
    required this.issuesDetected,
    required this.correctiveActions,
    required this.fineMaterialOutputQty,
    required this.comments,
  });

  factory MQCCheckStage.fromJson(Map<String, dynamic> json) {
    return MQCCheckStage(
      id: json['id'] ?? 0,
      batchId: json['batch_id'] ?? 0,
      product: json['product'] ?? 0,
      sampleQty: json['sample_qty'] ?? 0,
      startTime: json['start_time'] ?? 0,
      endTime: json['end_time'] ?? 0,
      qcStatus: json['qc_status'] ?? '',
      issuesDetected: json['issues_detected'] ?? '',
      correctiveActions: json['corrective_actions'] ?? '',
      fineMaterialOutputQty: json['fine_material_output_qty'] ?? 0,
      comments: json['comments'] ?? '',
    );
  }

  factory MQCCheckStage.copy(MQCCheckStage json) {
    return MQCCheckStage(
      id: json.id,
      batchId: json.batchId,
      product: json.product,
      sampleQty: json.sampleQty,
      startTime: json.startTime,
      endTime: json.endTime,
      qcStatus: json.qcStatus,
      issuesDetected: json.issuesDetected,
      correctiveActions: json.correctiveActions,
      fineMaterialOutputQty: json.fineMaterialOutputQty,
      comments: json.comments,
    );
  }

  Map<String, dynamic> toMapCreate() {
    return {
      "batch_id": batchId,
      "start_time": startTime,
      "end_time": endTime,
      "sample_qty": sampleQty,
      "product": product,
      "fine_material_output_qty": fineMaterialOutputQty,
      "qc_status": qcStatus,
      "issues_detected": issuesDetected,
      "corrective_actions": correctiveActions,
      "comments": comments
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      "id": id,
      "batch_id": batchId,
      "start_time": startTime,
      "end_time": endTime,
      "sample_qty": sampleQty,
      "product": product,
      "fine_material_output_qty": fineMaterialOutputQty,
      "qc_status": qcStatus,
      "issues_detected": issuesDetected,
      "corrective_actions": correctiveActions,
      "comments": comments
    };
  }
}
