import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:rice_milling_mobile/domain/core/static/_static_values.dart';
import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/packaging/form_add.dart';
import 'package:rice_milling_mobile/presentation/pages/shell_route_wrapper/components/base_view/index.dart';
import 'package:rice_milling_mobile/presentation/widgets/custom_button/custom_app_button.dart';
import 'package:rice_milling_mobile/generated/l10n.dart' as l;

import 'models/packaging.dart';

class PackagingView extends StatelessWidget {
  const PackagingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PackagingDataListView();
  }
}

class _PackagingDataListView extends StatefulWidget {
  const _PackagingDataListView();

  @override
  State<_PackagingDataListView> createState() => _PackagingDataListViewState();
}

class _PackagingDataListViewState extends State<_PackagingDataListView> {
  @override
  void initState() {
    super.initState();
    iniFetch();
  }

  iniFetch() async {
    await StorePackagingQC.instance.data.initFetch();
    setState(() {});
  }

  refresh() async {
    StorePackagingQC.instance.data.datas = null;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    await StorePackagingQC.instance.data.refresh();
    setState(() {});
  }

  fetchNextPage() async {
    await StorePackagingQC.instance.data.fetchNextPage();
    setState(() {});
  }

  void _showFormDialog(BuildContext context, MPackagingQC? data) async {
    final res = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: FormAdd(data: data)
          );
      },
    );
    if (res == null) return;
    if (res) {
      refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      headerWidget: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppAddButton(onAction: () => _showFormDialog(context, null)),
          const Spacer(),
          AppRefreshButton(onAction: () => refresh()),
        ],
      ),
      bodyWidget: StorePackagingQC.instance.data.datas == null
          ? const Center(child: CircularProgressIndicator())
          : StorePackagingQC.instance.data.datas!.isEmpty
              ? const SizedBox(
                  height: 500,
                  child: Center(
                    child: Text('No data'),
                  ),
                )
              : packagingProcessDataTable(context),
    );
  }

  TextFormField searchFormField({required TextTheme textTheme}) {
    final lang = l.S.of(context);
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
        hintText: '${lang.search}...',
        hintStyle: textTheme.bodySmall,
        suffixIcon: Container(
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: AcnooAppColors.kPrimary700,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: const Icon(IconlyLight.search, color: AcnooAppColors.kWhiteColor),
        ),
      ),
      onChanged: (value) {
        //_setSearchQuery(value);
      },
    );
  }

  Theme packagingProcessDataTable(BuildContext context) {
    final lang = l.S.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Theme(
      data: ThemeData(
          dividerColor: theme.colorScheme.outline,
          dividerTheme: DividerThemeData(
            color: theme.colorScheme.outline,
          )),
      child: DataTable(
        checkboxHorizontalMargin: 16,
        headingTextStyle: textTheme.titleMedium,
        dataTextStyle: textTheme.bodySmall,
        headingRowColor: WidgetStateProperty.all(theme.colorScheme.surface),
        showBottomBorder: true,
        columns: const [
          DataColumn(label: Text('Lot Id')),
          DataColumn(label: Text('Location')),
          DataColumn(label: Text('Blended Rice Input')),
          DataColumn(label: Text('Units Packed')),
          DataColumn(label: Text('Weight Per Unit')),
          //DataColumn(label: Text('QR Code')),
          DataColumn(label: Text('Packaging Compliance Status')),
          DataColumn(label: Text('Start Time')),
          DataColumn(label: Text('End Time')),
          DataColumn(label: Text('Comments')),
          DataColumn(label: Text('Actions')),
        ],
        rows: StorePackagingQC.instance.data.datas!.map(
          (data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              selected: false,
              cells: [
                DataCell(Text(data.id.toString())),
                DataCell(Text(data.locationId.toString())),
                DataCell(Text(data.blendedRiceInputQty.toString())),
                DataCell(Text(data.unitsPacked.toString())),
                DataCell(Text(data.weightPerUnit.toString())),
                //DataCell(Text(data.qrCode.toString())),
                DataCell(Text(data.packagingComplianceStatus.toString())),
                DataCell(
                  Text(DateFormat(AppDateConfig.appNumberOnlyDateTimeFormat)
                      .format(DateTime.fromMillisecondsSinceEpoch(
                          data.startTime as int))),
                ),
                DataCell(
                  Text(DateFormat(AppDateConfig.appNumberOnlyDateTimeFormat)
                      .format(DateTime.fromMillisecondsSinceEpoch(
                          data.endTime as int))),
                ),
                DataCell(Text(data.comments.toString())),
                DataCell(
                  PopupMenuButton<String>(
                    iconColor: theme.colorScheme.onTertiary,
                    color: theme.colorScheme.primaryContainer,
                    onSelected: (action) {
                      switch (action) {
                        case 'Edit':
                          _showFormDialog(context, data);
                          break;
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'Edit',
                          child: Text(
                            lang.edit,
                            style: textTheme.bodyMedium,
                          ),
                        ),
                      ];
                    },
                  ),
                ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}
