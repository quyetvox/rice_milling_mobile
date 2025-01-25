import 'package:rice_milling_mobile/application/factory_admin/app_formula.dart';
import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/infrastructure/storages/index.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/formula/models/formula_ingredient_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/formula/models/formula_model.dart';
import 'package:rice_milling_mobile/presentation/widgets/loading/future_builder_common.dart';
import 'package:flutter/material.dart';
import 'package:rice_milling_mobile/generated/l10n.dart' as l;

// ignore: must_be_immutable
class ViewFormulaIngredient extends StatelessWidget {
  final MFormula formula;
  ViewFormulaIngredient({super.key, required this.formula});

  late TextTheme textTheme;

  Future<List<MFormulaIngredient>> fetchFormulaIngredient() async {
    await Storage.instance.uom.initFetch();
    if (formula.formulaIngredients == null) {
      final res = await AppFormula.formulaIngredients(formula.id.toString());
      formula.formulaIngredients = res;
    }
    return formula.formulaIngredients!;
  }

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      content: FutureBuilderCommmon<List<MFormulaIngredient>>(
        future: fetchFormulaIngredient(),
        child: (datas) {
          if (datas.isEmpty) {
            return Text(
              l.S.current.no_data,
              style: textTheme.bodySmall?.copyWith(
                color: AcnooAppColors.kBlackColor,
                fontWeight: FontWeight.normal,
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: datas.map((e) => _itemFormulaIngredient(e)).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _itemFormulaIngredient(MFormulaIngredient item) {
    return Column(
      children: [
        const Divider(),
        properties('${l.S.current.factory_formula}:', formula.formulaName),
        properties('${l.S.current.factory_material_name}:', item.materialName),
        properties('${l.S.current.factory_qty_required}:',
            item.qtyRequired.toString()),
        properties(
            '${l.S.current.factory_uom}:',
            Storage.instance.uom.datas!
                .firstWhere((e) => e.id.toString() == item.uomId.toString())
                .name),
      ],
    );
  }

  Widget properties(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title,
              style: textTheme.bodySmall?.copyWith(
                color: AcnooAppColors.kBlackColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodySmall?.copyWith(
                color: AcnooAppColors.kBlackColor,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
