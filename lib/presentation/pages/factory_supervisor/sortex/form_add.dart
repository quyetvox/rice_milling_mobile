import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:rice_milling_mobile/application/app_other.dart';
import 'package:rice_milling_mobile/application/stage/app_sortex.dart';
import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/domain/helpers/extensions/extention_datetime.dart';
import 'package:rice_milling_mobile/generated/l10n.dart' as l;
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/whitening_semi_polishing/models/whitening_semi_polishing.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_datetime_picker.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_select.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_text.dart';

import 'models/sortex.dart';

class FormAdd extends StatefulWidget {
  const FormAdd({super.key, this.data});
  final MSortexQC? data;

  @override
  State<FormAdd> createState() => _FormAddState();
}

class _FormAddState extends State<FormAdd> {
  late MSortexQC termData;

  List<MWhiteningSemiPolishingQC> lots = [];
  String? lotIndex;

  List<String> sortexStatus = [];
  String? sortexStatusIndex;

  final _ctrlInputWhiteRiceQty = TextEditingController();
  final _ctrlRedYellowKernels = TextEditingController();
  final _ctrlDamagedKernel = TextEditingController();
  final _ctrlPaddyKernel = TextEditingController();
  final _ctrlChalkyKernel = TextEditingController();
  final _ctrlFinalSortexOutput = TextEditingController();
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
    await StoreWhiteningSemiPolishingQC.instance.data.initFetch();
    lots = StoreWhiteningSemiPolishingQC.instance.data.datas ?? [];
  }

  Future fetchCatalogue() async {
    final catalogues = await AppOther.catalogues();
    if (catalogues.isEmpty) return;
    sortexStatus = catalogues.firstWhere((e) => e.key == 'qc_status').values;
  }

  initData() async {
    await fetchingData();
    if (widget.data == null) {
      termData = MSortexQC.fromJson({});
    } else {
      termData = MSortexQC.copy(widget.data!);
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
      _ctrlInputWhiteRiceQty.text = termData.inputWhiteRiceQty.toString();
      _ctrlRedYellowKernels.text = termData.redYellowKernels.toString();
      _ctrlDamagedKernel.text = termData.damagedKernel.toString();
      _ctrlPaddyKernel.text = termData.paddyKernel.toString();
      _ctrlChalkyKernel.text = termData.chalkyKernel.toString();
      _ctrlFinalSortexOutput.text = termData.finalSortexOutputQty.toString();
      sortexStatusIndex = sortexStatus
          .indexWhere((e) => e == termData.sortexComplianceStatus)
          .toString();
      _ctrlComment.text = termData.comments;
    }
    setState(() {});
  }

  saveData() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final lot = lots[int.parse(lotIndex ?? '0')];
    termData.lotId = lot.lotId;
    termData.locationId = lot.locationId;
    termData.inputWhiteRiceQty = num.tryParse(_ctrlInputWhiteRiceQty.text) ?? 0;
    termData.redYellowKernels = num.tryParse(_ctrlRedYellowKernels.text) ?? 0;
    termData.damagedKernel = num.tryParse(_ctrlDamagedKernel.text) ?? 0;
    termData.paddyKernel = num.tryParse(_ctrlPaddyKernel.text) ?? 0;
    termData.chalkyKernel = num.tryParse(_ctrlChalkyKernel.text) ?? 0;
    termData.sortexComplianceStatus =
        sortexStatus[int.tryParse(sortexStatusIndex ?? '0') ?? 0];
    termData.comments = _ctrlComment.text;
    termData.startTime = _ctrlStartTime.text.convertToDateTime.convertToInt;
    termData.endTime = _ctrlEndTime.text.convertToDateTime.convertToInt;

    print(termData.toMapUpdate());
    if (widget.data == null) {
      final res = await AppSortex.insert(termData.toMapCreate());
      if (!res) return;
    } else {
      final res = await AppSortex.update(
          termData.toMapUpdate(), termData.id.toString());
      if (!res) return;
    }
    Navigator.pop(context, true);
  }

  processSelectLot() {
    final lot = lots[int.parse(lotIndex ?? '0')];
    _ctrlLocationId.text = lot.locationId.toString();
    _ctrlInputWhiteRiceQty.text = lot.whiteRiceOutput.toString();
    setState(() {});
  }

  processFinalSortex() {
    if (_ctrlChalkyKernel.text.isNotEmpty &&
        _ctrlDamagedKernel.text.isNotEmpty &&
        _ctrlPaddyKernel.text.isNotEmpty &&
        _ctrlInputWhiteRiceQty.text.isNotEmpty) {
      final inputWhiteRice = num.parse(_ctrlInputWhiteRiceQty.text);
      final redYellowKernels = num.parse(_ctrlRedYellowKernels.text) / 100;
      final chalkyKernel = num.parse(_ctrlChalkyKernel.text) / 100;
      final damagedKernel = num.parse(_ctrlDamagedKernel.text) / 100;
      _ctrlFinalSortexOutput.text = (inputWhiteRice *
              (1 - (chalkyKernel + redYellowKernels + damagedKernel)))
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
                        label: 'Input White Rice qty (kg)',
                        isReadOnly: true,
                        keyboardType: TextInputType.number,
                        controller: _ctrlInputWhiteRiceQty,
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Red/Yellow Kernels (%)',
                        keyboardType: TextInputType.number,
                        controller: _ctrlRedYellowKernels,
                        onChanged: (value) {
                          processFinalSortex();
                        },
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Damaged Kernel (%)',
                        keyboardType: TextInputType.number,
                        controller: _ctrlDamagedKernel,
                        onChanged: (value) {
                          processFinalSortex();
                        },
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Paddy Kernel / 50kg',
                        keyboardType: TextInputType.number,
                        controller: _ctrlPaddyKernel,
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Chalky Kernel (%)',
                        keyboardType: TextInputType.number,
                        controller: _ctrlChalkyKernel,
                        onChanged: (value) {
                          processFinalSortex();
                        },
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Final Sortex Output (kg)',
                        isReadOnly: true,
                        keyboardType: TextInputType.number,
                        controller: _ctrlFinalSortexOutput,
                      ),
                      const SizedBox(height: 20),
                      InputSelect(
                        label: 'Sortex Compliance Status',
                        hintText: 'Sortex Compliance Status',
                        items: sortexStatus,
                        index: sortexStatusIndex,
                        onChange: (value) {
                          sortexStatusIndex = value;
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
