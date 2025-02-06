import 'package:rice_milling_mobile/application/admin/app_milling_factory.dart';
import 'package:rice_milling_mobile/domain/fetch_data/fetching_next_page.dart';
import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';

class StoreMillingFactory {
  StoreMillingFactory._privateConstructor();
  static final StoreMillingFactory instance = StoreMillingFactory._privateConstructor();

  final FData data = FData();

  clear() => data.clear();
}

class FData extends FetchingNextPage<MMillingFactory> {
  @override
  Future<MBaseNextPage<MMillingFactory>?> getApiNextPage() async {
    return await AppMillingFactory.fetch();
  }
}

class MMillingFactory {
  final num id;
  final String name;
  final num capacityMt;
  final String type;
  final String address;
  final String contactPerson;
  final String contactNumber;
  final num createdAt;

  MMillingFactory({
    required this.id,
    required this.name,
    required this.capacityMt,
    required this.type,
    required this.address,
    required this.contactPerson,
    required this.contactNumber,
    required this.createdAt,
  });

  factory MMillingFactory.fromJson(Map<String, dynamic> json) {
    return MMillingFactory(
      id: num.parse((json['id'] ?? 0).toString()),
      name: (json['name'] ?? '').toString(),
      capacityMt: num.parse((json['capacity_mt'] ?? 0).toString()),
      type: (json['type'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      contactPerson: (json['contact_person'] ?? '').toString(),
      contactNumber: (json['contact_number'] ?? '').toString(),
      createdAt: num.parse((json['created_at'] ?? 0).toString()),
    );
  }
}
