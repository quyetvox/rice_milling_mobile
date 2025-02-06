import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:rice_milling_mobile/application/stage/app_brown_rice_milling.dart';
import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/domain/helpers/extensions/extention_datetime.dart';
import 'package:rice_milling_mobile/generated/l10n.dart' as l;
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/brown_rice_milling/models/brown_rice_milling.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/husking/models/husking.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_datetime_picker.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_select.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_text.dart';

class FormAdd extends StatefulWidget {
  const FormAdd({super.key, this.data});
  final MBrownRiceMilling? data;

  @override
  State<FormAdd> createState() => _FormAddState();
}

class _FormAddState extends State<FormAdd> {
  late MBrownRiceMilling termData;

  List<MHusking> lots = [];
  String? lotIndex;

  final _ctrlInputHuskedBrownRiceQty = TextEditingController();
  final _ctrlUnhuskedPaddyRemoved = TextEditingController();
  final _ctrlFinalBrownRiceOutput = TextEditingController();
  final _ctrlStartTime = TextEditingController();
  final _ctrlEndTime = TextEditingController();
  final _ctrlComment = TextEditingController();
  final _ctrlLocationId = TextEditingController();

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future fetchLot() async {
    await StoreHuskingQC.instance.data.initFetch();
    lots = StoreHuskingQC.instance.data.datas ?? [];
  }

  initData() async {
    await fetchLot();
    if (widget.data == null) {
      termData = MBrownRiceMilling.fromJson({});
    } else {
      termData = MBrownRiceMilling.copy(widget.data!);
      lotIndex = lots
          .indexWhere((e) => e.lotId.toString() == termData.lotId.toString())
          .toString();
      _ctrlStartTime.text =
          DateTime.fromMillisecondsSinceEpoch(termData.startTime as int)
              .convertDateTimeToString;
      _ctrlEndTime.text =
          DateTime.fromMillisecondsSinceEpoch(termData.endTime as int)
              .convertDateTimeToString;
      _ctrlLocationId.text = termData.locationId.toString();
      _ctrlInputHuskedBrownRiceQty.text =
          termData.inputHuskedBrownRiceQty.toString();
      _ctrlUnhuskedPaddyRemoved.text = termData.unhuskedPaddyRemoved.toString();
      _ctrlFinalBrownRiceOutput.text = termData.finalBrownRiceQty.toString();
      _ctrlComment.text = termData.comments;
    }
    setState(() {});
  }

  saveData() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final lot = lots[int.parse(lotIndex ?? '0')];
    termData.lotId = lot.lotId;
    termData.locationId = lot.locationId;
    termData.inputHuskedBrownRiceQty =
        num.tryParse(_ctrlInputHuskedBrownRiceQty.text) ?? 0;
    termData.unhuskedPaddyRemoved =
        num.tryParse(_ctrlUnhuskedPaddyRemoved.text) ?? 0;
    termData.comments = _ctrlComment.text;
    termData.startTime = _ctrlStartTime.text.convertToDateTime.convertToInt;
    termData.endTime = _ctrlEndTime.text.convertToDateTime.convertToInt;
    print(termData.toMapUpdate());
    if (widget.data == null) {
      final res = await AppBrownRiceMilling.insert(termData.toMapCreate());
      if (!res) return;
    } else {
      final res = await AppBrownRiceMilling.update(
          termData.toMapUpdate(), termData.id.toString());
      if (!res) return;
    }
    Navigator.pop(context, true);
  }

  processSelectLot() {
    final lot = lots[int.parse(lotIndex ?? '0')];
    _ctrlLocationId.text = lot.locationId.toString();
    _ctrlInputHuskedBrownRiceQty.text = lot.huskedBrownRiceQty.toString();
    processFinalBrownRice();
  }

  processFinalBrownRice() {
    if (_ctrlInputHuskedBrownRiceQty.text.isNotEmpty &&
        _ctrlUnhuskedPaddyRemoved.text.isNotEmpty) {
      _ctrlFinalBrownRiceOutput.text =
          (num.parse(_ctrlInputHuskedBrownRiceQty.text) -
                  num.parse(_ctrlUnhuskedPaddyRemoved.text))
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
                        label: 'Input Husked Brown Rice Qty (kg)',
                        isReadOnly: true,
                        keyboardType: TextInputType.number,
                        controller: _ctrlInputHuskedBrownRiceQty,
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Unhusked Paddy Removed (kg)',
                        keyboardType: TextInputType.number,
                        controller: _ctrlUnhuskedPaddyRemoved,
                        onChanged: (value) {
                          processFinalBrownRice();
                        },
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Final Brown Rice Output (kg)',
                        isReadOnly: true,
                        keyboardType: TextInputType.number,
                        controller: _ctrlFinalBrownRiceOutput,
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
