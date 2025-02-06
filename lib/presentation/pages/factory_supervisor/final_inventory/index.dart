import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/final_inventory/form_add.dart';
import 'package:rice_milling_mobile/presentation/pages/shell_route_wrapper/components/base_view/index.dart';
import 'package:rice_milling_mobile/presentation/widgets/custom_button/custom_app_button.dart';
import 'package:rice_milling_mobile/generated/l10n.dart' as l;

import 'models/final_inventory.dart';

class FinalInventoryView extends StatelessWidget {
  const FinalInventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StockDataListView();
  }
}

class _StockDataListView extends StatefulWidget {
  const _StockDataListView();

  @override
  State<_StockDataListView> createState() => _StockDataListViewState();
}

class _StockDataListViewState extends State<_StockDataListView> {
  @override
  void initState() {
    super.initState();
    iniFetch();
  }

  iniFetch() async {
    await StoreFinalInventory.instance.data.initFetch();
    setState(() {});
  }

  refresh() async {
    StoreFinalInventory.instance.data.datas = null;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    await StoreFinalInventory.instance.data.refresh();
    setState(() {});
  }

  fetchNextPage() async {
    await StoreFinalInventory.instance.data.fetchNextPage();
    setState(() {});
  }

  void _showFormDialog(BuildContext context, MFinalInventory? data) async {
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
      bodyWidget: StoreFinalInventory.instance.data.datas == null
          ? const Center(child: CircularProgressIndicator())
          : StoreFinalInventory.instance.data.datas!.isEmpty
              ? const SizedBox(
                  height: 500,
                  child: Center(
                    child: Text('No data'),
                  ),
                )
              : stockDataTable(context),
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

  Theme stockDataTable(BuildContext context) {
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
          DataColumn(label: Text('Finished Product')),
          DataColumn(label: Text('Existing Stock')),
          DataColumn(label: Text('Current Stock')),
          DataColumn(label: Text('Total Available Stock')),
          DataColumn(label: Text('Comments')),
          DataColumn(label: Text('Actions')),
        ],
        rows: StoreFinalInventory.instance.data.datas!.map(
          (data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              selected: false,
              cells: [
                DataCell(Text(data.lotId.toString())),
                DataCell(Text(data.locationId.toString())),
                DataCell(Text(data.finishedProductId.toString())),
                DataCell(Text(data.existingStock.toString())),
                DataCell(Text(data.currentStock.toString())),
                DataCell(Text(data.totalAvailableStock.toString())),
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
