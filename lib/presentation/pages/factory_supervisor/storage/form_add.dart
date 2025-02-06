import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:rice_milling_mobile/application/app_other.dart';
import 'package:rice_milling_mobile/application/stage/app_storage.dart';
import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/domain/helpers/extensions/extention_datetime.dart';
import 'package:rice_milling_mobile/domain/helpers/helpers.dart';
import 'package:rice_milling_mobile/domain/models/other/milling_factory.dart';
import 'package:rice_milling_mobile/generated/l10n.dart' as l;
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/drying/models/drying.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/storage/models/storage.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_datetime_picker.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_select.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_text.dart';

class FormAdd extends StatefulWidget {
  const FormAdd({super.key, this.data});
  final MStorage? data;

  @override
  State<FormAdd> createState() => _FormAddState();
}

class _FormAddState extends State<FormAdd> {
  late MStorage termData;

  List<MDrying> lots = [];
  String? lotIndex;

  List<String> storageTypes = []; // Storage Type Dropdown
  String? storageTypeIndex;

  List<String> storageStatus = [];
  String? storageStatusIndex;

  List<MMillingFactory> millingFactorys = [];
  String? millingFactoryIndex;

  final _ctrlFinalDriedPaddyQty = TextEditingController();
  final _ctrlStoredPaddyQty = TextEditingController();
  final _ctrlStartTime = TextEditingController();
  final _ctrlEndTime = TextEditingController();
  final _ctrlComments = TextEditingController();
  final _ctrlLocationId = TextEditingController();

  @override
  void initState() {
    super.initState();
    initData();
  }

  fetchingData() async {
    await Future.wait([
      fetchCatalogue(),
      fetchMillingFactory(),
      fetchLot(),
    ]);
  }

  Future fetchLot() async {
    await StoreDrying.instance.data.initFetch();
    lots = StoreDrying.instance.data.datas ?? [];
  }

  Future fetchMillingFactory() async {
    await StoreMillingFactory.instance.data.initFetch();
    millingFactorys = StoreMillingFactory.instance.data.datas ?? [];
  }

  Future fetchCatalogue() async {
    final catalogues = await AppOther.catalogues();
    if (catalogues.isEmpty) return;
    storageStatus = catalogues.firstWhere((e) => e.key == 'qc_status').values;
    storageTypes = catalogues.firstWhere((e) => e.key == 'storage_type').values;
  }

  initData() async {
    await fetchingData();
    if (widget.data == null) {
      termData = MStorage.fromJson({});
    } else {
      termData = MStorage.copy(widget.data!);
      _ctrlStartTime.text =
          DateTime.fromMillisecondsSinceEpoch(termData.startTime as int)
              .convertDateTimeToString;
      _ctrlEndTime.text =
          DateTime.fromMillisecondsSinceEpoch(termData.endTime as int)
              .convertDateTimeToString;
      lotIndex = lots.indexWhereOrNull(
          (e) => e.lotId.toString() == termData.lotId.toString());
      storageTypeIndex =
          storageTypes.indexWhereOrNull((e) => e == termData.storageType);
      storageStatusIndex = storageStatus
          .indexWhereOrNull((e) => e == termData.storageComplianceStatus);
      millingFactoryIndex =
          millingFactorys.indexWhereOrNull((e) => e.id == termData.locationId);
      _ctrlLocationId.text = termData.locationId.toString();
      _ctrlFinalDriedPaddyQty.text = termData.finalDriedPaddyQty.toString();
      _ctrlStoredPaddyQty.text = termData.storedPaddyQty.toString();
      _ctrlComments.text = termData.comments;
    }
    setState(() {});
  }

  saveData() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final lot = lots[int.parse(lotIndex ?? '0')];
    termData.lotId = lot.lotId;
    termData.locationId =
        millingFactorys[int.parse(millingFactoryIndex ?? '0')].id;
    termData.finalDriedPaddyQty =
        num.tryParse(_ctrlFinalDriedPaddyQty.text) ?? 0;
    termData.storageType =
        storageTypes[int.tryParse(storageTypeIndex ?? '0') ?? 0];
    termData.storageComplianceStatus =
        storageStatus[int.tryParse(storageStatusIndex ?? '0') ?? 0];
    termData.storedPaddyQty = num.tryParse(_ctrlStoredPaddyQty.text) ?? 0;
    termData.comments = _ctrlComments.text;
    termData.startTime = _ctrlStartTime.text.convertToDateTime.convertToInt;
    termData.endTime = _ctrlEndTime.text.convertToDateTime.convertToInt;
    print(termData.toMapUpdate());
    if (widget.data == null) {
      final res = await AppStorage.insert(termData.toMapCreate());
      if (!res) return;
    } else {
      final res = await AppStorage.update(
          termData.toMapUpdate(), termData.id.toString());
      if (!res) return;
    }
    Navigator.pop(context, true);
  }

  processSelectLot() {
    final lot = lots[int.parse(lotIndex ?? '0')];
    _ctrlLocationId.text = lot.locationId.toString();
    _ctrlFinalDriedPaddyQty.text = lot.finalDiredPaddyQty.toString();
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
                        label: 'Final Dried Paddy Qty (kg)',
                        isReadOnly: true,
                        keyboardType: TextInputType.number,
                        controller: _ctrlFinalDriedPaddyQty,
                      ),
                      const SizedBox(height: 20),
                      InputSelect(
                        label: 'Storage Type',
                        hintText: 'Storage Type',
                        items: storageTypes.map((e) => e.toString()).toList(),
                        index: storageTypeIndex,
                        onChange: (value) {
                          storageTypeIndex = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputSelect(
                        label: 'Factory',
                        hintText: 'Factory',
                        items: millingFactorys
                            .map((e) => e.name.toString())
                            .toList(),
                        index: millingFactoryIndex,
                        onChange: (value) {
                          millingFactoryIndex = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputText(
                        label: 'Stored Paddy Qty (kg)',
                        keyboardType: TextInputType.number,
                        controller: _ctrlStoredPaddyQty,
                      ),
                      const SizedBox(height: 20),
                      InputSelect(
                        label: 'Storage Compliance Status',
                        hintText: 'Storage Compliance Status',
                        items: storageStatus,
                        index: storageStatusIndex,
                        onChange: (value) {
                          storageStatusIndex = value;
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
