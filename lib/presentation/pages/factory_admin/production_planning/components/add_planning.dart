// 🐦 Flutter imports:
import 'package:rice_milling_mobile/application/factory_admin/app_production_planning.dart';
import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/domain/helpers/extensions/extensions.dart';
import 'package:rice_milling_mobile/domain/helpers/extensions/extention_datetime.dart';
import 'package:rice_milling_mobile/domain/models/formula_ingredient/formula_ingredient_model.dart';
import 'package:rice_milling_mobile/domain/models/other/uom_model.dart';
import 'package:rice_milling_mobile/infrastructure/storages/index.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/formula/models/storage_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/production_planning/components/form_material_allocation.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/production_planning/models/material_allocation_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/production_planning/models/production_planning_model.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_date_picker.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_select.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_text.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:rice_milling_mobile/generated/l10n.dart' as l;

class AddPlanningDialog extends StatefulWidget {
  const AddPlanningDialog({super.key, this.mProductionPlanning});
  final MProductionPlanning? mProductionPlanning;

  @override
  State<AddPlanningDialog> createState() => _AddBusinessSettingState();
}

class _AddBusinessSettingState extends State<AddPlanningDialog> {
  late MProductionPlanning mProductionPlanning;

  List<MAddMaterialAllocation> materialAllocationitems = [];

  List<DFormulaIngredient> allFormulas = [];

  String? formulaIndex;
  List<DFormulaIngredient> formulas = [];

  String? materialIndex;
  List<DFormulaIngredient> materials = [];

  String? uomIndex;
  List<MUom> uoms = [];

