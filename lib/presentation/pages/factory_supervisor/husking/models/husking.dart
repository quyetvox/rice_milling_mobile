import 'package:rice_milling_mobile/application/stage/app_husking.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';

class StoreHuskingQC {
  StoreHuskingQC._privateConstructor();
  static final StoreHuskingQC instance = StoreHuskingQC._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MHusking> {
  @override
  Future<MBaseNextPage<MHusking>?> getApiNextPage() async {
    return await AppHusking.fetch();
  }
}

class MHusking {
  final num id;
  num lotId;
  num locationId;
  String sourceType;
  String storageId;
  num storedPaddyQty;
  num huskedBrownRiceQty;
  num huskQty;
  String huskUsageType;
  String huskComplianceStatus;
  num startTime;
  num endTime;
  String comments;
  num createdAt;

  MHusking({
    required this.id,
    required this.lotId,
    required this.locationId,
    required this.sourceType,
    required this.storageId,
    required this.storedPaddyQty,
    required this.huskedBrownRiceQty,
    required this.huskQty,
    required this.huskUsageType,
    required this.huskComplianceStatus,
    required this.startTime,
    required this.endTime,
    required this.comments,
    required this.createdAt,
  });

  factory MHusking.fromJson(Map<String, dynamic> json) {
    return MHusking(
      id: num.parse((json['id'] ?? 0).toString()),
      lotId: num.parse((json['lot_id'] ?? 0).toString()),
      locationId: num.parse((json['location_id'] ?? 0).toString()),
      sourceType: (json['source_type'] ?? '').toString(),
      storageId: (json['storage_id'] ?? '').toString(),
      storedPaddyQty: num.parse((json['stored_paddy_qty'] ?? 0).toString()),
      huskedBrownRiceQty:
          num.parse((json['husked_brown_rice_qty'] ?? 0).toString()),
      huskQty: num.parse((json['husk_qty'] ?? 0).toString()),
      huskUsageType: (json['husk_usage_type'] ?? '').toString(),
      huskComplianceStatus: (json['husk_compliance_status'] ?? '').toString(),
      startTime: num.parse((json['start_time'] ?? 0).toString()),
      endTime: num.parse((json['end_time'] ?? 0).toString()),
      comments: (json['comments'] ?? '').toString(),
      createdAt: num.parse((json['created_at'] ?? 0).toString()),
    );
  }

  factory MHusking.copy(MHusking data) {
    return MHusking(
      id: data.id,
      lotId: data.lotId,
      locationId: data.locationId,
      sourceType: data.sourceType,
      storageId: data.storageId,
      storedPaddyQty: data.storedPaddyQty,
      huskedBrownRiceQty: data.huskedBrownRiceQty,
      huskQty: data.huskQty,
      huskUsageType: data.huskUsageType,
      huskComplianceStatus: data.huskComplianceStatus,
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
      'source_type': sourceType,
      'storage_id': storageId,
      'stored_paddy_qty': storedPaddyQty,
      'husked_brown_rice_qty': huskedBrownRiceQty,
      'husk_qty': huskQty,
      'husk_usage_type': huskUsageType,
      'husk_compliance_status': huskComplianceStatus,
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
      'source_type': sourceType,
      'storage_id': storageId,
      'stored_paddy_qty': storedPaddyQty,
      'husked_brown_rice_qty': huskedBrownRiceQty,
      'husk_qty': huskQty,
      'husk_usage_type': huskUsageType,
      'husk_compliance_status': huskComplianceStatus,
      'start_time': startTime,
      'end_time': endTime,
      'comments': comments,
    };
  }
}
