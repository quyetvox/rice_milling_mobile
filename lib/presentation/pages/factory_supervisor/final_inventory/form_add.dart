import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:rice_milling_mobile/application/stage/app_final_inventory.dart';
import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/domain/helpers/helpers.dart';
import 'package:rice_milling_mobile/domain/models/admin/product_model.dart';
import 'package:rice_milling_mobile/generated/l10n.dart' as l;
import 'package:rice_milling_mobile/presentation/pages/admin/product/models/product.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/final_inventory/models/final_inventory.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/packaging/models/packaging.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_select.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_text.dart';

class FormAdd extends StatefulWidget {
  const FormAdd({super.key, this.data});
  final MFinalInventory? data;

  @override
  State<FormAdd> createState() => _FormAddState();
}

class _FormAddState extends State<FormAdd> {
  late MFinalInventory termData;

  List<MPackagingQC> lots = [];
  String? lotIndex;
  List<MProduct> finishedProducts = [];
  String? finishedProductIndex;

  final _ctrlLocationId = TextEditingController();
  final _ctrlExistingStock = TextEditingController();
  final _ctrlCurrentStock = TextEditingController();
  final _ctrlTotalAvailableStock = TextEditingController();
  final _ctrlComments = TextEditingController();

  @override
  void initState() {
    super.initState();
    initData();
  }

  fetchingData() async {
    await Future.wait([
      fetchLot(),
      fetchProducts(),
    ]);
  }

  Future fetchLot() async {
    await StorePackagingQC.instance.data.initFetch();
    lots = StorePackagingQC.instance.data.datas ?? [];
  }

  Future fetchProducts() async {
    await StoreProduct.instance.data.initFetch();
    finishedProducts = StoreProduct.instance.data.datas ?? [];
  }

  initData() async {
    await fetchingData();
    if (widget.data == null) {
      termData = MFinalInventory.fromJson({});
    } else {
      termData = MFinalInventory.copy(widget.data!);
      lotIndex = lots
          .indexWhere((e) => e.lotId.toString() == termData.lotId.toString())
          .toString();
      _ctrlLocationId.text = termData.locationId.toString();
      finishedProductIndex = finishedProducts
          .indexWhereOrNull((e) => e.id == termData.finishedProductId);
      _ctrlExistingStock.text = termData.existingStock.toString();
      _ctrlCurrentStock.text = termData.currentStock.toString();
      _ctrlTotalAvailableStock.text = termData.totalAvailableStock.toString();
      _ctrlComments.text = termData.comments;
    }
    setState(() {});
  }

  saveData() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final lot = lots[int.parse(lotIndex ?? '0')];
    termData.lotId = lot.lotId;
    termData.locationId = lot.locationId;
    termData.finishedProductId =
        finishedProducts[int.tryParse(finishedProductIndex ?? '0') ?? 0].id;
    termData.existingStock = num.tryParse(_ctrlExistingStock.text) ?? 0;
    termData.currentStock = num.tryParse(_ctrlCurrentStock.text) ?? 0;
    termData.totalAvailableStock =
        num.tryParse(_ctrlTotalAvailableStock.text) ?? 0;
    termData.comments = _ctrlComments.text;

    print(termData.toMapUpdate());

    if (widget.data == null) {
      final res = await AppFinalInventory.insert(termData.toMapCreate());
      if (!res) return;
    } else {
      final res = await AppFinalInventory.update(
          termData.toMapUpdate(), termData.id.toString());
      if (!res) return;
    }
    Navigator.pop(context, true);
  }

  processSelectLot() {
    final lot = lots[int.parse(lotIndex ?? '0')];
    _ctrlLocationId.text = lot.locationId.toString();
    setState(() {});
  }

  processSelectedFinishProduct() {
    final product = finishedProducts[int.parse(finishedProductIndex ?? '0')];
    _ctrlCurrentStock.text = product.totalStockQty.toString();
    processTotalStock();
  }

  processTotalStock() {
    if (_ctrlCurrentStock.text.isNotEmpty &&
        _ctrlExistingStock.text.isNotEmpty) {
      _ctrlTotalAvailableStock.text = (num.parse(_ctrlCurrentStock.text) +
              num.parse(_ctrlExistingStock.text))
          .toString();
    }
    setState(() {});
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
                    Text(l.S.current.stage_final_processing),
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

              ///---------------- form fields section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 606,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputSelect(
                        label: 'Lot Id',
                        hintText: 'Lot Id',
                        isDisable: widget.data != null,
                        items: lots.map((e) => e.lotId.toString()).toList(),
                        index: lotIndex,
                        onChange: (value) {
                          lotIndex = value;
                          processSelectLot();
                        },
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Location Id',
                        isReadOnly: true,
                        keyboardType: TextInputType.number,
                        controller: _ctrlLocationId,
                      ),
                      const SizedBox(height: 20),
                      InputSelect(
                        label: 'Finished Product Id',
                        hintText: 'Finished Product Id',
                        items: finishedProducts
                            .map((e) => e.productName.toString())
                            .toList(),
                        index: finishedProductIndex,
                        onChange: (value) {
                          finishedProductIndex = value;
                          processSelectedFinishProduct();
                        },
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Existing Stock',
                        keyboardType: TextInputType.text,
                        controller: _ctrlExistingStock,
                        onChanged: (value) {
                          processTotalStock();
                        },
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Current Stock',
                        isReadOnly: true,
                        keyboardType: TextInputType.number,
                        controller: _ctrlCurrentStock,
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Total Available Stock',
                        isReadOnly: true,
                        keyboardType: TextInputType.number,
                        controller: _ctrlTotalAvailableStock,
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Comments',
                        maxlines: 3,
                        controller: _ctrlComments,
                      ),
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
              ),
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
