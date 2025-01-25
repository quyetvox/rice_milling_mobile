import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InputSelect extends StatefulWidget {
  InputSelect(
      {super.key,
      required this.label,
      required this.hintText,
      required this.items,
      this.isDisable = false,
      this.index,
      required this.onChange});

  final String label;
  final String hintText;
  final List<String> items;
  final bool isDisable;
  final Function(String? value) onChange;

  String? index;

  @override
  State<InputSelect> createState() => _InputSelectState();
}

class _InputSelectState extends State<InputSelect> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return IgnorePointer(
      ignoring: widget.isDisable,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: textTheme.bodySmall),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            dropdownColor: theme.colorScheme.primaryContainer,
            value: widget.index,
            isExpanded: true,
            hint: Text(
              widget.hintText,
              style: textTheme.bodySmall,
            ),
            items: widget.items.asMap().entries.map((e) {
              return DropdownMenuItem<String>(
                value: e.key.toString(),
                child: Text(
                  e.value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color:
                          widget.isDisable ? AcnooAppColors.kNeutral500 : null),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (widget.isDisable) return;
              setState(() {
                widget.index = value;
                widget.onChange(value);
              });
            },
            validator: (value) => value == null ? widget.hintText : null,
          ),
        ],
      ),
    );
  }
}
