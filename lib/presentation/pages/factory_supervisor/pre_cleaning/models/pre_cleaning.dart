import 'package:rice_milling_mobile/application/stage/app_pre_cleaning.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';

class StorePreCleaning {
  StorePreCleaning._privateConstructor();
  static final StorePreCleaning instance =
      StorePreCleaning._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MPreCleaning> {
  @override
  Future<MBaseNextPage<MPreCleaning>?> getApiNextPage() async {
    return await AppPreCleaning.fetch();
  }
}

class MPreCleaning {
  final num id;
  num lotId;
  num locationId;
  num paddyInputQty;
  num impuritiesRemoved;
  num unfilledGrainsCollected;
  num finalPreCleanedPaddyQty;
  num startTime;
  num endTime;
  String comments;
  num createdAt;

  MPreCleaning({
    required this.id,
    required this.lotId,
    required this.locationId,
    required this.paddyInputQty,
    required this.impuritiesRemoved,
    required this.unfilledGrainsCollected,
    required this.finalPreCleanedPaddyQty,
    required this.startTime,
    required this.endTime,
    required this.comments,
    required this.createdAt,
  });

  factory MPreCleaning.fromJson(Map<String, dynamic> json) {
    return MPreCleaning(
      id: num.parse((json['id'] ?? 0).toString()),
      lotId: num.parse((json['lot_id'] ?? 0).toString()),
      locationId: num.parse((json['location_id'] ?? 0).toString()),
      paddyInputQty: num.parse((json['paddy_input_qty'] ?? 0).toString()),
      impuritiesRemoved:
          num.parse((json['impurities_removed'] ?? 0).toString()),
      unfilledGrainsCollected:
          num.parse((json['unfilled_grains_collected'] ?? 0).toString()),
      finalPreCleanedPaddyQty:
          num.parse((json['final_pre_cleaned_paddy'] ?? 0).toString()),
      startTime: num.parse((json['start_time'] ?? 0).toString()),
      endTime: num.parse((json['end_time'] ?? 0).toString()),
      comments: (json['comments'] ?? '').toString(),
      createdAt: num.parse((json['created_at'] ?? 0).toString()),
    );
  }

  factory MPreCleaning.copy(MPreCleaning data) {
    return MPreCleaning(
      id: data.id,
      lotId: data.lotId,
      locationId: data.locationId,
      paddyInputQty: data.paddyInputQty,
      impuritiesRemoved: data.impuritiesRemoved,
      unfilledGrainsCollected: data.unfilledGrainsCollected,
      finalPreCleanedPaddyQty: data.finalPreCleanedPaddyQty,
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
      'paddy_input_qty': paddyInputQty,
      'impurities_removed': impuritiesRemoved,
      'unfilled_grains_collected': unfilledGrainsCollected,
      'final_pre_cleaned_paddy_qty': finalPreCleanedPaddyQty,
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
      'paddy_input_qty': paddyInputQty,
      'impurities_removed': impuritiesRemoved,
      'unfilled_grains_collected': unfilledGrainsCollected,
      'final_pre_cleaned_paddy_qty': finalPreCleanedPaddyQty,
      'start_time': startTime,
      'end_time': endTime,
      'comments': comments,
    };
  }
}
