// 🐦 Flutter imports:
import 'package:rice_milling_mobile/application/factory_admin/app_ingredient.dart';
import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/domain/helpers/extensions/extention_datetime.dart';
import 'package:rice_milling_mobile/domain/models/other/category_model.dart';
import 'package:rice_milling_mobile/domain/models/other/uom_model.dart';
import 'package:rice_milling_mobile/infrastructure/storages/index.dart';
import 'package:rice_milling_mobile/presentation/pages/admin/business_location/models/business_location_model.dart';
import 'package:rice_milling_mobile/presentation/pages/admin/business_location/models/storage_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/ingredient/models/ingredient_model.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_date_picker.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_select.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_text.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import 'package:rice_milling_mobile/generated/l10n.dart' as l;

class AddIngredientDialog extends StatefulWidget {
  const AddIngredientDialog({super.key, this.ingredient});
  final MIngredient? ingredient;

  @override
  State<AddIngredientDialog> createState() => _AddBusinessSettingState();
}

class _AddBusinessSettingState extends State<AddIngredientDialog> {
  late MIngredient ingredient;

  String? categoryIndex;
  List<MCategory> categories = [];

  String? uomIndex;
  List<MUom> uoms = [];

  String? businessLocationIndex;
  List<MBusinessLocation> businessLocations = [];

  final _ctrlMaterialName = TextEditingController();
  final _ctrlInitStock = TextEditingController();
  final _ctrlStockQty = TextEditingController();
  final _ctrlTotalStock = TextEditingController();
  final _ctrlMinimumStock = TextEditingController();
  final _ctrlExpiryDate = TextEditingController();

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    await fetchingData();
    if (widget.ingredient == null) {
      ingredient = MIngredient.fromJson({});
    } else {
      ingredient = MIngredient.copy(widget.ingredient!);
      _ctrlMaterialName.text = ingredient.materialName;
      categoryIndex = categories
          .indexWhere(
              (e) => e.id.toString() == ingredient.categoryId.toString())
          .toString();
      uomIndex = uoms
          .indexWhere((e) => e.id.toString() == ingredient.uomId.toString())
          .toString();
      businessLocationIndex = businessLocations
          .indexWhere((e) =>
              e.id.toString() == ingredient.businessLocationId.toString())
          .toString();
      _ctrlInitStock.text = ingredient.totalCurrentStockQty.toString();
      //_ctrlStockQty.text = ingredient.stockQty.toString();
      _ctrlTotalStock.text = ingredient.totalCurrentStockQty.toString();
      _ctrlMinimumStock.text = ingredient.minimumStockQtyAlert.toString();
      _ctrlExpiryDate.text =
          DateTime.fromMillisecondsSinceEpoch(ingredient.expiryDate as int)
              .convertDateToString;
    }
    setState(() {});
  }

  saveData() async {
    ingredient.materialName = _ctrlMaterialName.text;
    ingredient.categoryId = categories[int.parse(categoryIndex ?? '0')].id;
    ingredient.uomId = uoms[int.parse(uomIndex ?? '0')].id;
    ingredient.businessLocationId =
        businessLocations[int.parse(businessLocationIndex ?? '0')].id;
    ingredient.initialStockQty = double.parse(_ctrlInitStock.text);
    ingredient.stockQty = double.parse(_ctrlStockQty.text);
    ingredient.totalCurrentStockQty = double.parse(_ctrlTotalStock.text);
    ingredient.minimumStockQtyAlert = double.parse(_ctrlMinimumStock.text);
    ingredient.expiryDate = _ctrlExpiryDate.text.convertToDate.convertToInt;

    //print(ingredient.toMapUpdate());
    //return;

    if (widget.ingredient == null) {
      final res = await AppIngredient.insert(ingredient.toMapCreate());
      if (!res) return;
    } else {
      final res = await AppIngredient.update(
          ingredient.toMapUpdate(), ingredient.id.toString());
      if (!res) return;
    }
    Navigator.pop(context, true);
  }

  fetchingData() async {
    await Future.wait([
      fetchCategory(),
      fetchUom(),
      fetchBusinessLocation(),
    ]);
  }

  Future fetchCategory() async {
    await Storage.instance.category.initFetch();
    categories = Storage.instance.category.datas ?? [];
  }

  Future fetchUom() async {
    await Storage.instance.uom.initFetch();
    uoms = Storage.instance.uom.datas ?? [];
  }

  Future fetchBusinessLocation() async {
    await StoreBusinessLocation.instance.data.initFetch();
    businessLocations = StoreBusinessLocation.instance.data.datas ?? [];
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
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l.S.current.factory_raw_material),
                    IconButton(
                      onPressed: () => Navigator.pop(context, false),
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

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 606,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputText(
                          label: l.S.current.factory_material_name,
                          controller: _ctrlMaterialName),
                      const SizedBox(height: 20),
                      InputSelect(
                        label: l.S.current.factory_category,
                        hintText: l.S.current.action_select,
                        items: categories.map((e) => e.categoryName).toList(),
                        index: categoryIndex,
                        onChange: (value) {
                          categoryIndex = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputSelect(
                        label: l.S.current.factory_uom,
                        hintText: l.S.current.action_select,
                        isDisable: widget.ingredient != null,
                        items: uoms.map((e) => e.shortName).toList(),
                        index: uomIndex,
                        onChange: (value) {
                          uomIndex = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputSelect(
                        label: l.S.current.factory_business_location,
                        hintText: l.S.current.action_select,
                        items: businessLocations
                            .map((e) => e.businessName)
                            .toList(),
                        index: businessLocationIndex,
                        onChange: (value) {
                          businessLocationIndex = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: l.S.current.factory_initial_stock_qty,
                        keyboardType: TextInputType.number,
                        isReadOnly: widget.ingredient != null,
                        controller: _ctrlInitStock,
                        onChanged: (value) {
                          if (_ctrlInitStock.text.isEmpty ||
                              _ctrlStockQty.text.isEmpty) return;
                          _ctrlTotalStock.text =
                              (double.parse(_ctrlInitStock.text) +
                                      double.parse(_ctrlStockQty.text))
                                  .toString();
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: l.S.current.factory_stock_qty,
                        keyboardType: TextInputType.number,
                        controller: _ctrlStockQty,
                        onChanged: (value) {
                          if (_ctrlInitStock.text.isEmpty ||
                              _ctrlStockQty.text.isEmpty) return;
                          _ctrlTotalStock.text =
                              (double.parse(_ctrlInitStock.text) +
                                      double.parse(_ctrlStockQty.text))
                                  .toString();
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 20),
                      InputText(
                          label: l.S.current.factory_total_current_stock_qty,
                          keyboardType: TextInputType.number,
                          isReadOnly: true,
                          controller: _ctrlTotalStock),
                      const SizedBox(height: 20),
                      InputText(
                          label: l.S.current.factory_minimum_stock_qty_alert,
                          keyboardType: TextInputType.number,
                          controller: _ctrlMinimumStock),
                      const SizedBox(height: 20),
                      InputDatePicker(
                          label: l.S.current.factory_expiry_date,
                          controller: _ctrlExpiryDate),
                      const SizedBox(height: 24),

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
