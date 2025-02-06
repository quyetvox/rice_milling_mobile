import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:rice_milling_mobile/application/app_other.dart';
import 'package:rice_milling_mobile/application/stage/app_final_qc.dart';
import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/domain/helpers/extensions/extention_datetime.dart';
import 'package:rice_milling_mobile/domain/helpers/helpers.dart';
import 'package:rice_milling_mobile/generated/l10n.dart' as l;
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/final_qc/models/final_qc.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/sortex/models/sortex.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_datetime_picker.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_select.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_text.dart';

class FormAdd extends StatefulWidget {
  const FormAdd({super.key, this.data});
  final MFinalQC? data;

  @override
  State<FormAdd> createState() => _FormAddState();
}

class _FormAddState extends State<FormAdd> {
  late MFinalQC termData;

  List<MSortexQC> lots = [];
  String? lotIndex;

  List<String> grainAppearances = [];
  String? grainAppearanceindex;

  List<String> grainTextures = [];
  String? grainTextureIndex;

  List<String> tasteProfiles = [];
  String? tasteProfileIndex;

  List<String> qcStatus = [];
  String? qcStatusIndex;

  final _ctrlFinishedRiceWeight = TextEditingController();
  final _ctrlContaminantLevel = TextEditingController();
  final _ctrlBrokenGrainProportion = TextEditingController();
  final _ctrlFinalOutput = TextEditingController();
  final _ctrlInspectionTime = TextEditingController();
  final _ctrlStartTime = TextEditingController();
  final _ctrlEndTime = TextEditingController();
  final _ctrlComment = TextEditingController();
  final _ctrlLocationId = TextEditingController();

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
    await StoreSortexQC.instance.data.initFetch();
    lots = StoreSortexQC.instance.data.datas ?? [];
  }

  Future fetchCatalogue() async {
    final catalogues = await AppOther.catalogues();
    if (catalogues.isEmpty) return;
    qcStatus = catalogues.firstWhere((e) => e.key == 'qc_status').values;
    grainAppearances =
        catalogues.firstWhere((e) => e.key == 'grain_appearance').values;
    grainTextures =
        catalogues.firstWhere((e) => e.key == 'grain_texture').values;
    tasteProfiles =
        catalogues.firstWhere((e) => e.key == 'taste_profile').values;
  }

  initData() async {
    await fetchingData();
    if (widget.data == null) {
      termData = MFinalQC.fromJson({});
    } else {
      termData = MFinalQC.copy(widget.data!);
      lotIndex = lots
          .indexWhere((e) => e.lotId.toString() == termData.lotId.toString())
          .toString();
      _ctrlStartTime.text =
          DateTime.fromMillisecondsSinceEpoch(termData.startTime as int)
              .convertDateTimeToString;
      _ctrlEndTime.text =
          DateTime.fromMillisecondsSinceEpoch(termData.endTime as int)
              .convertDateTimeToString;
      _ctrlInspectionTime.text =
          DateTime.fromMillisecondsSinceEpoch(termData.inspectionTime as int)
              .convertDateTimeToString;
      _ctrlLocationId.text = termData.locationId.toString();
      _ctrlFinishedRiceWeight.text = termData.finishedRiceQty.toString();

      grainAppearanceindex = grainAppearances
          .indexWhereOrNull((e) => e == termData.grainAppearance);
      grainTextureIndex =
          grainTextures.indexWhereOrNull((e) => e == termData.grainTexture);
      tasteProfileIndex =
          tasteProfiles.indexWhereOrNull((e) => e == termData.tasteProfile);
      qcStatusIndex = qcStatus.indexWhereOrNull((e) => e == termData.qcStatus);

      _ctrlContaminantLevel.text = termData.contaminantLevel.toString();
      _ctrlBrokenGrainProportion.text =
          termData.brokenGrainProportion.toString();
      _ctrlFinalOutput.text = termData.finalOutputQty.toString();
      _ctrlComment.text = termData.comments;
    }
    setState(() {});
  }

  saveData() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final lot = lots[int.parse(lotIndex ?? '0')];
    termData.lotId = lot.lotId;
    termData.locationId = lot.locationId;
    termData.finishedRiceQty =
        num.tryParse(_ctrlFinishedRiceWeight.text) ?? 0;
    termData.grainAppearance =
        grainAppearances[int.tryParse(grainAppearanceindex ?? '0') ?? 0];
    termData.grainTexture =
        grainTextures[int.tryParse(grainTextureIndex ?? '0') ?? 0];
    termData.tasteProfile =
        tasteProfiles[int.tryParse(tasteProfileIndex ?? '0') ?? 0];
    termData.qcStatus = qcStatus[int.tryParse(qcStatusIndex ?? '0') ?? 0];
    termData.contaminantLevel = num.tryParse(_ctrlContaminantLevel.text) ?? 0;
    termData.brokenGrainProportion =
        num.tryParse(_ctrlBrokenGrainProportion.text) ?? 0;
    termData.finalOutputQty = num.tryParse(_ctrlFinalOutput.text) ?? 0;
    termData.comments = _ctrlComment.text;
    termData.inspectionTime =
        _ctrlInspectionTime.text.convertToDateTime.convertToInt;
    termData.startTime = _ctrlStartTime.text.convertToDateTime.convertToInt;
    termData.endTime = _ctrlEndTime.text.convertToDateTime.convertToInt;

    print(termData.toMapUpdate());

    if (widget.data == null) {
      final res = await AppFinalQC.insert(termData.toMapCreate());
      if (!res) return;
    } else {
      final res = await AppFinalQC.update(
          termData.toMapUpdate(), termData.id.toString());
      if (!res) return;
    }
    Navigator.pop(context, true);
  }

  processSelectLot() {
    final lot = lots[int.parse(lotIndex ?? '0')];
    _ctrlLocationId.text = lot.locationId.toString();
    _ctrlFinishedRiceWeight.text = lot.finalSortexOutputQty.toString();
    processFinalOutput();
  }

  processFinalOutput() {
    if (_ctrlFinishedRiceWeight.text.isNotEmpty &&
        _ctrlContaminantLevel.text.isNotEmpty &&
        _ctrlBrokenGrainProportion.text.isNotEmpty) {
      _ctrlFinalOutput.text = (num.parse(_ctrlFinishedRiceWeight.text) -
              (num.parse(_ctrlBrokenGrainProportion.text) *
                      num.parse(_ctrlFinishedRiceWeight.text) /
                      100 +
                  (num.parse(_ctrlContaminantLevel.text) / 1000)))
          .toStringAsFixed(2);
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
                        label: 'Finished Rice Weight (kg)',
                        isReadOnly: true,
                        keyboardType: TextInputType.number,
                        controller: _ctrlFinishedRiceWeight,
                      ),
                      const SizedBox(height: 20),
                      InputSelect(
                        label: 'Grain Appearance (Color)',
                        hintText: 'Grain Appearance (Color)',
                        items: grainAppearances,
                        index: grainAppearanceindex,
                        onChange: (value) {
                          grainAppearanceindex = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputSelect(
                        label: 'Grain Texture',
                        hintText: 'Grain Texture',
                        items: grainTextures,
                        index: grainTextureIndex,
                        onChange: (value) {
                          grainTextureIndex = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputSelect(
                        label: 'Taste Profile',
                        hintText: 'Taste Profile',
                        items: tasteProfiles,
                        index: tasteProfileIndex,
                        onChange: (value) {
                          tasteProfileIndex = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Contaminant Level (ppm)',
                        keyboardType: TextInputType.number,
                        controller: _ctrlContaminantLevel,
                        onChanged: (value) {
                          processFinalOutput();
                        },
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Broken Grain Proportion (%)',
                        keyboardType: TextInputType.number,
                        controller: _ctrlBrokenGrainProportion,
                        onChanged: (value) {
                          processFinalOutput();
                        },
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Final Output (kg)',
                        isReadOnly: true,
                        keyboardType: TextInputType.number,
                        controller: _ctrlFinalOutput,
                      ),
                      const SizedBox(height: 20),
                      InputSelect(
                        label: 'QC Pass/Fail Status',
                        hintText: 'QC Pass/Fail Status',
                        items: qcStatus,
                        index: qcStatusIndex,
                        onChange: (value) {
                          qcStatusIndex = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputDateTimePicker(
                        label: 'Inspection Time',
                        controller: _ctrlInspectionTime,
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
