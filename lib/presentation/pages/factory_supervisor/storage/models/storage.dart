import 'package:rice_milling_mobile/application/stage/app_storage.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';

class StoreStorageQC {
  StoreStorageQC._privateConstructor();
  static final StoreStorageQC instance = StoreStorageQC._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MStorage> {
  @override
  Future<MBaseNextPage<MStorage>?> getApiNextPage() async {
    return await AppStorage.fetch();
  }
}

class MStorage {
  final num id;
  num lotId;
  num locationId;
  num finalDriedPaddyQty;
  String storageType;
  num storedPaddyQty;
  String storageComplianceStatus;
  num startTime;
  num endTime;
  String comments;
  num createdAt;

  MStorage({
    required this.id,
    required this.lotId,
    required this.locationId,
    required this.finalDriedPaddyQty,
    required this.storageType,
    required this.storedPaddyQty,
    required this.storageComplianceStatus,
    required this.startTime,
    required this.endTime,
    required this.comments,
    required this.createdAt,
  });

  factory MStorage.fromJson(Map<String, dynamic> json) {
    return MStorage(
      id: num.parse((json['id'] ?? 0).toString()),
      lotId: num.parse((json['lot_id'] ?? 0).toString()),
      locationId: num.parse((json['location_id'] ?? 0).toString()),
      finalDriedPaddyQty:
          num.parse((json['final_dried_paddy_qty'] ?? 0).toString()),
      storageType: (json['storage_type'] ?? '').toString(),
      storedPaddyQty: num.parse((json['stored_paddy_qty'] ?? 0).toString()),
      storageComplianceStatus:
          (json['storage_compliance_status'] ?? '').toString(),
      startTime: num.parse((json['start_time'] ?? 0).toString()),
      endTime: num.parse((json['end_time'] ?? 0).toString()),
      comments: (json['comments'] ?? '').toString(),
      createdAt: num.parse((json['created_at'] ?? 0).toString()),
    );
  }

  factory MStorage.copy(MStorage data) {
    return MStorage(
      id: data.id,
      lotId: data.lotId,
      locationId: data.locationId,
      finalDriedPaddyQty: data.finalDriedPaddyQty,
      storageType: data.storageType,
      storedPaddyQty: data.storedPaddyQty,
      storageComplianceStatus: data.storageComplianceStatus,
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
      'final_dried_paddy_qty': finalDriedPaddyQty,
      'storage_type': storageType,
      'stored_paddy_qty': storedPaddyQty,
      'storage_compliance_status': storageComplianceStatus,
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
      'final_dried_paddy_qty': finalDriedPaddyQty,
      'storage_type': storageType,
      'stored_paddy_qty': storedPaddyQty,
      'storage_compliance_status': storageComplianceStatus,
      'start_time': startTime,
      'end_time': endTime,
      'comments': comments,
    };
  }
}
