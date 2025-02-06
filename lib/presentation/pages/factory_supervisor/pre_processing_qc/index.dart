import 'dart:ui';
import 'package:rice_milling_mobile/domain/core/static/_static_values.dart';
import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/pre_processing_qc/form_add.dart';
import 'package:rice_milling_mobile/presentation/pages/shell_route_wrapper/components/base_view/index.dart';
import 'package:rice_milling_mobile/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:rice_milling_mobile/generated/l10n.dart' as l;
import 'package:intl/intl.dart';
import 'models/pre_processing.dart';

class PreProcessingQCView extends StatelessWidget {
  const PreProcessingQCView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DataListView();
  }
}

class _DataListView extends StatefulWidget {
  const _DataListView();

  @override
  State<_DataListView> createState() => _DataListViewState();
}

class _DataListViewState extends State<_DataListView> {
  @override
  void initState() {
    super.initState();
    iniFetch();
  }

  iniFetch() async {
    await StorePreProcessingQC.instance.data.initFetch();
    setState(() {});
  }

  refresh() async {
    StorePreProcessingQC.instance.data.datas = null;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    await StorePreProcessingQC.instance.data.refresh();
    setState(() {});
  }

  fetchNextPage() async {
    await StorePreProcessingQC.instance.data.fetchNextPage();
    setState(() {});
  }

  void _showFormDialog(
      BuildContext context, MPreProcessingQC? data) async {
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
      bodyWidget: StorePreProcessingQC.instance.data.datas == null
          ? const Center(child: CircularProgressIndicator())
          : StorePreProcessingQC.instance.data.datas!.isEmpty
              ? const SizedBox(
                  height: 500,
                  child: Center(
                    child: Text('No data'),
                  ),
                )
              : userListDataTable(context),
    );
  }

  TextFormField searchFormField({required TextTheme textTheme}) {
    final lang = l.S.of(context);
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
        // hintText: 'Search...',
        hintText: '${lang.search}...',
        hintStyle: textTheme.bodySmall,
        suffixIcon: Container(
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: AcnooAppColors.kPrimary700,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child:
              const Icon(IconlyLight.search, color: AcnooAppColors.kWhiteColor),
        ),
      ),
      onChanged: (value) {
        //_setSearchQuery(value);
      },
    );
  }

  Theme userListDataTable(BuildContext context) {
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
          DataColumn(label: Text('Lot Qty')),
          DataColumn(label: Text('Raw Paddy Weight')),
          DataColumn(label: Text('Moisture Content')),
          DataColumn(label: Text('Impurity Level')),
          DataColumn(label: Text('Grain Damage')),
          DataColumn(label: Text('Uniformity Score')),
          DataColumn(label: Text('QC Status')),
          DataColumn(label: Text('Final QC Approved Qty')),
          DataColumn(label: Text('Comments')),
          DataColumn(label: Text('Inspection Time')),
          DataColumn(label: Text('Actions')),
        ],
        rows: StorePreProcessingQC.instance.data.datas!.map(
          (data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              selected: false,
              cells: [
                DataCell(Text(data.id.toString())),
                DataCell(Text(data.locationId.toString())),
                DataCell(Text(data.lotQty.toString())),
                DataCell(Text(data.rawPaddyWeight.toString())),
                DataCell(Text(data.moistureContent.toString())),
                DataCell(Text(data.impurityLevel.toString())),
                DataCell(Text(data.grainDamage.toString())),
                DataCell(Text(data.uniformityScore.toString())),
                DataCell(Text(data.qcStatus.toString())),
                DataCell(Text(data.finalQcApprovedQty.toString())),
                DataCell(Text(data.comments.toString())),
                DataCell(
                  Text(DateFormat(AppDateConfig.appNumberOnlyDateTimeFormat)
                      .format(DateTime.fromMillisecondsSinceEpoch(
                          data.inspectionTime as int))),
                ),
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
