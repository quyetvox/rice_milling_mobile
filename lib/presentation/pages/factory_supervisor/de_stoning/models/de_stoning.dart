import 'package:rice_milling_mobile/application/stage/app_de_stoning.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';

class StoreDeStoningQC {
  StoreDeStoningQC._privateConstructor();
  static final StoreDeStoningQC instance =
      StoreDeStoningQC._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MDeStoningQC> {
  @override
  Future<MBaseNextPage<MDeStoningQC>?> getApiNextPage() async {
    return await AppDeStoning.fetch();
  }
}

class MDeStoningQC {
  final num id;
  num lotId;
  num locationId;
  num brownRiceInputQty;
  num stonesRemovedQty;
  final num finalDeStonedBrownRiceQty;
  num startTime;
  num endTime;
  String comments;
  num createdAt;

  MDeStoningQC({
    required this.id,
    required this.lotId,
    required this.locationId,
    required this.brownRiceInputQty,
    required this.stonesRemovedQty,
    required this.finalDeStonedBrownRiceQty,
    required this.startTime,
    required this.endTime,
    required this.comments,
    required this.createdAt,
  });

  factory MDeStoningQC.fromJson(Map<String, dynamic> json) {
    return MDeStoningQC(
      id: num.parse((json['id'] ?? 0).toString()),
      lotId: num.parse((json['lot_id'] ?? 0).toString()),
      locationId: num.parse((json['location_id'] ?? 0).toString()),
      brownRiceInputQty:
          num.parse((json['brown_rice_input_qty'] ?? 0).toString()),
      stonesRemovedQty: num.parse((json['stones_removed_qty'] ?? 0).toString()),
      finalDeStonedBrownRiceQty:
          num.parse((json['final_de_stoned_brown_rice_qty'] ?? 0).toString()),
      startTime: num.parse((json['start_time'] ?? 0).toString()),
      endTime: num.parse((json['end_time'] ?? 0).toString()),
      comments: (json['comments'] ?? '').toString(),
      createdAt: num.parse((json['created_at'] ?? 0).toString()),
    );
  }

  factory MDeStoningQC.copy(MDeStoningQC data) {
    return MDeStoningQC(
      id: data.id,
      lotId: data.lotId,
      locationId: data.locationId,
      brownRiceInputQty: data.brownRiceInputQty,
      stonesRemovedQty: data.stonesRemovedQty,
      finalDeStonedBrownRiceQty: data.finalDeStonedBrownRiceQty,
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
      "brown_rice_input_qty": brownRiceInputQty,
      "stones_removed_qty": stonesRemovedQty,
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
      "brown_rice_input_qty": brownRiceInputQty,
      "stones_removed_qty": stonesRemovedQty,
      'start_time': startTime,
      'end_time': endTime,
      'comments': comments,
    };
  }
}
