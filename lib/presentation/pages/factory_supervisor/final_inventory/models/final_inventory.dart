import 'package:rice_milling_mobile/application/stage/app_final_inventory.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';

class StoreFinalInventory {
  StoreFinalInventory._privateConstructor();
  static final StoreFinalInventory instance =
      StoreFinalInventory._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MFinalInventory> {
  @override
  Future<MBaseNextPage<MFinalInventory>?> getApiNextPage() async {
    return await AppFinalInventory.fetch();
  }
}

class MFinalInventory {
  final num id;
  num lotId;
  num locationId;
  num finishedProductId;
  num existingStock;
  num currentStock;
  num totalAvailableStock;
  String comments;
  final num createdAt;

  MFinalInventory({
    required this.id,
    required this.lotId,
    required this.locationId,
    required this.finishedProductId,
    required this.existingStock,
    required this.currentStock,
    required this.totalAvailableStock,
    required this.comments,
    required this.createdAt,
  });

  factory MFinalInventory.fromJson(Map<String, dynamic> json) {
    return MFinalInventory(
      id: num.parse((json['id'] ?? 0).toString()),
      lotId: num.parse((json['lot_id'] ?? 0).toString()),
      locationId: num.parse((json['location_id'] ?? 0).toString()),
      finishedProductId:
          num.parse((json['finished_product_id'] ?? 0).toString()),
      existingStock: num.parse((json['existing_stock'] ?? 0).toString()),
      currentStock: num.parse((json['current_stock'] ?? 0).toString()),
      totalAvailableStock:
          num.parse((json['total_available_stock'] ?? 0).toString()),
      comments: (json['comments'] ?? '').toString(),
      createdAt: num.parse((json['created_at'] ?? 0).toString()),
    );
  }

  factory MFinalInventory.copy(MFinalInventory data) {
    return MFinalInventory(
      id: data.id,
      lotId: data.lotId,
      locationId: data.locationId,
      finishedProductId: data.finishedProductId,
      existingStock: data.existingStock,
      currentStock: data.currentStock,
      totalAvailableStock: data.totalAvailableStock,
      comments: data.comments,
      createdAt: data.createdAt,
    );
  }

  Map<String, dynamic> toMapCreate() {
    return {
      'lot_id': lotId,
      'location_id': locationId,
      'finished_product_id': finishedProductId,
      'existing_stock': existingStock,
      'current_stock': currentStock,
      'total_available_stock': totalAvailableStock,
      'comments': comments,
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      'id': id,
      'lot_id': lotId,
      'location_id': locationId,
      'finished_product_id': finishedProductId,
      'existing_stock': existingStock,
      'current_stock': currentStock,
      'total_available_stock': totalAvailableStock,
      'comments': comments,
    };
  }
}
