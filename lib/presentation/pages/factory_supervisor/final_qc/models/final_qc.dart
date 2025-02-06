import 'package:rice_milling_mobile/application/stage/app_final_qc.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';

class StoreFinalQC {
  StoreFinalQC._privateConstructor();
  static final StoreFinalQC instance = StoreFinalQC._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MFinalQC> {
  @override
  Future<MBaseNextPage<MFinalQC>?> getApiNextPage() async {
    return await AppFinalQC.fetch();
  }
}

class MFinalQC {
  final num id;
  num lotId;
  num locationId;
  num finishedRiceQty;
  String grainAppearance;
  String grainTexture;
  String tasteProfile;
  num contaminantLevel;
  num brokenGrainProportion;
  num finalOutputQty;
  String qcStatus;
  num inspectionTime;
  num startTime;
  num endTime;
  String comments;
  final num createdAt;

  MFinalQC({
    required this.id,
    required this.lotId,
    required this.locationId,
    required this.finishedRiceQty,
    required this.grainAppearance,
    required this.grainTexture,
    required this.tasteProfile,
    required this.contaminantLevel,
    required this.brokenGrainProportion,
    required this.finalOutputQty,
    required this.qcStatus,
    required this.inspectionTime,
    required this.startTime,
    required this.endTime,
    required this.comments,
    required this.createdAt,
  });

  factory MFinalQC.fromJson(Map<String, dynamic> json) {
    return MFinalQC(
      id: num.parse((json['id'] ?? 0).toString()),
      lotId: num.parse((json['lot_id'] ?? 0).toString()),
      locationId: num.parse((json['location_id'] ?? 0).toString()),
      finishedRiceQty:
          num.parse((json['finished_rice_qty'] ?? 0).toString()),
      grainAppearance: (json['grain_apperance'] ?? '').toString(),
      grainTexture: (json['grain_texture'] ?? '').toString(),
      tasteProfile: (json['taste_profile'] ?? '').toString(),
      contaminantLevel: num.parse((json['contaminant_level'] ?? 0).toString()),
      brokenGrainProportion:
          num.parse((json['broken_grain_proportion'] ?? 0).toString()),
      finalOutputQty: num.parse((json['final_ouput_qty'] ?? 0).toString()),
      qcStatus: (json['qc_status'] ?? '').toString(),
      inspectionTime: num.parse((json['inspection_time'] ?? 0).toString()),
      startTime: num.parse((json['start_time'] ?? 0).toString()),
      endTime: num.parse((json['end_time'] ?? 0).toString()),
      comments: (json['comments'] ?? '').toString(),
      createdAt: num.parse((json['created_at'] ?? 0).toString()),
    );
  }

  factory MFinalQC.copy(MFinalQC data) {
    return MFinalQC(
      id: data.id,
      lotId: data.lotId,
      locationId: data.locationId,
      finishedRiceQty: data.finishedRiceQty,
      grainAppearance: data.grainAppearance,
      grainTexture: data.grainTexture,
      tasteProfile: data.tasteProfile,
      contaminantLevel: data.contaminantLevel,
      brokenGrainProportion: data.brokenGrainProportion,
      finalOutputQty: data.finalOutputQty,
      qcStatus: data.qcStatus,
      inspectionTime: data.inspectionTime,
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
      'finished_rice_qty': finishedRiceQty,
      'grain_apperance': grainAppearance,
      'grain_texture': grainTexture,
      'taste_profile': tasteProfile,
      'contaminant_level': contaminantLevel,
      'broken_grain_proportion': brokenGrainProportion,
      //'final_ouput_qty': finalOutputQty,
      'qc_status': qcStatus,
      'inspection_time': inspectionTime,
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
      'finished_rice_qty': finishedRiceQty,
      'grain_apperance': grainAppearance,
      'grain_texture': grainTexture,
      'taste_profile': tasteProfile,
      'contaminant_level': contaminantLevel,
      'broken_grain_proportion': brokenGrainProportion,
      //'final_ouput_qty': finalOutputQty,
      'qc_status': qcStatus,
      'inspection_time': inspectionTime,
      'start_time': startTime,
      'end_time': endTime,
      'comments': comments,
    };
  }
}
