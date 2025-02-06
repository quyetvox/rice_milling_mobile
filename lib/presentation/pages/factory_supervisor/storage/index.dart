import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/storage/form_add.dart';
import 'package:rice_milling_mobile/presentation/pages/shell_route_wrapper/components/base_view/index.dart';
import 'package:rice_milling_mobile/presentation/widgets/custom_button/custom_app_button.dart';

import 'models/storage.dart';

class StorageView extends StatelessWidget {
  const StorageView({super.key});

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
    await StoreStorageQC.instance.data.initFetch();
    setState(() {});
  }

  refresh() async {
    StoreStorageQC.instance.data.datas = null;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    await StoreStorageQC.instance.data.refresh();
    setState(() {});
  }

  fetchNextPage() async {
    await StoreStorageQC.instance.data.fetchNextPage();
    setState(() {});
  }

  void _showFormDialog(BuildContext context, MStorage? data) async {
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
      bodyWidget: StoreStorageQC.instance.data.datas == null
          ? const Center(child: CircularProgressIndicator())
          : StoreStorageQC.instance.data.datas!.isEmpty
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
          //DataColumn(label: Text('Location')),
          DataColumn(label: Text('Final Dried Paddy Qty')),
          DataColumn(label: Text('Storage Type')),
          DataColumn(label: Text('Factory')),
          DataColumn(label: Text('Stored Paddy Qty')),
          DataColumn(label: Text('Storage Compliance Status')),
          DataColumn(label: Text('Start Time')),
          DataColumn(label: Text('End Time')),
          DataColumn(label: Text('Comments')),
          DataColumn(label: Text('Actions')),
        ],
        rows: StoreStorageQC.instance.data.datas!.map((data) {
          return DataRow(
            cells: [
              DataCell(Text(data.id.toString())),
              //DataCell(Text(data.locationId.toString())),
              DataCell(Text(data.finalDriedPaddyQty.toString())),
              DataCell(Text(data.storageType.toString())),
              DataCell(Text(data.locationId.toString())),
              DataCell(Text(data.storedPaddyQty.toString())),
              DataCell(Text(data.storageComplianceStatus.toString())),
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
