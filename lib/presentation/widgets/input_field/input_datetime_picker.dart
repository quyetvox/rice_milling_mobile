import 'package:rice_milling_mobile/domain/core/static/_static_values.dart';
import 'package:rice_milling_mobile/domain/helpers/field_styles/_input_field_styles.dart';
import 'package:rice_milling_mobile/presentation/widgets/textfield_wrapper/_textfield_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class InputDateTimePicker extends StatelessWidget {
  const InputDateTimePicker(
      {super.key, required this.label, required this.controller});
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return TextFieldLabelWrapper(
      labelText: label,
      labelStyle: textTheme.bodySmall,
      inputField: TextFormField(
        controller: controller,
        keyboardType: TextInputType.visiblePassword,
        readOnly: true,
        selectionControls: EmptyTextSelectionControls(),
        decoration: InputDecoration(
          hintText: AppDateConfig.appNumberOnlyDateTimeFormat,
          suffixIcon: const Icon(IconlyLight.calendar, size: 20),
          suffixIconConstraints: AcnooInputFieldStyles(context).iconConstraints,
        ),
        onTap: () async {
          final _result = await showOmniDateTimePicker(
            firstDate: AppDateConfig.appFirstDate,
            lastDate: AppDateConfig.appLastDate,
            initialDate: DateTime.now(),
            context: context,
          );

          if (_result != null) {
            controller.text =
                DateFormat(AppDateConfig.appNumberOnlyDateTimeFormat)
                    .format(_result);
          }
        },
      ),
    );
  }
}
