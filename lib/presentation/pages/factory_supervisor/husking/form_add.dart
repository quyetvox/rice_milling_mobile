import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:rice_milling_mobile/application/app_other.dart';
import 'package:rice_milling_mobile/application/stage/app_husking.dart';
import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/domain/helpers/extensions/extensions.dart';
import 'package:rice_milling_mobile/domain/helpers/extensions/extention_datetime.dart';
import 'package:rice_milling_mobile/generated/l10n.dart' as l;
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/husking/models/husking.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/storage/models/storage.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_datetime_picker.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_select.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_text.dart';

class FormAdd extends StatefulWidget {
  const FormAdd({super.key, this.data});
  final MHusking? data;

  @override
  State<FormAdd> createState() => _FormAddState();
}

class _FormAddState extends State<FormAdd> {
  late MHusking termData;

  List<MStorage> lots = [];
  String? lotIndex;

  List<String> huskUsageTypes = [];
  String? huskUsageTypeIndex;

  List<String> sourceTypes = [];
  String? sourceTypeIndex;

  List<String> huskingComplianceStatus = [];
  String? huskingComplianceStatusIndex;

  final _ctrlLocationId = TextEditingController();
  final _ctrlStorageId = TextEditingController();
  final _ctrlStoredPaddyQty = TextEditingController();
  final _ctrlHuskedBrownRiceQty = TextEditingController();
  final _ctrlHuskQty = TextEditingController();
  final _ctrlStartTime = TextEditingController();
  final _ctrlEndTime = TextEditingController();
  final _ctrlComments = TextEditingController();

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
    await StoreStorageQC.instance.data.initFetch();
    lots = StoreStorageQC.instance.data.datas ?? [];
  }

  Future fetchCatalogue() async {
    final catalogues = await AppOther.catalogues();
    if (catalogues.isEmpty) return;
    huskingComplianceStatus =
        catalogues.firstWhere((e) => e.key == 'qc_status').values;
    sourceTypes = catalogues.firstWhere((e) => e.key == 'source_type').values;
    huskUsageTypes =
        catalogues.firstWhere((e) => e.key == 'husk_usage_type').values;
  }

  initData() async {
    await fetchingData();
    if (widget.data == null) {
      termData = MHusking.fromJson({});
    } else {
      termData = MHusking.copy(widget.data!);
      lotIndex = lots
          .indexWhere((e) => e.lotId.toString() == termData.lotId.toString())
          .toString();
      huskingComplianceStatusIndex = huskingComplianceStatus
          .indexWhereOrNull((e) => e == termData.huskComplianceStatus);
      huskUsageTypeIndex =
          huskUsageTypes.indexWhereOrNull((e) => e == termData.huskUsageType);
      sourceTypeIndex =
          sourceTypes.indexWhereOrNull((e) => e == termData.sourceType);
      _ctrlStartTime.text =
          DateTime.fromMillisecondsSinceEpoch(termData.startTime as int)
              .convertDateTimeToString;
      _ctrlEndTime.text =
          DateTime.fromMillisecondsSinceEpoch(termData.endTime as int)
              .convertDateTimeToString;
      _ctrlLocationId.text = termData.locationId.toString();
      _ctrlStorageId.text = termData.storageId;
      _ctrlStoredPaddyQty.text = termData.storedPaddyQty.toString();
      _ctrlHuskedBrownRiceQty.text = termData.huskedBrownRiceQty.toString();
      _ctrlHuskQty.text = termData.huskQty.toString();
      _ctrlComments.text = termData.comments;
    }
    setState(() {});
  }

  saveData() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final lot = lots[int.parse(lotIndex ?? '0')];
    termData.lotId = lot.lotId;
    termData.locationId = lot.locationId;
    termData.sourceType =
        sourceTypes[int.tryParse(sourceTypeIndex ?? '0') ?? 0];
    termData.storageId = _ctrlStorageId.text;
    termData.storedPaddyQty = num.tryParse(_ctrlStoredPaddyQty.text) ?? 0;
    termData.huskedBrownRiceQty =
        num.tryParse(_ctrlHuskedBrownRiceQty.text) ?? 0;
    termData.huskQty = num.tryParse(_ctrlHuskQty.text) ?? 0;
    termData.huskUsageType =
        huskUsageTypes[int.tryParse(huskUsageTypeIndex ?? '0') ?? 0];
    termData.huskComplianceStatus = huskingComplianceStatus[
        int.tryParse(huskingComplianceStatusIndex ?? '0') ?? 0];
    termData.comments = _ctrlComments.text;
    termData.startTime = _ctrlStartTime.text.convertToDateTime.convertToInt;
    termData.endTime = _ctrlEndTime.text.convertToDateTime.convertToInt;
    print(termData.toMapUpdate());
    if (widget.data == null) {
      final res = await AppHusking.insert(termData.toMapCreate());
      if (!res) return;
    } else {
      final res = await AppHusking.update(
          termData.toMapUpdate(), termData.id.toString());
      if (!res) return;
    }
    Navigator.pop(context, true);
  }

  processSelectLot() {
    final lot = lots[int.parse(lotIndex ?? '0')];
    _ctrlLocationId.text = lot.locationId.toString();
    _ctrlStorageId.text = lot.id.toString();
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
                        label: 'Source Type',
                        hintText: 'Source Type',
                        items: sourceTypes,
                        index: sourceTypeIndex,
                        onChange: (value) {
                          sourceTypeIndex = value;
                        },
                      ),
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
                        label: 'Location Id',
                        isReadOnly: true,
                        keyboardType: TextInputType.number,
                        controller: _ctrlLocationId,
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Storage ID',
                        isReadOnly: true,
                        keyboardType: TextInputType.text,
                        controller: _ctrlStorageId,
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Stored Paddy Qty (kg)',
                        keyboardType: TextInputType.number,
                        controller: _ctrlStoredPaddyQty,
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Husked Brown Rice Qty (kg)',
                        keyboardType: TextInputType.number,
                        controller: _ctrlHuskedBrownRiceQty,
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Husk Qty (kg)',
                        keyboardType: TextInputType.number,
                        controller: _ctrlHuskQty,
                      ),
                      const SizedBox(height: 20),
                      InputSelect(
                        label: 'Husk Usage Type',
                        hintText: 'Husk Usage Type',
                        items: huskUsageTypes,
                        index: huskUsageTypeIndex,
                        onChange: (value) {
                          huskUsageTypeIndex = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputSelect(
                        label: 'Husking Compliance Status',
                        hintText: 'Husking Compliance Status',
                        items: huskingComplianceStatus,
                        index: huskingComplianceStatusIndex,
                        onChange: (value) {
                          huskingComplianceStatusIndex = value;
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
