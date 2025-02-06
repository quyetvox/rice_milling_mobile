import 'package:rice_milling_mobile/domain/models/formula_ingredient/formula_ingredient_model.dart';
import 'package:rice_milling_mobile/domain/models/other/uom_model.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_select.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_text.dart';
import 'package:flutter/material.dart';
import 'package:rice_milling_mobile/generated/l10n.dart' as l;

class DAddMaterialAllocation {
  int? id;
  String? uomIndex;
  String? materialIndex;
  String totalBatchQty;
  final ctrlMaterialQty = TextEditingController();
  final ctrlAvailableStock = TextEditingController();
  final ctrlRemainingStock = TextEditingController();
  DAddMaterialAllocation({
    this.id,
    this.uomIndex,
    this.materialIndex,
    required this.totalBatchQty,
  });

  dispose() {
    ctrlMaterialQty.dispose();
    ctrlAvailableStock.dispose();
    ctrlRemainingStock.dispose();
  }
}

// ignore: must_be_immutable
class MAddMaterialAllocation extends StatefulWidget {
  final DAddMaterialAllocation dAddMaterialAllocation;
  final List<MUom> uoms;
  final List<DFormulaIngredient> materials;
  Function(Key key) onRemove;

  MAddMaterialAllocation(
      {super.key,
      required this.uoms,
      required this.materials,
      required this.onRemove,
      required this.dAddMaterialAllocation}) {
    if (dAddMaterialAllocation.id == 0) {
      if (dAddMaterialAllocation.totalBatchQty.isEmpty) return;
      final _material =
          materials[int.parse(dAddMaterialAllocation.materialIndex ?? '0')];
      dAddMaterialAllocation.ctrlMaterialQty.text =
          _material.qtyRequired.toString();
      dAddMaterialAllocation.ctrlAvailableStock.text =
          _material.totalCurrentStockQty.toString();
      dAddMaterialAllocation.uomIndex = uoms
          .indexWhere((e) => e.id.toString() == _material.uomId.toString())
          .toString();
      String uomShortName =
          uoms[int.parse(dAddMaterialAllocation.uomIndex ?? '0')].shortName;
      dAddMaterialAllocation.ctrlRemainingStock.text = _material
          .calculateRemainingStock(
              uomShortName, double.parse(dAddMaterialAllocation.totalBatchQty))
          .toStringAsFixed(2);
    }
  }

  @override
  State<MAddMaterialAllocation> createState() => _MAddFormulaIngredientState();
}

class _MAddFormulaIngredientState extends State<MAddMaterialAllocation> {
  // autocompleteData() {
  //   if (widget.dAddMaterialAllocation.totalBatchQty.isEmpty) return;
  //   final _material = widget.materials[
  //       int.parse(widget.dAddMaterialAllocation.materialIndex ?? '0')];
  //   widget.dAddMaterialAllocation.ctrlMaterialQty.text =
  //       _material.qtyRequired.toString();
  //   widget.dAddMaterialAllocation.ctrlAvailableStock.text =
  //       _material.totalCurrentStockQty.toString();
  //   widget.dAddMaterialAllocation.uomIndex = widget.uoms
  //       .indexWhere((e) => e.id.toString() == _material.uomId.toString())
  //       .toString();
  //   String uomShortName = widget
  //       .uoms[int.parse(widget.dAddMaterialAllocation.uomIndex ?? '0')]
  //       .shortName;
  //   widget.dAddMaterialAllocation.ctrlRemainingStock.text = _material
  //       .calculateRemainingStock(uomShortName,
  //           double.parse(widget.dAddMaterialAllocation.totalBatchQty))
  //       .toStringAsFixed(2);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Divider(),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Ingredients and Ratio"),
            SizedBox.shrink()
          ],
        ),
        const SizedBox(height: 10),
        InputSelect(
          label: l.S.current.factory_material_name,
          hintText: l.S.current.action_select,
          items: widget.materials.map((e) => e.materialName).toList(),
          isDisable: true,
          index: widget.dAddMaterialAllocation.materialIndex,
          onChange: (value) {
            widget.dAddMaterialAllocation.materialIndex = value;
            //autocompleteData();
          },
        ),
        const SizedBox(height: 20),
        InputSelect(
          label: l.S.current.factory_uom,
          hintText: l.S.current.action_select,
          isDisable: true,
          items: widget.uoms.map((e) => e.shortName).toList(),
          index: widget.dAddMaterialAllocation.uomIndex,
          onChange: (value) {
            widget.dAddMaterialAllocation.uomIndex = value;
          },
        ),
        const SizedBox(height: 20),
        InputText(
            label: l.S.current.factory_material_qty_allocated,
            hintText: l.S.current.action_select,
            isReadOnly: true,
            controller: widget.dAddMaterialAllocation.ctrlMaterialQty),
        const SizedBox(height: 20),
        InputText(
            label: l.S.current.factory_available_stock,
            isReadOnly: true,
            controller: widget.dAddMaterialAllocation.ctrlAvailableStock),
        const SizedBox(height: 20),
        InputText(
            label: l.S.current.factory_remaining_stock_after_alloc,
            isReadOnly: true,
            controller: widget.dAddMaterialAllocation.ctrlRemainingStock),
      ],
    );
  }
}
