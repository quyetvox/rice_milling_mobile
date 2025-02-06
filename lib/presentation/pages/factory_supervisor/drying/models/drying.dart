import 'package:rice_milling_mobile/application/stage/app_drying.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';

class StoreDrying {
  StoreDrying._privateConstructor();
  static final StoreDrying instance = StoreDrying._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MDrying> {
  @override
  Future<MBaseNextPage<MDrying>?> getApiNextPage() async {
    return await AppDrying.fetch();
  }
}

class MDrying {
  final num id;
  num lotId;
  num locationId;
  num preCleanedPaddyQty;
  String dryingTechnique;
  num initialMoistureLevel;
  num finalMoistureLevel;
  num dryingLossQty;
  num finalDiredPaddyQty;
  String dryingComplianceStatus;
  num startTime;
  num endTime;
  String comments;
  num createdAt;

  MDrying({
    required this.id,
    required this.lotId,
    required this.locationId,
    required this.preCleanedPaddyQty,
    required this.dryingTechnique,
    required this.initialMoistureLevel,
    required this.finalMoistureLevel,
    required this.dryingLossQty,
    required this.finalDiredPaddyQty,
    required this.dryingComplianceStatus,
    required this.startTime,
    required this.endTime,
    required this.comments,
    required this.createdAt,
  });

  factory MDrying.fromJson(Map<String, dynamic> json) {
    return MDrying(
      id: num.parse((json['id'] ?? 0).toString()),
      lotId: num.parse((json['lot_id'] ?? 0).toString()),
      locationId: num.parse((json['location_id'] ?? 0).toString()),
      preCleanedPaddyQty:
          num.parse((json['pre_cleaned_paddy_qty'] ?? 0).toString()),
      dryingTechnique: (json['drying_technique'] ?? '').toString(),
      initialMoistureLevel:
          num.parse((json['initial_moisture_level'] ?? 0).toString()),
      finalMoistureLevel:
          num.parse((json['final_moisture_level'] ?? 0).toString()),
      dryingLossQty: num.parse((json['drying_loss_qty'] ?? 0).toString()),
      finalDiredPaddyQty:
          num.parse((json['final_dired_paddy_qty'] ?? 0).toString()),
      dryingComplianceStatus:
          (json['drying_compliance_status'] ?? '').toString(),
      startTime: num.parse((json['start_time'] ?? 0).toString()),
      endTime: num.parse((json['end_time'] ?? 0).toString()),
      comments: (json['comments'] ?? '').toString(),
      createdAt: num.parse((json['created_at'] ?? 0).toString()),
    );
  }

  factory MDrying.copy(MDrying data) {
    return MDrying(
      id: data.id,
      lotId: data.lotId,
      locationId: data.locationId,
      preCleanedPaddyQty: data.preCleanedPaddyQty,
      dryingTechnique: data.dryingTechnique,
      initialMoistureLevel: data.initialMoistureLevel,
      finalMoistureLevel: data.finalMoistureLevel,
      dryingLossQty: data.dryingLossQty,
      finalDiredPaddyQty: data.finalDiredPaddyQty,
      dryingComplianceStatus: data.dryingComplianceStatus,
      startTime: data.startTime,
      endTime: data.endTime,
      comments: data.comments,
      createdAt: data.createdAt,
    );
  }

  Map<String, dynamic> toMapCreate() {
    return {
      'lot_id': lotId,
      'location_id': locationId,
      'pre_cleaned_paddy_qty': preCleanedPaddyQty,
      'drying_technique': dryingTechnique,
      'initial_moisture_level': initialMoistureLevel,
      'final_moisture_level': finalMoistureLevel,
      'drying_loss_qty': dryingLossQty,
      'final_dired_paddy_qty': finalDiredPaddyQty,
      'drying_compliance_status': dryingComplianceStatus,
      'start_time': startTime,
      'end_time': endTime,
      'comments': comments,
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      'id': id,
      'lot_id': lotId,
      'location_id': locationId,
      'pre_cleaned_paddy_qty': preCleanedPaddyQty,
      'drying_technique': dryingTechnique,
      'initial_moisture_level': initialMoistureLevel,
      'final_moisture_level': finalMoistureLevel,
      'drying_loss_qty': dryingLossQty,
      'final_dired_paddy_qty': finalDiredPaddyQty,
      'drying_compliance_status': dryingComplianceStatus,
      'start_time': startTime,
      'end_time': endTime,
      'comments': comments,
    };
  }
}
