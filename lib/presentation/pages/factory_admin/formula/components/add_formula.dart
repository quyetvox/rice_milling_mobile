import 'package:rice_milling_mobile/application/factory_admin/app_formula.dart';
import 'package:rice_milling_mobile/infrastructure/storages/index.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/formula/components/form_formula_ingredient.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/domain/models/other/uom_model.dart';
import 'package:rice_milling_mobile/generated/l10n.dart' as l;
import 'package:rice_milling_mobile/presentation/pages/factory_admin/formula/models/formula_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/ingredient/models/ingredient_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/ingredient/models/storage_model.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_text.dart';

class AddFormulaDialog extends StatefulWidget {
  const AddFormulaDialog({super.key, this.mFormula});
  final MFormula? mFormula;

  @override
  State<AddFormulaDialog> createState() => _AddBusinessSettingState();
}

class _AddBusinessSettingState extends State<AddFormulaDialog> {
  late MFormula formula;
  List<MAddFormulaIngredient> formulaIngredientItems = [];

  final _ctrlFormulaName = TextEditingController();
  final _ctrlFormulaCloneName = TextEditingController();
  final _ctrlApproxWastageQty = TextEditingController();
  final _ctrlExpectedYieldPerBatch = TextEditingController();

  String? uomIndex;
  List<MUom> uoms = [];

