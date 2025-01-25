import 'package:rice_milling_mobile/application/stage/app_packaging.dart';
import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/domain/models/admin/product_model.dart';
import 'package:rice_milling_mobile/domain/models/other/pre_stage_model.dart';
import 'package:rice_milling_mobile/infrastructure/storages/index.dart';
import 'package:rice_milling_mobile/infrastructure/storages/store_prestage.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/packaging_stage/models/packaging_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/qc_check_stage/models/qc_check_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/qc_check_stage/models/store_model.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_select.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_text.dart';
import 'package:flutter/material.dart';

import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:rice_milling_mobile/generated/l10n.dart' as l;

class AddPackageDialog extends StatefulWidget {
  const AddPackageDialog({super.key, this.data});
  final MPackagingStage? data;

  @override
  State<AddPackageDialog> createState() => _AddBusinessSettingState();
}

class _AddBusinessSettingState extends State<AddPackageDialog> {
  late MPackagingStage termData;

  String? packageSizeIndex;
  MPreStage preStage = MPreStage.fromMap({});

  String? batchIndex;
  List<MQCCheckStage> batchs = [];

  String? productIndex;
  List<MProduct> products = [];

  final _ctrlQCApprovedProductQty = TextEditingController();
  final _ctrlWastageQty = TextEditingController();
  final _ctrlFinalProductQty = TextEditingController();
  final _ctrlComment = TextEditingController();

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    await fetchingData();
    if (widget.data == null) {
      termData = MPackagingStage.fromJson({});
    } else {
      termData = MPackagingStage.copy(widget.data!);
      batchIndex = batchs
          .indexWhere(
              (e) => e.batchId.toString() == termData.batchId.toString())
          .toString();
      _ctrlQCApprovedProductQty.text = termData.qcApprovedProductQty.toString();
      _ctrlWastageQty.text = termData.wastageQty.toString();
      packageSizeIndex = preStage.stagePackageSize
          .indexWhere((e) => e.toString() == termData.packageSize.toString())
          .toString();
      _ctrlComment.text = termData.comments;
    }
    setState(() {});
  }

  calculateFinalProductQty() {
    if (batchIndex == null || _ctrlWastageQty.text.isEmpty) return;
    _ctrlFinalProductQty.text = (double.parse(_ctrlQCApprovedProductQty.text) -
            double.parse(_ctrlWastageQty.text))
        .toString();
    setState(() {});
  }

  saveData() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final batch = batchs[int.parse(batchIndex ?? '0')];
    termData.batchId = batch.batchId;

    termData.productId = products[int.parse(batchIndex ?? '0')].id;
    termData.qcApprovedProductQty = batch.fineMaterialOutputQty;
    termData.wastageQty = double.parse(_ctrlWastageQty.text);
    termData.packageSize =
        preStage.stagePackageSize[int.parse(packageSizeIndex ?? '0')];

    termData.comments = _ctrlComment.text;
    print(termData.toMapUpdate());

    if (widget.data == null) {
      final res = await AppPackaging.insert(termData.toMapCreate());
      if (!res) return;
    } else {
      final res = await AppPackaging.update(
          termData.toMapUpdate(), termData.id.toString());
      if (!res) return;
    }
    Navigator.pop(context, true);
  }

  fetchingData() async {
    await Future.wait([
      fetchMixing(),
      fetchPreStage(),
      fetchProduct(),
    ]);
  }

  Future fetchMixing() async {
    await StoreQCCheck.instance.data.initFetch();
    batchs = StoreQCCheck.instance.data.datas ?? [];
  }

  Future fetchProduct() async {
    await Storage.instance.product.initFetch();
    products = Storage.instance.product.datas ?? [];
  }

  Future fetchPreStage() async {
    preStage = await StoragePreStage.instance.preStage();
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
                    Text(l.S.current.stage_packaging),
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

              ///---------------- header section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 606,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputSelect(
                        label: l.S.current.stage_batch,
                        hintText: l.S.current.action_select,
                        isDisable: widget.data != null,
                        items: batchs.map((e) => e.batchId.toString()).toList(),
                        index: batchIndex,
                        onChange: (value) {
                          batchIndex = value;
                          _ctrlQCApprovedProductQty.text =
                              batchs[int.parse(batchIndex ?? '0')]
                                  .fineMaterialOutputQty
                                  .toString();
                          calculateFinalProductQty();
                        },
                      ),
                      const SizedBox(height: 20),
                      InputSelect(
                        label: l.S.current.stage_product,
                        hintText: l.S.current.action_select,
                        items: products
                            .map((e) => e.productName.toString())
                            .toList(),
                        index: productIndex,
                        onChange: (value) {
                          productIndex = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputSelect(
                        label: l.S.current.stage_package_size,
                        hintText: l.S.current.action_select,
                        items: preStage.stagePackageSize.map((e) => e).toList(),
                        index: packageSizeIndex,
                        onChange: (value) {
                          packageSizeIndex = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputText(
                          label: l.S.current.stage_wastage_qty,
                          keyboardType: TextInputType.number,
                          onChange: (value) {
                            calculateFinalProductQty();
                          },
                          controller: _ctrlWastageQty),
                      const SizedBox(height: 20),
                      InputText(
                          label: l.S.current.stage_qc_approved_product_qty,
                          isDisable: true,
                          controller: _ctrlQCApprovedProductQty),
                      const SizedBox(height: 20),
                      InputText(
                          label: l.S.current.stage_fine_product_qty,
                          isDisable: true,
                          controller: _ctrlFinalProductQty),
                      const SizedBox(height: 20),
                      InputText(
                          label: l.S.current.stage_comments,
                          maxlines: 3,
                          controller: _ctrlComment),
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
