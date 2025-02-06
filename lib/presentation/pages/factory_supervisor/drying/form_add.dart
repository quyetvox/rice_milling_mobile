import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:rice_milling_mobile/application/app_other.dart';
import 'package:rice_milling_mobile/application/stage/app_drying.dart';
import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/domain/helpers/extensions/extention_datetime.dart';
import 'package:rice_milling_mobile/domain/helpers/helpers.dart';
import 'package:rice_milling_mobile/domain/models/other/catalogue_model.dart';
import 'package:rice_milling_mobile/generated/l10n.dart' as l;
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/drying/models/drying.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/pre_cleaning/models/pre_cleaning.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_datetime_picker.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_select.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_text.dart';

class FormAdd extends StatefulWidget {
  const FormAdd({super.key, this.data});
  final MDrying? data;

  @override
  State<FormAdd> createState() => _FormAddState();
}

class _FormAddState extends State<FormAdd> {
  late MDrying termData;

  List<MCatalogue> catalogues = [];

  List<MPreCleaning> lots = [];
  String? lotIndex;

  List<String> dryingTechniques = [];
  String? dryingTechniqueIndex;
  List<String> dryingComplianceStatus = [];
  String? dryingComplianceStatusIndex;

  final _ctrlLocationId = TextEditingController();
  final _ctrlPreCleanedPaddyQty = TextEditingController();
  final _ctrlInitialMoistureLevel = TextEditingController();
  final _ctrlFinalMoistureLevel = TextEditingController();
  final _ctrlDryingLossQty = TextEditingController();
  final _ctrlFinalDriedPaddyQty = TextEditingController();
  final _ctrlStartTime = TextEditingController();
  final _ctrlEndTime = TextEditingController();
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
    await StorePreCleaning.instance.data.initFetch();
    lots = StorePreCleaning.instance.data.datas ?? [];
  }

  Future fetchCatalogue() async {
    catalogues = await AppOther.catalogues();
    if (catalogues.isEmpty) return;
    dryingComplianceStatus =
        catalogues.firstWhere((e) => e.key == 'qc_status').values;
    dryingTechniques =
        catalogues.firstWhere((e) => e.key == 'drying_technique').values;
  }

  initData() async {
    await fetchingData();
    if (widget.data == null) {
      termData = MDrying.fromJson({});
    } else {
      termData = MDrying.copy(widget.data!);
      lotIndex = lots.indexWhereOrNull(
          (e) => e.lotId.toString() == termData.lotId.toString());
      dryingComplianceStatusIndex = dryingComplianceStatus
          .indexWhereOrNull((e) => e == termData.dryingComplianceStatus);
      dryingTechniqueIndex = dryingTechniques
          .indexWhereOrNull((e) => e == termData.dryingTechnique);
      _ctrlStartTime.text =
          DateTime.fromMillisecondsSinceEpoch(termData.startTime as int)
              .convertDateTimeToString;
      _ctrlEndTime.text =
          DateTime.fromMillisecondsSinceEpoch(termData.endTime as int)
              .convertDateTimeToString;
      _ctrlLocationId.text = termData.locationId.toString();
      _ctrlPreCleanedPaddyQty.text = termData.preCleanedPaddyQty.toString();
      _ctrlInitialMoistureLevel.text = termData.initialMoistureLevel.toString();
      _ctrlFinalMoistureLevel.text = termData.finalMoistureLevel.toString();
      _ctrlDryingLossQty.text = termData.dryingLossQty.toString();
      _ctrlFinalDriedPaddyQty.text = termData.finalDiredPaddyQty.toString();
      _ctrlComment.text = termData.comments;
    }
    setState(() {});
  }

  saveData() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final lot = lots[int.parse(lotIndex ?? '0')];
    termData.lotId = lot.lotId;
    termData.locationId = lot.locationId;
    termData.preCleanedPaddyQty =
        num.tryParse(_ctrlPreCleanedPaddyQty.text) ?? 0;
    termData.dryingTechnique =
        dryingTechniques[int.tryParse(dryingTechniqueIndex ?? '0') ?? 0];
    termData.initialMoistureLevel =
        num.tryParse(_ctrlInitialMoistureLevel.text) ?? 0;
    termData.finalMoistureLevel =
        num.tryParse(_ctrlFinalMoistureLevel.text) ?? 0;
    termData.dryingLossQty = num.tryParse(_ctrlDryingLossQty.text) ?? 0;
    termData.finalDiredPaddyQty =
        num.tryParse(_ctrlFinalDriedPaddyQty.text) ?? 0;
    termData.dryingComplianceStatus = dryingComplianceStatus[
        int.tryParse(dryingComplianceStatusIndex ?? '0') ?? 0];
    termData.comments = _ctrlComment.text;
    termData.startTime = _ctrlStartTime.text.convertToDateTime.convertToInt;
    termData.endTime = _ctrlEndTime.text.convertToDateTime.convertToInt;
    print(termData.toMapUpdate());
    if (widget.data == null) {
      final res = await AppDrying.insert(termData.toMapCreate());
      if (!res) return;
    } else {
      final res = await AppDrying.update(
          termData.toMapUpdate(), termData.id.toString());
      if (!res) return;
    }
    Navigator.pop(context, true);
  }

  processSelectLot() {
    final lot = lots[int.parse(lotIndex ?? '0')];
    _ctrlLocationId.text = lot.locationId.toString();
    _ctrlPreCleanedPaddyQty.text = lot.finalPreCleanedPaddyQty.toString();
    processFinalDried();
  }

  processFinalDried() {
    if (_ctrlPreCleanedPaddyQty.text.isNotEmpty &&
        _ctrlDryingLossQty.text.isNotEmpty) {
      _ctrlFinalDriedPaddyQty.text = (num.parse(_ctrlPreCleanedPaddyQty.text) -
              num.parse(_ctrlDryingLossQty.text))
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
                      InputText(
                        label: 'Pre-Cleaned Paddy Qty (kg)',
                        isReadOnly: true,
                        keyboardType: TextInputType.number,
                        controller: _ctrlPreCleanedPaddyQty,
                      ),
                      const SizedBox(height: 20),
                      InputSelect(
                        label: 'Drying Technique',
                        hintText: 'Drying Technique',
                        items: dryingTechniques,
                        index: dryingTechniqueIndex,
                        onChange: (value) {
                          dryingTechniqueIndex = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Initial Moisture Level (%)',
                        keyboardType: TextInputType.number,
                        controller: _ctrlInitialMoistureLevel,
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Final Moisture Level (%)',
                        keyboardType: TextInputType.number,
                        controller: _ctrlFinalMoistureLevel,
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Drying Loss Qty (kg)',
                        keyboardType: TextInputType.number,
                        controller: _ctrlDryingLossQty,
                        onChanged: (value) {
                          processFinalDried();
                        },
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Final Dried Paddy Qty (kg)',
                        isReadOnly: true,
                        keyboardType: TextInputType.number,
                        controller: _ctrlFinalDriedPaddyQty,
                      ),
                      const SizedBox(height: 20),
                      InputSelect(
                        label: 'Drying Compliance Status',
                        hintText: 'Drying Compliance Status',
                        items: dryingComplianceStatus,
                        index: dryingComplianceStatusIndex,
                        onChange: (value) {
                          dryingComplianceStatusIndex = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputDateTimePicker(
                        label: 'Start Time',
                        controller: _ctrlStartTime,
                      ),
                      const SizedBox(height: 20),
                      InputDateTimePicker(
                        label: 'End Time',
                        controller: _ctrlEndTime,
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Notes or Comments',
                        maxlines: 3,
                        controller: _ctrlComment,
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
