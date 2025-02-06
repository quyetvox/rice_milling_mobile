import 'package:rice_milling_mobile/application/stage/app_sortex.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';

class StoreSortexQC {
  StoreSortexQC._privateConstructor();
  static final StoreSortexQC instance = StoreSortexQC._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MSortexQC> {
  @override
  Future<MBaseNextPage<MSortexQC>?> getApiNextPage() async {
    return await AppSortex.fetch();
  }
}

class MSortexQC {
  final num id;
  num lotId;
  num locationId;
  num inputWhiteRiceQty;
  num redYellowKernels;
  num damagedKernel;
  num paddyKernel;
  num chalkyKernel;
  final num finalSortexOutputQty;
  String sortexComplianceStatus;
  num startTime;
  num endTime;
  String comments;
  num createdAt;

  MSortexQC({
    required this.id,
    required this.lotId,
    required this.locationId,
    required this.inputWhiteRiceQty,
    required this.redYellowKernels,
    required this.damagedKernel,
    required this.paddyKernel,
    required this.chalkyKernel,
    required this.finalSortexOutputQty,
    required this.sortexComplianceStatus,
    required this.startTime,
    required this.endTime,
    required this.comments,
    required this.createdAt,
  });

  factory MSortexQC.fromJson(Map<String, dynamic> json) {
    return MSortexQC(
      id: num.parse((json['id'] ?? 0).toString()),
      lotId: num.parse((json['lot_id'] ?? 0).toString()),
      locationId: num.parse((json['location_id'] ?? 0).toString()),
      inputWhiteRiceQty:
          num.parse((json['input_white_rice_qty'] ?? 0).toString()),
      redYellowKernels: num.parse((json['red_yellow_kernels'] ?? 0).toString()),
      damagedKernel: num.parse((json['damaged_kernels'] ?? 0).toString()),
      paddyKernel: num.parse((json['paddy_kernels'] ?? 0).toString()),
      chalkyKernel: num.parse((json['chalky_kernels'] ?? 0).toString()),
      finalSortexOutputQty:
          num.parse((json['final_sortex_output_qty'] ?? 0).toString()),
      sortexComplianceStatus:
          (json['sortex_compliance_status'] ?? '').toString(),
      startTime: num.parse((json['start_time'] ?? 0).toString()),
      endTime: num.parse((json['end_time'] ?? 0).toString()),
      comments: (json['comments'] ?? '').toString(),
      createdAt: num.parse((json['created_at'] ?? 0).toString()),
    );
  }

  factory MSortexQC.copy(MSortexQC data) {
    return MSortexQC(
      id: data.id,
      lotId: data.lotId,
      locationId: data.locationId,
      inputWhiteRiceQty: data.inputWhiteRiceQty,
      redYellowKernels: data.redYellowKernels,
      damagedKernel: data.damagedKernel,
      paddyKernel: data.paddyKernel,
      chalkyKernel: data.chalkyKernel,
      finalSortexOutputQty: data.finalSortexOutputQty,
      sortexComplianceStatus: data.sortexComplianceStatus,
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
      'input_white_rice_qty': inputWhiteRiceQty,
      'red_yellow_kernels': redYellowKernels,
      'damaged_kernels': damagedKernel,
      'paddy_kernels': paddyKernel,
      'chalky_kernels': chalkyKernel,
      //'final_sortex_output': finalSortexOutput,
      'sortex_compliance_status': sortexComplianceStatus,
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
      'input_white_rice_qty': inputWhiteRiceQty,
      'red_yellow_kernels': redYellowKernels,
      'damaged_kernels': damagedKernel,
      'paddy_kernels': paddyKernel,
      'chalky_kernels': chalkyKernel,
      //'final_sortex_output': finalSortexOutput,
      'sortex_compliance_status': sortexComplianceStatus,
      'start_time': startTime,
      'end_time': endTime,
      'comments': comments,
    };
  }
}
