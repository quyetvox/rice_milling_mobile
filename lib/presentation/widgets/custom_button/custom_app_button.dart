// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/generated/l10n.dart' as l;

class AppRefreshButton extends StatelessWidget {
  const AppRefreshButton({
    super.key,
    required this.onAction,
  });
  final Function() onAction;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
        backgroundColor: AcnooAppColors.kPrimary.withOpacity(0.6),
      ),
      onPressed: () => onAction(),
      label: Text(
        l.S.current.refresh,
        style: textTheme.bodySmall?.copyWith(
          color: AcnooAppColors.kWhiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconAlignment: IconAlignment.start,
      icon: const Icon(
        Icons.refresh,
        color: AcnooAppColors.kWhiteColor,
        size: 20.0,
      ),
    );
  }
}

class AppAddButton extends StatelessWidget {
  const AppAddButton({
    super.key,
    required this.onAction,
  });
  final Function() onAction;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      ),
      onPressed: () => onAction(),
      label: Text(
        l.S.current.add,
        style: textTheme.bodySmall?.copyWith(
          color: AcnooAppColors.kWhiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconAlignment: IconAlignment.start,
      icon: const Icon(
        Icons.add_circle_outline_outlined,
        color: AcnooAppColors.kWhiteColor,
        size: 20.0,
      ),
    );
  }
}
