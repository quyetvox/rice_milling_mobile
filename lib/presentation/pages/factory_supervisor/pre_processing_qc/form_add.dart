import 'package:rice_milling_mobile/application/app_other.dart';
import 'package:rice_milling_mobile/application/stage/app_pre_processing.dart';
import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/domain/helpers/extensions/extention_datetime.dart';
import 'package:rice_milling_mobile/domain/helpers/helpers.dart';
import 'package:rice_milling_mobile/domain/models/other/catalogue_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/sourcing_material/models/sourcing_material.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/pre_processing_qc/models/pre_processing.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_datetime_picker.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_select.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_text.dart';
import 'package:flutter/material.dart';

import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:rice_milling_mobile/generated/l10n.dart' as l;

class FormAdd extends StatefulWidget {
  const FormAdd({super.key, this.data});
  final MPreProcessingQC? data;

  @override
  State<FormAdd> createState() => _FormAddState();
}

class _FormAddState extends State<FormAdd> {
  late MPreProcessingQC termData;

  List<MCatalogue> catalogues = [];

  List<MSourcingMaterial> lots = [];
  String? lotIndex;

  List<String> qcStatus = [];
  String? qcStatusIndex;

  final _ctrlInspectionTime = TextEditingController();
  final _ctrlLotId = TextEditingController();
  final _ctrlLocationId = TextEditingController();
  final _ctrlLotQty = TextEditingController();
  final _ctrlRawPaddyWeight = TextEditingController();
  final _ctrlMoistureContent = TextEditingController();
  final _ctrlImpurityLevel = TextEditingController();
  final _ctrlGrainDamage = TextEditingController();
  final _ctrlUniformityScore = TextEditingController();
  final _ctrlQCStatus = TextEditingController();
  final _ctrlFinalQCQty = TextEditingController();
  final _ctrlComment = TextEditingController();

  @override
  void initState() {
    super.initState();
    initData();
  }

  fetchingData() async {
    await Future.wait([
      fetchCatalogue(),
      fetchLot(),
    ]);
  }

  Future fetchLot() async {
    await StoreSourcingMaterial.instance.data.initFetch();
    lots = StoreSourcingMaterial.instance.data.datas ?? [];
  }

  Future fetchCatalogue() async {
    catalogues = await AppOther.catalogues();
    if (catalogues.isEmpty) return;
    qcStatus = catalogues.firstWhere((e) => e.key == 'qc_status').values;
  }

  initData() async {
    await fetchingData();
    if (widget.data == null) {
      termData = MPreProcessingQC.fromJson({});
    } else {
      termData = MPreProcessingQC.copy(widget.data!);
      _ctrlInspectionTime.text =
          DateTime.fromMillisecondsSinceEpoch(termData.inspectionTime as int)
              .convertDateTimeToString;
      lotIndex = lots
          .indexWhereOrNull(
              (e) => e.lotId.toString() == termData.lotId.toString())
          .toString();
      _ctrlLocationId.text = termData.locationId.toString();
      _ctrlLotQty.text = termData.lotQty.toString();
      _ctrlRawPaddyWeight.text = termData.rawPaddyWeight.toString();
      _ctrlMoistureContent.text = termData.moistureContent.toString();
      _ctrlImpurityLevel.text = termData.impurityLevel.toString();
      _ctrlGrainDamage.text = termData.grainDamage.toString();
      _ctrlUniformityScore.text = termData.uniformityScore.toString();
      _ctrlFinalQCQty.text = termData.finalQcApprovedQty.toString();
      qcStatusIndex =
          qcStatus.indexWhere((e) => e == termData.qcStatus).toString();
      _ctrlComment.text = termData.comments;
    }
    setState(() {});
  }

  saveData() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final lot = lots[int.parse(lotIndex ?? '0')];
    termData.lotId = lot.lotId;
    termData.locationId = lot.destinationLocation;
    termData.lotQty = lot.qtySourced;
    termData.rawPaddyWeight = num.tryParse(_ctrlRawPaddyWeight.text) ?? 0;
    termData.moistureContent = num.tryParse(_ctrlMoistureContent.text) ?? 0;
    termData.impurityLevel = num.tryParse(_ctrlImpurityLevel.text) ?? 0;
    termData.grainDamage = num.tryParse(_ctrlGrainDamage.text) ?? 0;
    termData.uniformityScore = num.tryParse(_ctrlUniformityScore.text) ?? 0;
    termData.finalQcApprovedQty = num.tryParse(_ctrlFinalQCQty.text) ?? 0;
    termData.comments = _ctrlComment.text;
    termData.qcStatus = qcStatus[int.tryParse(qcStatusIndex ?? '0') ?? 0];
    termData.inspectionTime =
        _ctrlInspectionTime.text.convertToDateTime.convertToInt;
    print(termData.toMapUpdate());
    if (widget.data == null) {
      final res = await AppPreProcessing.insert(termData.toMapCreate());
      if (!res) return;
    } else {
      final res = await AppPreProcessing.update(
          termData.toMapUpdate(), termData.id.toString());
      if (!res) return;
    }
    Navigator.pop(context, true);
  }

  processSelectLot() {
    final lot = lots[int.parse(lotIndex ?? '0')];
    _ctrlLocationId.text = lot.destinationLocation.toString();
    _ctrlLotQty.text = lot.qtySourced.toString();
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

              ///---------------- header section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 606,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputDateTimePicker(
                          label: l.S.current.stage_end_time,
                          controller: _ctrlInspectionTime),
                      const SizedBox(height: 20),
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
                          label: 'Location',
                          isReadOnly: true,
                          keyboardType: TextInputType.number,
                          controller: _ctrlLocationId),
                      const SizedBox(height: 20),
                      InputText(
                          label: 'Lot Qty',
                          isReadOnly: true,
                          keyboardType: TextInputType.number,
                          controller: _ctrlLotQty),
                      const SizedBox(height: 20),
                      InputText(
                          label: 'Raw Paddy Weight',
                          keyboardType: TextInputType.number,
                          controller: _ctrlRawPaddyWeight),
                      const SizedBox(height: 20),
                      InputText(
                          label: 'Moisture Content',
                          keyboardType: TextInputType.number,
                          controller: _ctrlMoistureContent),
                      const SizedBox(height: 20),
                      InputText(
                          label: 'Impurity Level',
                          keyboardType: TextInputType.number,
                          controller: _ctrlImpurityLevel),
                      const SizedBox(height: 20),
                      InputText(
                          label: 'Grain Damage',
                          keyboardType: TextInputType.number,
                          controller: _ctrlGrainDamage),
                      const SizedBox(height: 20),
                      InputText(
                          label: 'Uniformity Score',
                          keyboardType: TextInputType.number,
                          controller: _ctrlUniformityScore),
                      const SizedBox(height: 20),
                      InputSelect(
                        label: 'QC Status',
                        hintText: 'QC Status',
                        items: qcStatus.map((e) => e.toString()).toList(),
                        index: qcStatusIndex,
                        onChange: (value) {
                          qcStatusIndex = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputText(
                          label: 'Final QC Approved Qty(kg)',
                          keyboardType: TextInputType.number,
                          controller: _ctrlFinalQCQty),
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
