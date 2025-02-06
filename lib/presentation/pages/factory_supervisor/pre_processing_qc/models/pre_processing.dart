import 'package:rice_milling_mobile/application/stage/app_pre_processing.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';

class StorePreProcessingQC {
  StorePreProcessingQC._privateConstructor();
  static final StorePreProcessingQC instance =
      StorePreProcessingQC._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MPreProcessingQC> {
  @override
  Future<MBaseNextPage<MPreProcessingQC>?> getApiNextPage() async {
    return await AppPreProcessing.fetch();
  }
}

class MPreProcessingQC {
  final num id;
  num lotId;
  num locationId;
  num lotQty;
  num rawPaddyWeight;
  num moistureContent;
  num impurityLevel;
  num grainDamage;
  num uniformityScore;
  String qcStatus;
  num finalQcApprovedQty;
  String comments;
  num inspectionTime;
  num createdAt;

  MPreProcessingQC({
    required this.id,
    required this.lotId,
    required this.locationId,
    required this.lotQty,
    required this.rawPaddyWeight,
    required this.moistureContent,
    required this.impurityLevel,
    required this.grainDamage,
    required this.uniformityScore,
    required this.qcStatus,
    required this.finalQcApprovedQty,
    required this.comments,
    required this.inspectionTime,
    required this.createdAt,
  });

  factory MPreProcessingQC.fromJson(Map<String, dynamic> json) {
    return MPreProcessingQC(
      id: num.parse((json['id'] ?? 0).toString()),
      lotId: num.parse((json['lot_id'] ?? 0).toString()),
      locationId: num.parse((json['location_id'] ?? 0).toString()),
      lotQty: num.parse((json['lot_qty'] ?? 0).toString()),
      rawPaddyWeight: num.parse((json['raw_paddy_weight'] ?? 0).toString()),
      moistureContent: num.parse((json['moisture_content'] ?? 0).toString()),
      impurityLevel: num.parse((json['impurity_level'] ?? 0).toString()),
      grainDamage: num.parse((json['grain_damage'] ?? 0).toString()),
      uniformityScore: num.parse((json['uniformity_score'] ?? 0).toString()),
      qcStatus: (json['qc_status'] ?? '').toString(),
      finalQcApprovedQty:
          num.parse((json['final_qc_approved_qty'] ?? 0).toString()),
      comments: (json['comments'] ?? '').toString(),
      inspectionTime: num.parse((json['inspection_time'] ?? 0).toString()),
      createdAt: num.parse((json['created_at'] ?? 0).toString()),
    );
  }

  factory MPreProcessingQC.copy(MPreProcessingQC data) {
    return MPreProcessingQC(
      id: data.id,
      lotId: data.lotId,
      locationId: data.locationId,
      lotQty: data.lotQty,
      rawPaddyWeight: data.rawPaddyWeight,
      moistureContent: data.moistureContent,
      impurityLevel: data.impurityLevel,
      grainDamage: data.grainDamage,
      uniformityScore: data.uniformityScore,
      qcStatus: data.qcStatus,
      finalQcApprovedQty: data.finalQcApprovedQty,
      comments: data.comments,
      inspectionTime: data.inspectionTime,
      createdAt: data.createdAt,
    );
  }

  Map<String, dynamic> toMapCreate() {
    return {
      'lot_id': lotId,
      'location_id': locationId,
      'lot_qty': lotQty,
      'raw_paddy_weight': rawPaddyWeight,
      'moisture_content': moistureContent,
      'impurity_level': impurityLevel,
      'grain_damage': grainDamage,
      'uniformity_score': uniformityScore,
      'qc_status': qcStatus,
      'final_qc_approved_qty': finalQcApprovedQty,
      'comments': comments,
      'inspection_time': inspectionTime,
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      'id': id,
      'lot_id': lotId,
      'location_id': locationId,
      'lot_qty': lotQty,
      'raw_paddy_weight': rawPaddyWeight,
      'moisture_content': moistureContent,
      'impurity_level': impurityLevel,
      'grain_damage': grainDamage,
      'uniformity_score': uniformityScore,
      'qc_status': qcStatus,
      'final_qc_approved_qty': finalQcApprovedQty,
      'comments': comments,
      'inspection_time': inspectionTime,
    };
  }
}
