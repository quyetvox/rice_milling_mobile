import 'dart:ui';
import 'package:rice_milling_mobile/domain/core/static/_static_values.dart';
import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/qc_check_stage/components/add_qccheck.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/qc_check_stage/models/qc_check_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/qc_check_stage/models/store_model.dart';
import 'package:rice_milling_mobile/presentation/pages/shell_route_wrapper/components/base_view/index.dart';
import 'package:rice_milling_mobile/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:rice_milling_mobile/generated/l10n.dart' as l;
import 'package:intl/intl.dart';

class QCCheckStageView extends StatelessWidget {
  const QCCheckStageView({super.key});

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
    await StoreQCCheck.instance.data.initFetch();
    setState(() {});
  }

  refresh() async {
    StoreQCCheck.instance.data.datas = null;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    await StoreQCCheck.instance.data.refresh();
    setState(() {});
  }

  fetchNextPage() async {
    await StoreQCCheck.instance.data.fetchNextPage();
    setState(() {});
  }

  void _showFormDialog(BuildContext context, MQCCheckStage? data) async {
    final res = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: AddQCCheckDialog(data: data));
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
      bodyWidget: StoreQCCheck.instance.data.datas == null
          ? const Center(child: CircularProgressIndicator())
          : StoreQCCheck.instance.data.datas!.isEmpty
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
        columns: [
          DataColumn(label: Text(l.S.current.stage_batch)),
          DataColumn(label: Text(l.S.current.stage_product)),
          DataColumn(label: Text(l.S.current.stage_start_time)),
          DataColumn(label: Text(l.S.current.stage_end_time)),
          DataColumn(label: Text(l.S.current.stage_sample_qty)),
          DataColumn(label: Text(l.S.current.stage_qc_status)),
          DataColumn(label: Text(l.S.current.stage_issues_detected)),
          DataColumn(label: Text(l.S.current.stage_corrective_actions)),
          DataColumn(label: Text(l.S.current.stage_fine_material_output_qty)),
          DataColumn(label: Text(l.S.current.stage_comments)),
          DataColumn(label: Text(l.S.current.action)),
        ],
        rows: StoreQCCheck.instance.data.datas!.map(
          (data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              selected: false,
              cells: [
                DataCell(Text(data.batchId.toString())),
                DataCell(Text(data.product.toString())),
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
                DataCell(Text(data.sampleQty.toString())),
                DataCell(Text(data.qcStatus)),
                DataCell(Text(data.issuesDetected)),
                DataCell(Text(data.correctiveActions)),
                DataCell(Text(data.fineMaterialOutputQty.toString())),
                DataCell(Text(data.comments)),
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
                            //'Edit',
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
