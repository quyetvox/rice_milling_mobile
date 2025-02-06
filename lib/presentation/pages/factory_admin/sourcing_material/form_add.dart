import 'package:flutter/material.dart';
import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_datetime_picker.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_select.dart';
import 'package:rice_milling_mobile/presentation/widgets/input_field/input_text.dart';

import 'package:rice_milling_mobile/generated/l10n.dart' as l;
import 'package:responsive_framework/responsive_framework.dart' as rf;

class FormAdd extends StatefulWidget {
  const FormAdd({super.key, this.data});
  final dynamic data;

  @override
  State<FormAdd> createState() => _FormAddState();
}

class _FormAddState extends State<FormAdd> {
  final TextEditingController _ctrlSourcingDate = TextEditingController();
  final TextEditingController _ctrlTotalLandHolding = TextEditingController();
  final TextEditingController _ctrlVehicleType = TextEditingController();
  final TextEditingController _ctrlVehicleCapacity = TextEditingController();
  final TextEditingController _ctrlSourceLocation = TextEditingController();
  final TextEditingController _ctrlQuantitySourced = TextEditingController();
  final TextEditingController _ctrlComments = TextEditingController();

  String? farmerIndex;
  String? vehicleIndex;
  String? destinationIndex;
  String? paddyVarietyIndex;

  List<String> farmers = ['Farmer_1', 'Farmer_2'];
  List<String> vehicles = ['Vehicle_1', 'Vehicle_2'];
  List<String> locations = ['Location_1', 'Location_2'];
  List<String> paddyVarieties = ['Paddy_1', 'Paddy_2'];

  saveData() async {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pop(context, true);
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputDateTimePicker(
                  label: 'Sourcing Date',
                  controller: _ctrlSourcingDate,
                ),
                const SizedBox(height: 16),
                InputSelect(
                    label: 'Farmer Name',
                    hintText: 'Select Farmer',
                    items: farmers,
                    index: farmerIndex,
                    onChange: (value) {}),
                const SizedBox(height: 16),
                InputText(
                  label: 'Total Land Holding (HA)',
                  controller: _ctrlTotalLandHolding,
                ),
                const SizedBox(height: 16),
                InputSelect(
                    label: 'Vehicle Id',
                    hintText: 'Select Vehicle',
                    items: vehicles,
                    index: vehicleIndex,
                    onChange: (value) {}),
                const SizedBox(height: 16),
                InputText(
                  label: 'Vehicle Type',
                  controller: _ctrlVehicleType,
                ),
                const SizedBox(height: 16),
                InputText(
                  label: 'Vehicle Capacity',
                  controller: _ctrlVehicleCapacity,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                InputText(
                  label: 'Source Location',
                  controller: _ctrlSourceLocation,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                InputSelect(
                    label: 'Destination Location',
                    hintText: 'Select Location',
                    items: locations,
                    index: destinationIndex,
                    onChange: (value) {}),
                const SizedBox(height: 16),
                InputSelect(
                    label: 'Paddy Variety',
                    hintText: 'Select Paddy Variety',
                    items: paddyVarieties,
                    index: paddyVarietyIndex,
                    onChange: (value) {}),
                const SizedBox(height: 16),
                InputText(
                  label: 'Quantity Sourced',
                  controller: _ctrlQuantitySourced,
                ),
                const SizedBox(height: 16),
                InputText(
                  label: 'Comments',
                  controller: _ctrlComments,
                  maxlines: 3,
                ),
                const SizedBox(height: 24),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: _sizeInfo.innerSpacing),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: _sizeInfo.innerSpacing),
                            backgroundColor: theme.colorScheme.primaryContainer,
                            textStyle: textTheme.bodySmall
                                ?.copyWith(color: AcnooAppColors.kError),
                            side:
                                const BorderSide(color: AcnooAppColors.kError)),
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
