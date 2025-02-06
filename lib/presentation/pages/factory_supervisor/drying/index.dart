import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/drying/form_add.dart';
import 'package:rice_milling_mobile/presentation/pages/shell_route_wrapper/components/base_view/index.dart';
import 'package:rice_milling_mobile/presentation/widgets/custom_button/custom_app_button.dart';

import 'models/drying.dart';

class DryingView extends StatelessWidget {
  const DryingView({super.key});

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
    await StoreDrying.instance.data.initFetch();
    setState(() {});
  }

  refresh() async {
    StoreDrying.instance.data.datas = null;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    await StoreDrying.instance.data.refresh();
    setState(() {});
  }

  fetchNextPage() async {
    await StoreDrying.instance.data.fetchNextPage();
    setState(() {});
  }

  void _showFormDialog(BuildContext context, MDrying? data) async {
    final res = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: FormAdd(data: data),
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
      bodyWidget: StoreDrying.instance.data.datas == null
          ? const Center(child: CircularProgressIndicator())
          : StoreDrying.instance.data.datas!.isEmpty
              ? const SizedBox(
                  height: 500,
                  child: Center(child: Text('No data')),
                )
              : userListDataTable(context),
    );
  }

  Theme userListDataTable(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Theme(
      data: ThemeData(dividerColor: theme.colorScheme.outline),
      child: DataTable(
        checkboxHorizontalMargin: 16,
        headingTextStyle: textTheme.titleMedium,
        dataTextStyle: textTheme.bodySmall,
        headingRowColor: WidgetStateProperty.all(theme.colorScheme.surface),
        showBottomBorder: true,
        columns: const [
          DataColumn(label: Text('Lot Id')),
          DataColumn(label: Text('Location')),
          DataColumn(label: Text('Pre-Cleaned Paddy Qty')),
          DataColumn(label: Text('Drying Technique')),
          DataColumn(label: Text('Initial Moisture Level')),
          DataColumn(label: Text('Final Moisture Level')),
          DataColumn(label: Text('Drying Loss Qty')),
          DataColumn(label: Text('Final Dired Paddy Qty')),
          DataColumn(label: Text('Drying Compliance Status')),
          DataColumn(label: Text('Start Time')),
          DataColumn(label: Text('End Time')),
          DataColumn(label: Text('Comments')),
          DataColumn(label: Text('Actions')),
        ],
        rows: StoreDrying.instance.data.datas!.map((data) {
          return DataRow(
            cells: [
              DataCell(Text(data.id.toString())),
              DataCell(Text(data.locationId.toString())),
              DataCell(Text(data.preCleanedPaddyQty.toString())),
              DataCell(Text(data.dryingTechnique.toString())),
              DataCell(Text(data.initialMoistureLevel.toString())),
              DataCell(Text(data.finalMoistureLevel.toString())),
              DataCell(Text(data.dryingLossQty.toString())),
              DataCell(Text(data.finalDiredPaddyQty.toString())),
              DataCell(Text(data.dryingComplianceStatus.toString())),
              DataCell(Text(
                DateFormat('yyyy-MM-dd HH:mm').format(
                  DateTime.fromMillisecondsSinceEpoch(data.startTime as int),
                ),
              )),
              DataCell(Text(
                DateFormat('yyyy-MM-dd HH:mm').format(
                  DateTime.fromMillisecondsSinceEpoch(data.endTime as int),
                ),
              )),
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
                          'Edit',
                          style: textTheme.bodyMedium,
                        ),
                      ),
                    ];
                  },
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