  String? materialIndex;
  List<MIngredient> materials = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    await fetchingData();
    if (widget.mFormula == null) {
      formula = MFormula.fromJson({});
    } else {
      formula = MFormula.copy(widget.mFormula!);
      _ctrlFormulaName.text = formula.formulaName;
      _ctrlFormulaCloneName.text = formula.cloneFormulaId;
      _ctrlApproxWastageQty.text = formula.approxWastageQty.toString();
      _ctrlExpectedYieldPerBatch.text =
          formula.expectedYieldPerBatch.toString();
      await fetchFormulaIngredient();
    }
    setState(() {});
  }

  saveData() async {
    if (widget.mFormula == null) {
      toCreate();
    } else {
      toUpdate();
    }
  }

  toCreate() async {
    formula.formulaName = _ctrlFormulaName.text;
    formula.cloneFormulaId = _ctrlFormulaCloneName.text;
    formula.approxWastageQty = double.parse(_ctrlApproxWastageQty.text);
    formula.expectedYieldPerBatch =
        double.parse(_ctrlExpectedYieldPerBatch.text);
    final formulaIngredients = formulaIngredientItems
        .map((e) => {
              "uom_id":
                  uoms[int.parse(e.dAddFormulaIngredient.uomIndex ?? '0')].id,
              "material_id": materials[
                      int.parse(e.dAddFormulaIngredient.materialIndex ?? '0')]
                  .id,
              "material_name": materials[
                      int.parse(e.dAddFormulaIngredient.materialIndex ?? '0')]
                  .materialName,
              "qty_required":
                  double.parse(e.dAddFormulaIngredient.ctrlQtyRequired.text),
            })
        .toList();
    print(formula.toMapCreate());
    final res = await AppFormula.insert(
        {...formula.toMapCreate(), 'formula_ingredients': formulaIngredients});
    if (!res) return;
    Navigator.pop(context, true);
  }

  toUpdate() async {
    formula.formulaName = _ctrlFormulaName.text;
    formula.cloneFormulaId = _ctrlFormulaCloneName.text;
    formula.approxWastageQty = double.parse(_ctrlApproxWastageQty.text);
    formula.expectedYieldPerBatch =
        double.parse(_ctrlExpectedYieldPerBatch.text);
    final formulaIngredients = formulaIngredientItems
        .map((e) => {
              "id": e.dAddFormulaIngredient.id!,
              "formula_id": formula.id,
              "uom_id":
                  uoms[int.parse(e.dAddFormulaIngredient.uomIndex ?? '0')].id,
              "material_id": materials[
                      int.parse(e.dAddFormulaIngredient.materialIndex ?? '0')]
                  .id,
              "material_name": materials[
                      int.parse(e.dAddFormulaIngredient.materialIndex ?? '0')]
                  .materialName,
              "qty_required":
                  double.parse(e.dAddFormulaIngredient.ctrlQtyRequired.text),
            })
        .toList();
    final res =
        await AppFormula.update(formula.toMapUpdate(), formulaIngredients);
    if (!res) return;
    Navigator.pop(context, true);
  }

  actionAddMaterial() async {
    formulaIngredientItems.add(MAddFormulaIngredient(
        key: Key(formulaIngredientItems.length.toString()),
        uoms: uoms,
        materials: materials,
        dAddFormulaIngredient: DAddFormulaIngredient(id: 0),
        onRemove: (Key key) {
          formulaIngredientItems.removeWhere((e) => e.key == key);
          setState(() {});
        }));
    setState(() {});
  }

  fetchingData() async {
    await Future.wait([
      fetchUom(),
      fetchMaterial(),
    ]);
  }

  Future fetchFormulaIngredient() async {
    if (widget.mFormula == null) return;
    final res =
        await AppFormula.formulaIngredients(widget.mFormula!.id.toString());
    formulaIngredientItems = res
        .asMap()
        .entries
        .map((e) => MAddFormulaIngredient(
            key: Key(e.key.toString()),
            uoms: uoms,
            materials: materials,
            dAddFormulaIngredient: DAddFormulaIngredient(
                id: e.value.id,
                uomIndex: uoms
                    .indexWhere(
                        (o) => o.id.toString() == e.value.uomId.toString())
                    .toString(),
                materialIndex: materials
                    .indexWhere(
                        (o) => o.id.toString() == e.value.materialId.toString())
                    .toString())
              ..ctrlQtyRequired.text = e.value.qtyRequired.toString(),
            onRemove: (Key key) {
              formulaIngredientItems.removeWhere((e) => e.key == key);
              setState(() {});
            }))
        .toList();
  }

  Future fetchUom() async {
    await Storage.instance.uom.initFetch();
    uoms = Storage.instance.uom.datas ?? [];
  }

  Future fetchMaterial() async {
    await StoreIngredient.instance.data.initFetch();
    materials = StoreIngredient.instance.data.datas ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 480,
          value: _SizeInfo(
            alertFontSize: 12,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 481,
          end: 576,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 577,
          end: 992,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;
    final theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///---------------- header section
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l.S.current.factory_formula),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: AcnooAppColors.kError,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 0.1,
                color: theme.colorScheme.outline,
                height: 0,
              ),

              ///---------------- header section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 606,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputText(
                          label: l.S.current.factory_formula_name,
                          isDisable: widget.mFormula != null,
                          controller: _ctrlFormulaName,
                          onChange: (value) {
                            setState(() {
                              _ctrlFormulaCloneName.text = value;
                            });
                          }),
                      const SizedBox(height: 20),
                      InputText(
                          label: l.S.current.factory_formula_name,
                          controller: _ctrlFormulaCloneName),
                      const SizedBox(height: 20),
                      InputText(
                          label: l.S.current.stage_wastage_qty,
                          keyboardType: TextInputType.number,
                          controller: _ctrlApproxWastageQty),
                      const SizedBox(height: 20),
                      InputText(
                          label: l.S.current.factory_expected_yield_per_batch,
                          keyboardType: TextInputType.number,
                          controller: _ctrlExpectedYieldPerBatch),
                      const SizedBox(height: 20),
                      ...formulaIngredientItems
                          .asMap()
                          .entries
                          .map((e) => e.value),
                      const SizedBox(height: 20),
                      widget.mFormula == null
                          ? _buildButtonAdd(theme, _sizeInfo)
                          : const SizedBox.shrink(),
                      const SizedBox(height: 24),

                      ///---------------- Submit Button section
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: _sizeInfo.innerSpacing),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: _sizeInfo.innerSpacing),
                                  backgroundColor:
                                      theme.colorScheme.primaryContainer,
                                  textStyle: textTheme.bodySmall
                                      ?.copyWith(color: AcnooAppColors.kError),
                                  side: const BorderSide(
                                      color: AcnooAppColors.kError)),
                              onPressed: () => Navigator.pop(context, false),
                              label: Text(
                                lang.cancel,
                                //'Cancel',
                                style: textTheme.bodySmall
                                    ?.copyWith(color: AcnooAppColors.kError),
                              ),
                            ),
                            SizedBox(width: _sizeInfo.innerSpacing),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: _sizeInfo.innerSpacing),
                              ),
                              onPressed: () => saveData(),
                              //label: const Text('Save'),
                              label: Text(lang.save),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonAdd(ThemeData theme, _SizeInfo _sizeInfo) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AcnooAppColors.kSuccess,
        padding: EdgeInsets.symmetric(horizontal: _sizeInfo.innerSpacing),
      ),
      onPressed: () => actionAddMaterial(),
      icon: const Icon(Icons.add),
      label: Text(l.S.current.factory_raw_material),
    );
  }
}

class _SizeInfo {
  final double? alertFontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;
  const _SizeInfo({
    this.alertFontSize = 18,
    this.padding = const EdgeInsets.all(24),
    this.innerSpacing = 24,
  });
}
