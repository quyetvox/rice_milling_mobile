// ignore_for_file: must_be_immutable

import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  InputText(
      {super.key,
      required this.label,
      this.hintText,
      required this.controller,
      this.keyboardType = TextInputType.text,
      this.maxlines = 1,
      this.isDisable = false,
      this.onChange,
      this.onTapOutside});
  final String label;
  String? hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxlines;
  final bool isDisable;
  final Function(String value)? onChange;
  final Function()? onTapOutside;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return IgnorePointer(
      ignoring: isDisable,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.bodySmall),
          const SizedBox(height: 8),
          TextFormField(
            keyboardType: keyboardType,
            controller: controller,
            style:
                TextStyle(color: isDisable ? AcnooAppColors.kNeutral500 : null),
            maxLines: maxlines,
            decoration: InputDecoration(
                hintText: hintText ?? label, hintStyle: textTheme.bodySmall),
            validator: (value) => value?.isEmpty ?? true ? hintText : null,
            onChanged: onChange,
            onTapOutside: (event) {
              onTapOutside;
            },
          ),
        ],
      ),
    );
  }
}
