import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/brown_rice_milling/form_add.dart';
import 'package:rice_milling_mobile/presentation/pages/shell_route_wrapper/components/base_view/index.dart';
import 'package:rice_milling_mobile/presentation/widgets/custom_button/custom_app_button.dart';

import 'models/brown_rice_milling.dart';

class BrownRiceMillingView extends StatelessWidget {
  const BrownRiceMillingView({super.key});

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
    await StoreBrownRiceProcessingQC.instance.data.initFetch();
    setState(() {});
  }

  refresh() async {
    StoreBrownRiceProcessingQC.instance.data.datas = null;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    await StoreBrownRiceProcessingQC.instance.data.refresh();
    setState(() {});
  }

  fetchNextPage() async {
    await StoreBrownRiceProcessingQC.instance.data.fetchNextPage();
    setState(() {});
  }

  void _showFormDialog(BuildContext context, MBrownRiceMilling? data) async {
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
      bodyWidget: StoreBrownRiceProcessingQC.instance.data.datas == null
          ? const Center(child: CircularProgressIndicator())
          : StoreBrownRiceProcessingQC.instance.data.datas!.isEmpty
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
          DataColumn(label: Text('Input Husked Brown Rice Qty')),
          DataColumn(label: Text('Unhusked Paddy Removed')),
          DataColumn(label: Text('Final Brown Rice Output')),
          DataColumn(label: Text('Start Time')),
          DataColumn(label: Text('End Time')),
          DataColumn(label: Text('Comments')),
          DataColumn(label: Text('Actions')),
        ],
        rows: StoreBrownRiceProcessingQC.instance.data.datas!.map((data) {
          return DataRow(
            cells: [
              DataCell(Text(data.id.toString())),
              DataCell(Text(data.locationId.toString())),
              DataCell(Text(data.inputHuskedBrownRiceQty.toString())),
              DataCell(Text(data.unhuskedPaddyRemoved.toString())),
              DataCell(Text(data.finalBrownRiceQty.toString())),
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