  final _ctrlTotalBatchQty = TextEditingController();
  final _ctrlStartDate = TextEditingController();
  final _ctrlEndDate = TextEditingController();
  final _ctrlShift = TextEditingController();
  final _ctrlStatus = TextEditingController();

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    _ctrlTotalBatchQty.dispose();
    _ctrlStartDate.dispose();
    _ctrlEndDate.dispose();
    _ctrlShift.dispose();
    _ctrlStatus.dispose();
    materialAllocationitems.forEach((e) => e.dAddMaterialAllocation.dispose());
    super.dispose();
  }

  String? indexWhereOrNull(List<DFormulaIngredient> datas, String condition) {
    final index = datas.indexWhere((e) => e.iId.toString() == condition);
    if (index == -1) return null;
    return index.toString();
  }

  initData() async {
    await fetchingData();
    if (widget.mProductionPlanning == null) {
      mProductionPlanning = MProductionPlanning.fromJson({});
    } else {
      mProductionPlanning =
          MProductionPlanning.copy(widget.mProductionPlanning!);
      formulaIndex = formulas
          .indexWhere((e) =>
              e.fId.toString() == mProductionPlanning.formulaId.toString())
          .toString();
      materials = allFormulas
          .where((e) =>
              e.fId.toString() == mProductionPlanning.formulaId.toString())
          .toList();
      await fetchMaterialAllocation();
      _ctrlTotalBatchQty.text = mProductionPlanning.totalBatchQty.toString();
      _ctrlStartDate.text = DateTime.fromMillisecondsSinceEpoch(
              mProductionPlanning.startDate as int)
          .convertDateToString;
      _ctrlEndDate.text = DateTime.fromMillisecondsSinceEpoch(
              mProductionPlanning.endDate as int)
          .convertDateToString;
      _ctrlShift.text = mProductionPlanning.shift;
      _ctrlStatus.text = mProductionPlanning.status;
    }
    setState(() {});
  }

  saveData() async {
    mProductionPlanning.formulaId = materials[0].fId;
    mProductionPlanning.totalBatchQty = double.parse(_ctrlTotalBatchQty.text);
    mProductionPlanning.startDate =
        _ctrlStartDate.text.convertToDate.convertToInt;
    mProductionPlanning.endDate = _ctrlEndDate.text.convertToDate.convertToInt;
    mProductionPlanning.shift = _ctrlShift.text;
    mProductionPlanning.status = _ctrlStatus.text;
    final _allocations = materialAllocationitems
        .map((e) => MMaterialAllocation(
              id: e.dAddMaterialAllocation.id ?? 0,
              materialId: materials[
                      int.parse(e.dAddMaterialAllocation.materialIndex ?? '0')]
                  .iId,
              materialQty:
                  double.parse(e.dAddMaterialAllocation.ctrlMaterialQty.text),
              availableStock: double.parse(
                  e.dAddMaterialAllocation.ctrlAvailableStock.text),
              remainingStock: double.parse(
                  e.dAddMaterialAllocation.ctrlRemainingStock.text),
              uomId:
                  uoms[int.parse(e.dAddMaterialAllocation.uomIndex ?? '0')].id,
              uomShortName:
                  uoms[int.parse(e.dAddMaterialAllocation.uomIndex ?? '0')]
                      .shortName,
            ).toMap())
        .toList();
    print({
      ...mProductionPlanning.toMapUpdate(),
      "material_allocations": _allocations
    });
    if (widget.mProductionPlanning == null) {
      final res = await AppProductionPlanning.insert({
        ...mProductionPlanning.toMapUpdate(),
        "material_allocations": _allocations
      });
      if (!res) return;
    } else {
      final res = await AppProductionPlanning.update(
          mProductionPlanning.toMapUpdate(), _allocations);
      if (!res) return;
    }
    Navigator.pop(context, true);
  }

  fetchingData() async {
    await Future.wait([
      fetchUom(),
      fetchFormula(),
    ]);
  }

  Future fetchUom() async {
    await Storage.instance.uom.initFetch();
    uoms = Storage.instance.uom.datas ?? [];
  }

  Future fetchFormula() async {
    await StoreFormulaIngredientDDown.instance.data.initFetch();
    allFormulas = StoreFormulaIngredientDDown.instance.data.datas ?? [];
    formulas = allFormulas.distinctBy((e) => e.fId).toList();
  }

  Future fetchMaterialAllocation() async {
    if (mProductionPlanning.materialAllocations == null) {
      final res = await AppProductionPlanning.materialAllocations(
          mProductionPlanning.id.toString());
      widget.mProductionPlanning!.materialAllocations = res;
      mProductionPlanning.materialAllocations = res;
    }
    materialAllocationitems = mProductionPlanning.materialAllocations!
        .asMap()
        .entries
        .map((e) => MAddMaterialAllocation(
            key: Key(e.key.toString()),
            uoms: uoms,
            materials: materials,
            dAddMaterialAllocation: DAddMaterialAllocation(
                totalBatchQty: _ctrlTotalBatchQty.text,
                id: e.value.id,
                uomIndex: uoms
                    .indexWhere(
                        (o) => o.id.toString() == e.value.uomId.toString())
                    .toString(),
                materialIndex: materials
                    .indexWhere((o) =>
                        o.iId.toString() == e.value.materialId.toString())
                    .toString())
              ..ctrlMaterialQty.text = e.value.materialQty.toString()
              ..ctrlAvailableStock.text = e.value.availableStock.toString()
              ..ctrlRemainingStock.text = e.value.remainingStock.toString(),
            onRemove: (Key key) {
              materialAllocationitems.removeWhere((e) => e.key == key);
              setState(() {});
            }))
        .toList();
  }

  actionAddMaterial() {
    if (formulaIndex == null || _ctrlTotalBatchQty.text.isEmpty) return;
    materialAllocationitems = materials
        .asMap()
        .entries
        .map((e) => MAddMaterialAllocation(
              key: Key(e.key.toString()),
              uoms: uoms,
              materials: materials,
              dAddMaterialAllocation: DAddMaterialAllocation(
                totalBatchQty: _ctrlTotalBatchQty.text,
                id: 0,
                materialIndex: e.key.toString(),
                uomIndex: uoms
                    .indexWhere(
                        (o) => o.id.toString() == e.value.uomId.toString())
                    .toString(),
              ),
              onRemove: (Key key) {
                //materialAllocationitems.removeWhere((e) => e.key == key);
                //setState(() {});
              },
            ))
        .toList();
    setState(() {});
  }

  resetAutocompleteData() {
    materialIndex = null;
    materialAllocationitems.forEach((e) => e.dAddMaterialAllocation.dispose());
    actionAddMaterial();
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
    TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
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
                    Text(l.S.current.factory_planning),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
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
                      InputSelect(
                        label: l.S.current.factory_formula_name,
                        hintText: l.S.current.action_select,
                        isDisable: widget.mProductionPlanning != null,
                        items: formulas.map((e) => e.formulaName).toList(),
                        index: formulaIndex,
                        onChange: (value) {
                          formulaIndex = value;
                          final fId =
                              formulas[int.parse(formulaIndex ?? '0')].fId;
                          materials =
                              allFormulas.where((e) => e.fId == fId).toList();
                          resetAutocompleteData();
                        },
                      ),
                      const SizedBox(height: 20),
                      InputText(
                          label: l.S.current.factory_total_batch_qty,
                          isReadOnly: widget.mProductionPlanning != null,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            resetAutocompleteData();
                          },
                          controller: _ctrlTotalBatchQty),
                      const SizedBox(height: 20),
                      InputDatePicker(
                          label: l.S.current.factory_start_date,
                          controller: _ctrlStartDate),
                      const SizedBox(height: 20),
                      InputDatePicker(
                          label: l.S.current.factory_end_date,
                          controller: _ctrlEndDate),
                      const SizedBox(height: 20),
                      InputText(
                          label: l.S.current.factory_shift_or_time_slot,
                          keyboardType: TextInputType.text,
                          controller: _ctrlShift),
                      const SizedBox(height: 20),
                      InputText(
                          label: l.S.current.factory_status,
                          keyboardType: TextInputType.text,
                          controller: _ctrlStatus),
                      const SizedBox(height: 20),
                      ...materialAllocationitems
                          .asMap()
                          .entries
                          .map((e) => e.value),
                      // const SizedBox(height: 20),
                      // widget.mProductionPlanning == null
                      //     ? _buildButtonAdd(theme, _sizeInfo)
                      //     : const SizedBox.shrink(),
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
      label: Text(l.S.current.factory_material_allocation),
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
