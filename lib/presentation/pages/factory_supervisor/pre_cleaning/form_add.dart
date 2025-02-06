import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:rice_milling_mobile/application/stage/app_pre_cleaning.dart';
import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/domain/helpers/extensions/extention_datetime.dart';
import 'package:rice_milling_mobile/generated/l10n.dart' as l;
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/pre_cleaning/models/pre_cleaning.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/pre_processing_qc/models/pre_processing.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_datetime_picker.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_select.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_text.dart';

class FormAdd extends StatefulWidget {
  const FormAdd({super.key, this.data});
  final MPreCleaning? data;

  @override
  State<FormAdd> createState() => _FormAddState();
}

class _FormAddState extends State<FormAdd> {
  late MPreCleaning termData;

  List<MPreProcessingQC> lots = [];
  String? lotIndex;

  final _ctrlLocationId = TextEditingController();
  final _ctrlPaddyInputQty = TextEditingController();
  final _ctrlImpuritiesRemoved = TextEditingController();
  final _ctrlUnfilledGrains = TextEditingController();
  final _ctrlFinalPreCleanedPaddyQty = TextEditingController();
  final _ctrlStartTime = TextEditingController();
  final _ctrlEndTime = TextEditingController();
  final _ctrlComment = TextEditingController();

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future fetchLot() async {
    await StorePreProcessingQC.instance.data.initFetch();
    lots = StorePreProcessingQC.instance.data.datas ?? [];
  }

  initData() async {
    await fetchLot();
    if (widget.data == null) {
      termData = MPreCleaning.fromJson({});
    } else {
      termData = MPreCleaning.copy(widget.data!);
      _ctrlStartTime.text =
          DateTime.fromMillisecondsSinceEpoch(termData.startTime as int)
              .convertDateTimeToString;
      _ctrlEndTime.text =
          DateTime.fromMillisecondsSinceEpoch(termData.endTime as int)
              .convertDateTimeToString;
      lotIndex = lots
          .indexWhere((e) => e.lotId.toString() == termData.lotId.toString())
          .toString();
      _ctrlLocationId.text = termData.locationId.toString();
      _ctrlPaddyInputQty.text = termData.paddyInputQty.toString();
      _ctrlImpuritiesRemoved.text = termData.impuritiesRemoved.toString();
      _ctrlUnfilledGrains.text = termData.unfilledGrainsCollected.toString();
      _ctrlFinalPreCleanedPaddyQty.text =
          termData.finalPreCleanedPaddyQty.toString();
      _ctrlComment.text = termData.comments;
    }
    setState(() {});
  }

  saveData() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final lot = lots[int.parse(lotIndex ?? '0')];
    termData.lotId = lot.lotId;
    termData.locationId = lot.locationId;
    termData.paddyInputQty = num.tryParse(_ctrlPaddyInputQty.text) ?? 0;
    termData.impuritiesRemoved = num.tryParse(_ctrlImpuritiesRemoved.text) ?? 0;
    termData.unfilledGrainsCollected =
        num.tryParse(_ctrlUnfilledGrains.text) ?? 0;
    // termData.finalPreCleanedPaddyQty =
    //     num.tryParse(_ctrlFinalPreCleanedPaddyQty.text) ?? 0;
    termData.comments = _ctrlComment.text;
    termData.startTime = _ctrlStartTime.text.convertToDateTime.convertToInt;
    termData.endTime = _ctrlEndTime.text.convertToDateTime.convertToInt;
    print(termData.toMapUpdate());
    if (widget.data == null) {
      final res = await AppPreCleaning.insert(termData.toMapCreate());
      if (!res) return;
    } else {
      final res = await AppPreCleaning.update(
          termData.toMapUpdate(), termData.id.toString());
      if (!res) return;
    }
    Navigator.pop(context, true);
  }

  processSelectLot() {
    final lot = lots[int.parse(lotIndex ?? '0')];
    _ctrlLocationId.text = lot.locationId.toString();
    _ctrlPaddyInputQty.text = lot.finalQcApprovedQty.toString();
    processPreCleaned();
  }

  processPreCleaned() {
    if (_ctrlPaddyInputQty.text.isNotEmpty &&
        _ctrlImpuritiesRemoved.text.isNotEmpty &&
        _ctrlUnfilledGrains.text.isNotEmpty) {
      _ctrlFinalPreCleanedPaddyQty.text = (num.parse(_ctrlPaddyInputQty.text) -
              num.parse(_ctrlImpuritiesRemoved.text) -
              num.parse(_ctrlUnfilledGrains.text))
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
                        label: 'Paddy Input Quantity (Kg)',
                        isReadOnly: true,
                        keyboardType: TextInputType.number,
                        controller: _ctrlPaddyInputQty,
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Impurities Removed (Kg)',
                        keyboardType: TextInputType.number,
                        controller: _ctrlImpuritiesRemoved,
                        onChanged: (value) {
                          processPreCleaned();
                        },
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Unfilled Grains Collected (Kg)',
                        keyboardType: TextInputType.number,
                        controller: _ctrlUnfilledGrains,
                        onChanged: (value) {
                          processPreCleaned();
                        },
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Final Pre-Cleaned Paddy Qty (Kg)',
                        isReadOnly: true,
                        keyboardType: TextInputType.number,
                        controller: _ctrlFinalPreCleanedPaddyQty,
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
