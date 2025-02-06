import 'package:rice_milling_mobile/application/factory_admin/app_sourcing_material.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';

class StoreSourcingMaterial {
  StoreSourcingMaterial._privateConstructor();
  static final StoreSourcingMaterial instance = StoreSourcingMaterial._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MSourcingMaterial> {
  @override
  Future<MBaseNextPage<MSourcingMaterial>?> getApiNextPage() async {
    return await AppSourcingMaterial.fetch();
  }
}

class MSourcingMaterial {
  final num id;
  final String sourcingId;
  final num sourcingDate;
  final num farmerId;
  final num totalLandHolding;
  final num vehicleId;
  final num vehicleCapacity;
  final String sourceLocation;
  final num destinationLocation;
  final num cropVariety;
  final num qtySourced;
  final num lotId;
  final String comments;
  final num createdAt;

  MSourcingMaterial({
    required this.id,
    required this.sourcingId,
    required this.sourcingDate,
    required this.farmerId,
    required this.totalLandHolding,
    required this.vehicleId,
    required this.vehicleCapacity,
    required this.sourceLocation,
    required this.destinationLocation,
    required this.cropVariety,
    required this.qtySourced,
    required this.lotId,
    required this.comments,
    required this.createdAt,
  });

  factory MSourcingMaterial.fromJson(Map<String, dynamic> json) {
    return MSourcingMaterial(
      id: num.parse((json['id'] ?? 0).toString()),
      sourcingId: (json['sourcing_id'] ?? '').toString(),
      sourcingDate: num.parse((json['sourcing_date'] ?? 0).toString()),
      farmerId: num.parse((json['farmer_id'] ?? 0).toString()),
      totalLandHolding: num.parse((json['total_land_holding'] ?? 0).toString()),
      vehicleId: num.parse((json['vehicle_id'] ?? 0).toString()),
      vehicleCapacity: num.parse((json['vehicle_capacity'] ?? 0).toString()),
      sourceLocation: (json['source_location'] ?? '').toString(),
      destinationLocation:
          num.parse((json['destination_location'] ?? 0).toString()),
      cropVariety: num.parse((json['crop_variety'] ?? 0).toString()),
      qtySourced: num.parse((json['qty_sourced'] ?? 0).toString()),
      lotId: num.parse((json['lot_id'] ?? 0).toString()),
      comments: (json['comments'] ?? '').toString(),
      createdAt: num.parse((json['created_at'] ?? 0).toString()),
    );
  }
}
