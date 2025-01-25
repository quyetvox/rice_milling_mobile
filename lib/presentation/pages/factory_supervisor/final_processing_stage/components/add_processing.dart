import 'package:rice_milling_mobile/application/stage/app_final_processing.dart';
import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/domain/helpers/extensions/extention_datetime.dart';
import 'package:rice_milling_mobile/domain/models/other/machine_model.dart';
import 'package:rice_milling_mobile/domain/models/other/pre_stage_model.dart';
import 'package:rice_milling_mobile/infrastructure/storages/index.dart';
import 'package:rice_milling_mobile/infrastructure/storages/store_prestage.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/final_processing_stage/models/final_processing_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/screening_stage/models/screening_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/screening_stage/models/store_model.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_datetime_picker.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_select.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_text.dart';
import 'package:flutter/material.dart';

import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:rice_milling_mobile/generated/l10n.dart' as l;

class AddProcessingDialog extends StatefulWidget {
  const AddProcessingDialog({super.key, this.data});
  final MFinalProcessingStage? data;

  @override
  State<AddProcessingDialog> createState() => _AddBusinessSettingState();
}

class _AddBusinessSettingState extends State<AddProcessingDialog> {
  late MFinalProcessingStage termData;

  MPreStage preStage = MPreStage.fromMap({});

  String? machineIndex;
  List<MMachine> machines = [];

  String? batchIndex;
  List<MScreeningStage> batchs = [];

  String? productFormIndex;

  final _ctrlWastageQty = TextEditingController();
  final _ctrlComment = TextEditingController();
  final _ctrlStartTime = TextEditingController();
  final _ctrlEndTime = TextEditingController();

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    await fetchingData();
    if (widget.data == null) {
      termData = MFinalProcessingStage.fromJson({});
    } else {
      termData = MFinalProcessingStage.copy(widget.data!);
      batchIndex = batchs
          .indexWhere(
              (e) => e.batchId.toString() == termData.batchId.toString())
          .toString();
      machineIndex = machines
          .indexWhere((e) => e.id.toString() == termData.machineId.toString())
          .toString();
      _ctrlWastageQty.text = termData.wastageQty.toString();
      productFormIndex = preStage.stageProductForm
          .indexWhere((e) => e.toString() == termData.productForm.toString())
          .toString();
      _ctrlComment.text = termData.comments;
      _ctrlStartTime.text =
          DateTime.fromMillisecondsSinceEpoch(termData.startTime as int)
              .convertDateTimeToString;
      _ctrlEndTime.text =
          DateTime.fromMillisecondsSinceEpoch(termData.endTime as int)
              .convertDateTimeToString;
    }
    setState(() {});
  }

  saveData() async {
    FocusManager.instance.primaryFocus?.unfocus();
    termData.batchId = batchs[int.parse(batchIndex ?? '0')].batchId;
    termData.machineId = machines[int.parse(machineIndex ?? '0')].id;
    termData.inputQty =
        batchs[int.parse(batchIndex ?? '0')].fineMaterialOutputQty;
    termData.wastageQty = double.parse(_ctrlWastageQty.text);
    termData.productForm =
        preStage.stageProductForm[int.parse(productFormIndex ?? '0')];
    termData.comments = _ctrlComment.text;
    termData.startTime = _ctrlStartTime.text.convertToDateTime.convertToInt;
    termData.endTime = _ctrlEndTime.text.convertToDateTime.convertToInt;
    print(termData.toMapUpdate());
    if (widget.data == null) {
      final res = await AppFinalProcessing.insert(termData.toMapCreate());
      if (!res) return;
    } else {
      final res = await AppFinalProcessing.update(
          termData.toMapUpdate(), termData.id.toString());
      if (!res) return;
    }
    Navigator.pop(context, true);
  }

  fetchingData() async {
    await Future.wait([
      fetchMachine(),
      fetchMixing(),
      fetchPreStage(),
    ]);
  }

  Future fetchMachine() async {
    await Storage.instance.machine.initFetch();
    machines = Storage.instance.machine.datas ?? [];
  }

  Future fetchMixing() async {
    await StoreScreening.instance.data.initFetch();
    batchs = StoreScreening.instance.data.datas ?? [];
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
                        },
                      ),
                      const SizedBox(height: 20),
                      InputSelect(
                        label: l.S.current.stage_machine,
                        hintText: l.S.current.action_select,
                        items: machines.map((e) => e.machineName).toList(),
                        index: machineIndex,
                        onChange: (value) {
                          machineIndex = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputSelect(
                        label: l.S.current.stage_product_form,
                        hintText: l.S.current.action_select,
                        items: preStage.stageProductForm.map((e) => e).toList(),
                        index: productFormIndex,
                        onChange: (value) {
                          productFormIndex = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputText(
                          label: l.S.current.stage_wastage_qty,
                          keyboardType: TextInputType.number,
                          controller: _ctrlWastageQty),
                      const SizedBox(height: 20),
                      InputDateTimePicker(
                          label: l.S.current.stage_start_time, controller: _ctrlStartTime),
                      const SizedBox(height: 20),
                      InputDateTimePicker(
                          label: l.S.current.stage_end_time, controller: _ctrlEndTime),
                      const SizedBox(height: 20),
                      InputText(
                          label: l.S.current.stage_comments,
                          maxlines: 3,
                          controller: _ctrlComment),
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