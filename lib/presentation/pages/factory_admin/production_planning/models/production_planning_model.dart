import 'package:rice_milling_mobile/presentation/pages/factory_admin/production_planning/models/material_allocation_model.dart';

class MProductionPlanning {
  final num id;
  num formulaId;
  num totalBatchQty;
  num startDate;
  num endDate;
  String shift;
  String status;
  String productionPlanId;

  List<MMaterialAllocation>? materialAllocations;

  MProductionPlanning({
    required this.id,
    required this.formulaId,
    required this.totalBatchQty,
    required this.startDate,
    required this.endDate,
    required this.shift,
    required this.status,
    required this.productionPlanId,
    this.materialAllocations,
  });

  factory MProductionPlanning.fromJson(Map<String, dynamic> json) {
    return MProductionPlanning(
      id: json['id'] ?? 0,
      formulaId: json['formula_id'] ?? 0,
      totalBatchQty: json['total_batch_qty'] ?? 0,
      startDate: json['start_date'] ?? 0,
      endDate: json['end_date'] ?? 0,
      shift: json['shift'] ?? '',
      status: json['status'] ?? '',
      productionPlanId: (json['production_plan_id'] ?? '').toString(),
    );
  }

  factory MProductionPlanning.copy(MProductionPlanning json) {
    return MProductionPlanning(
      id: json.id,
      formulaId: json.formulaId,
      totalBatchQty: json.totalBatchQty,
      startDate: json.startDate,
      endDate: json.endDate,
      shift: json.shift,
      status: json.status,
      productionPlanId: json.productionPlanId,
      materialAllocations: json.materialAllocations,
    );
  }

  Map<String, dynamic> toMapCreate() {
    return <String, dynamic>{
      "formula_id": formulaId,
      "total_batch_qty": totalBatchQty,
      "start_date": startDate,
      "end_date": endDate,
      "shift": shift,
      "status": status,
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return <String, dynamic>{
      'id': id,
      "formula_id": formulaId,
      "total_batch_qty": totalBatchQty,
      "start_date": startDate,
      "end_date": endDate,
      "shift": shift,
      "status": status,
    };
  }
}
