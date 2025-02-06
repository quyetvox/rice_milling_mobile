import 'package:rice_milling_mobile/application/stage/app_brown_rice_milling.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';

class StoreBrownRiceProcessingQC {
  StoreBrownRiceProcessingQC._privateConstructor();
  static final StoreBrownRiceProcessingQC instance =
      StoreBrownRiceProcessingQC._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MBrownRiceMilling> {
  @override
  Future<MBaseNextPage<MBrownRiceMilling>?> getApiNextPage() async {
    return await AppBrownRiceMilling.fetch();
  }
}

class MBrownRiceMilling {
  final num id;
  num lotId;
  num locationId;
  num inputHuskedBrownRiceQty;
  num unhuskedPaddyRemoved;
  final num finalBrownRiceQty;
  num startTime;
  num endTime;
  String comments;
  num createdAt;

  MBrownRiceMilling({
    required this.id,
    required this.lotId,
    required this.locationId,
    required this.inputHuskedBrownRiceQty,
    required this.unhuskedPaddyRemoved,
    required this.finalBrownRiceQty,
    required this.startTime,
    required this.endTime,
    required this.comments,
    required this.createdAt,
  });

  factory MBrownRiceMilling.fromJson(Map<String, dynamic> json) {
    return MBrownRiceMilling(
      id: num.parse((json['id'] ?? 0).toString()),
      lotId: num.parse((json['lot_id'] ?? 0).toString()),
      locationId: num.parse((json['location_id'] ?? 0).toString()),
      inputHuskedBrownRiceQty:
          num.parse((json['input_husked_brown_rice_qty'] ?? 0).toString()),
      unhuskedPaddyRemoved:
          num.parse((json['unhusked_paddy_removed'] ?? 0).toString()),
      finalBrownRiceQty:
          num.parse((json['final_brown_rice_qty'] ?? 0).toString()),
      startTime: num.parse((json['start_time'] ?? 0).toString()),
      endTime: num.parse((json['end_time'] ?? 0).toString()),
      comments: (json['comments'] ?? '').toString(),
      createdAt: num.parse((json['created_at'] ?? 0).toString()),
    );
  }

  factory MBrownRiceMilling.copy(MBrownRiceMilling data) {
    return MBrownRiceMilling(
        id: data.id,
        lotId: data.lotId,
        locationId: data.locationId,
        inputHuskedBrownRiceQty: data.inputHuskedBrownRiceQty,
        unhuskedPaddyRemoved: data.unhuskedPaddyRemoved,
        finalBrownRiceQty: data.finalBrownRiceQty,
        startTime: data.startTime,
        endTime: data.endTime,
        comments: data.comments,
        createdAt: data.createdAt);
  }

  Map<String, dynamic> toMapCreate() {
    return {
      'lot_id': lotId,
      'location_id': locationId,
      'input_husked_brown_rice_qty': inputHuskedBrownRiceQty,
      'unhusked_paddy_removed': unhuskedPaddyRemoved,
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
      'input_husked_brown_rice_qty': inputHuskedBrownRiceQty,
      'unhusked_paddy_removed': unhuskedPaddyRemoved,
      'start_time': startTime,
      'end_time': endTime,
      'comments': comments,
    };
  }
}
