import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/domain/models/other/uom_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/ingredient/models/ingredient_model.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_select.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_text.dart';
import 'package:flutter/material.dart';
import 'package:rice_milling_mobile/generated/l10n.dart' as l;

class DAddFormulaIngredient {
  int? id;
  String? uomIndex;
  String? materialIndex;
  final ctrlQtyRequired = TextEditingController();
  DAddFormulaIngredient({
    this.id,
    this.uomIndex,
    this.materialIndex,
  });
}

// ignore: must_be_immutable
class MAddFormulaIngredient extends StatelessWidget {
  final DAddFormulaIngredient dAddFormulaIngredient;
  final List<MUom> uoms;
  final List<MIngredient> materials;
  Function(Key key) onRemove;

  MAddFormulaIngredient(
      {super.key,
      required this.uoms,
      required this.materials,
      required this.onRemove,
      required this.dAddFormulaIngredient});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Ingredients and Ratio"),
            dAddFormulaIngredient.id == 0
                ? IconButton(
                    onPressed: () {
                      onRemove(key!);
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 20,
                      color: AcnooAppColors.kError,
                    ))
                : const SizedBox.shrink()
          ],
        ),
        const SizedBox(height: 10),
        InputSelect(
          label: l.S.current.factory_material_name,
          hintText: l.S.current.action_select,
          items: materials.map((e) => e.materialName).toList(),
          index: dAddFormulaIngredient.materialIndex,
          onChange: (value) {
            dAddFormulaIngredient.materialIndex = value;
          },
        ),
        const SizedBox(height: 20),
        InputSelect(
          label: l.S.current.factory_uom,
          hintText: l.S.current.action_select,
          items: uoms.map((e) => e.shortName).toList(),
          index: dAddFormulaIngredient.uomIndex,
          onChange: (value) {
            dAddFormulaIngredient.uomIndex = value;
          },
        ),
        const SizedBox(height: 20),
        InputText(
            label: l.S.current.factory_qty_required,
            keyboardType: TextInputType.number,
            controller: dAddFormulaIngredient.ctrlQtyRequired),
      ],
    );
  }
}
