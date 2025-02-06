import 'package:rice_milling_mobile/application/stage/app_whitening_polishing.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';

class StoreWhiteningSemiPolishingQC {
  StoreWhiteningSemiPolishingQC._privateConstructor();
  static final StoreWhiteningSemiPolishingQC instance =
      StoreWhiteningSemiPolishingQC._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MWhiteningSemiPolishingQC> {
  @override
  Future<MBaseNextPage<MWhiteningSemiPolishingQC>?> getApiNextPage() async {
    return await AppWhiteningPolishing.fetch();
  }
}

class MWhiteningSemiPolishingQC {
  final num id;
  num lotId;
  num locationId;
  num deStonedBrownRice;
  num whiteRiceOutput;
  num riceBranCollected;
  num startTime;
  num endTime;
  String comments;
  num createdAt;

  MWhiteningSemiPolishingQC({
    required this.id,
    required this.lotId,
    required this.locationId,
    required this.deStonedBrownRice,
    required this.whiteRiceOutput,
    required this.riceBranCollected,
    required this.startTime,
    required this.endTime,
    required this.comments,
    required this.createdAt,
  });

  factory MWhiteningSemiPolishingQC.fromJson(Map<String, dynamic> json) {
    return MWhiteningSemiPolishingQC(
      id: num.parse((json['id'] ?? 0).toString()),
      lotId: num.parse((json['lot_id'] ?? 0).toString()),
      locationId: num.parse((json['location_id'] ?? 0).toString()),
      deStonedBrownRice:
          num.parse((json['de_stoned_brown_rice_qty'] ?? 0).toString()),
      whiteRiceOutput: num.parse((json['white_rice_output_qty'] ?? 0).toString()),
      riceBranCollected:
          num.parse((json['rice_bran_collected_qty'] ?? 0).toString()),
      startTime: num.parse((json['start_time'] ?? 0).toString()),
      endTime: num.parse((json['end_time'] ?? 0).toString()),
      comments: (json['comments'] ?? '').toString(),
      createdAt: num.parse((json['created_at'] ?? 0).toString()),
    );
  }

  factory MWhiteningSemiPolishingQC.copy(MWhiteningSemiPolishingQC data) {
    return MWhiteningSemiPolishingQC(
      id: data.id,
      lotId: data.lotId,
      locationId: data.locationId,
      deStonedBrownRice: data.deStonedBrownRice,
      whiteRiceOutput: data.whiteRiceOutput,
      riceBranCollected: data.riceBranCollected,
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
      'de_stoned_brown_rice_qty': deStonedBrownRice,
      'white_rice_output_qty': whiteRiceOutput,
      'rice_bran_collected_qty': riceBranCollected,
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
      'de_stoned_brown_rice_qty': deStonedBrownRice,
      'white_rice_output_qty': whiteRiceOutput,
      'rice_bran_collected_qty': riceBranCollected,
      'start_time': startTime,
      'end_time': endTime,
      'comments': comments,
    };
  }
}
