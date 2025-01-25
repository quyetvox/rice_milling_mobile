import 'dart:ui';
import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/inventory_stage/components/add_inventory.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/inventory_stage/models/inventory_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/inventory_stage/models/store_model.dart';
import 'package:rice_milling_mobile/presentation/pages/shell_route_wrapper/components/base_view/index.dart';
import 'package:rice_milling_mobile/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:rice_milling_mobile/generated/l10n.dart' as l;

class InvetoryStageView extends StatelessWidget {
  const InvetoryStageView({super.key});

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
    await StoreInventory.instance.data.initFetch();
    setState(() {});
  }

  refresh() async {
    StoreInventory.instance.data.datas = null;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    await StoreInventory.instance.data.refresh();
    setState(() {});
  }

  fetchNextPage() async {
    await StoreInventory.instance.data.fetchNextPage();
    setState(() {});
  }

  void _showFormDialog(BuildContext context, MInventoryStage? data) async {
    final res = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: AddInventoryDialog(data: data));
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
      bodyWidget: StoreInventory.instance.data.datas == null
          ? const Center(child: CircularProgressIndicator())
          : StoreInventory.instance.data.datas!.isEmpty
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
    //final lang = l.S.of(context);
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
          DataColumn(label: Text(l.S.current.stage_finished_product_id)),
          DataColumn(label: Text(l.S.current.stage_warehouse)),
          DataColumn(label: Text(l.S.current.stage_existing_stock)),
          DataColumn(label: Text(l.S.current.stage_current_stock)),
          DataColumn(label: Text(l.S.current.stage_total_availale_stock)),
          DataColumn(label: Text(l.S.current.stage_comments)),
          //DataColumn(label: Text(l.S.current.action)),
        ],
        rows: StoreInventory.instance.data.datas!.map(
          (data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              selected: false,
              cells: [
                DataCell(Text(data.batchId.toString())),
                DataCell(Text(data.finishedProductId.toString())),
                DataCell(Text(data.warehouseId.toString())),
                DataCell(Text(data.existingStock.toString())),
                DataCell(Text(data.currentStock.toString())),
                DataCell(Text(data.totalAvailableStock.toString())),
                DataCell(Text(data.comments)),
                // DataCell(
                //   PopupMenuButton<String>(
                //     iconColor: theme.colorScheme.onTertiary,
                //     color: theme.colorScheme.primaryContainer,
                //     onSelected: (action) {
                //       switch (action) {
                //         case 'Edit':
                //           _showFormDialog(context, data);
                //           break;
                //       }
                //     },
                //     itemBuilder: (context) {
                //       return [
                //         PopupMenuItem<String>(
                //           value: 'Edit',
                //           child: Text(
                //             lang.edit,
                //             //'Edit',
                //             style: textTheme.bodyMedium,
                //           ),
                //         ),
                //       ];
                //     },
                //   ),
                // ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}
