import 'package:rice_milling_mobile/application/stage/app_packaging.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';

class StorePackagingQC {
  StorePackagingQC._privateConstructor();
  static final StorePackagingQC instance =
      StorePackagingQC._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MPackagingQC> {
  @override
  Future<MBaseNextPage<MPackagingQC>?> getApiNextPage() async {
    return await AppPackaging.fetch();
  }
}

class MPackagingQC {
  final num id;
  num lotId;
  num locationId;
  num blendedRiceInputQty;
  int unitsPacked;
  num weightPerUnit;
  String qrCode;
  String packagingComplianceStatus;
  num startTime;
  num endTime;
  String comments;
  num createdAt;

  MPackagingQC({
    required this.id,
    required this.lotId,
    required this.locationId,
    required this.blendedRiceInputQty,
    required this.unitsPacked,
    required this.weightPerUnit,
    required this.qrCode,
    required this.packagingComplianceStatus,
    required this.startTime,
    required this.endTime,
    required this.comments,
    required this.createdAt,
  });

  factory MPackagingQC.fromJson(Map<String, dynamic> json) {
    return MPackagingQC(
      id: num.parse((json['id'] ?? 0).toString()),
      lotId: num.parse((json['lot_id'] ?? 0).toString()),
      locationId: num.parse((json['location_id'] ?? 0).toString()),
      blendedRiceInputQty: num.parse((json['blended_rice_input_qty'] ?? 0).toString()),
      unitsPacked: int.parse((json['units_packed'] ?? 0).toString()),
      weightPerUnit: num.parse((json['weight_per_unit'] ?? 0).toString()),
      qrCode: (json['qr_code'] ?? '').toString(),
      packagingComplianceStatus:
          (json['package_compliance_status'] ?? '').toString(),
      startTime: num.parse((json['start_time'] ?? 0).toString()),
      endTime: num.parse((json['end_time'] ?? 0).toString()),
      comments: (json['comments'] ?? '').toString(),
      createdAt: num.parse((json['created_at'] ?? 0).toString()),
    );
  }

  factory MPackagingQC.copy(MPackagingQC data) {
    return MPackagingQC(
      id: data.id,
      lotId: data.lotId,
      locationId: data.locationId,
      blendedRiceInputQty: data.blendedRiceInputQty,
      unitsPacked: data.unitsPacked,
      weightPerUnit: data.weightPerUnit,
      qrCode: data.qrCode,
      packagingComplianceStatus: data.packagingComplianceStatus,
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
      'blended_rice_input_qty': blendedRiceInputQty,
      'units_packed': unitsPacked,
      'weight_per_unit': weightPerUnit,
      'qr_code': qrCode,
      'package_compliance_status': packagingComplianceStatus,
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
      'blended_rice_input_qty': blendedRiceInputQty,
      'units_packed': unitsPacked,
      'weight_per_unit': weightPerUnit,
      'qr_code': qrCode,
      'package_compliance_status': packagingComplianceStatus,
      'start_time': startTime,
      'end_time': endTime,
      'comments': comments,
    };
  }
}
