import 'package:rice_milling_mobile/domain/fetch_data/models/base_nextpage_model.dart';
import 'package:rice_milling_mobile/infrastructure/apis/factory_admin/api_production_planning.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/production_planning/models/material_allocation_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/production_planning/models/production_planning_model.dart';
import 'package:flutter/foundation.dart';

class AppProductionPlanning {
  static Future<MBaseNextPage<MProductionPlanning>?>
      productionPlannings() async {
    try {
      final res = await ApiProductionPlanning.productionPlannings();
      final datas = res.map((e) => MProductionPlanning.fromJson(e)).toList();
      return MBaseNextPage(totalPage: 1, datas: datas);
    } catch (e) {
      if (kDebugMode) {
        print('AppProductionPlanning productionPlannings error $e');
      }
      return null;
    }
  }

  static Future<bool> insert(Map<String, dynamic> body) async {
    try {
      final res = await ApiProductionPlanning.insert(body);
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppIngredient insert error $e');
      }
      return false;
    }
  }

  static Future<bool> update(Map<String, dynamic> body,
      List<Map<String, dynamic>> materialAllocations) async {
    try {
      final res = await ApiProductionPlanning.update(body, body['id'].toString());
      for (final e in materialAllocations) {
        ApiProductionPlanning.updateMaterialAllocation(e, e['id'].toString());
      }
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('AppProductionPlanning update error $e');
      }
      return false;
    }
  }

  static Future<List<MMaterialAllocation>> materialAllocations(
      String productionId) async {
    try {
      final res = await ApiProductionPlanning.materialAllocations(productionId);
      final datas = res.map((e) => MMaterialAllocation.fromMap(e)).toList();
      return datas;
    } catch (e) {
      if (kDebugMode) {
        print('AppProductionPlanning materialAllocations error $e');
      }
      return [];
    }
  }
}
