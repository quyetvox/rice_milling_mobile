import 'dart:ui';
import 'package:rice_milling_mobile/application/factory_admin/app_ingredient.dart';
import 'package:rice_milling_mobile/domain/core/static/_static_values.dart';
import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/ingredient/models/ingredient_model.dart';
import 'package:rice_milling_mobile/presentation/pages/shell_route_wrapper/components/base_view/index.dart';
import 'package:rice_milling_mobile/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:rice_milling_mobile/generated/l10n.dart' as l;
import 'package:intl/intl.dart';

import 'components/add_ingredient.dart';
import 'models/storage_model.dart';

class IngredientView extends StatelessWidget {
  const IngredientView({super.key});

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
    await StoreIngredient.instance.data.initFetch();
    setState(() {});
  }

  refresh() async {
    StoreIngredient.instance.data.datas = null;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    await StoreIngredient.instance.data.refresh();
    setState(() {});
  }

  fetchNextPage() async {
    await StoreIngredient.instance.data.fetchNextPage();
    setState(() {});
  }

  Future cloneData(MIngredient data) async {
    MIngredient ingredient = MIngredient.copy(data);
    ingredient.expiryDate = DateTime.now().millisecondsSinceEpoch;
    final res = await AppIngredient.insert(ingredient.toMapCreate());
    if (res) {
      refresh();
    }
  }

  void _showFormDialog(BuildContext context, MIngredient? data) async {
    final res = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: AddIngredientDialog(ingredient: data));
      },
    );
    if (res == null) return;
    if (res) refresh();
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
      bodyWidget: StoreIngredient.instance.data.datas == null
          ? const Center(child: CircularProgressIndicator())
          : StoreIngredient.instance.data.datas!.isEmpty
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
          DataColumn(label: Text(l.S.current.factory_material_name)),
          DataColumn(label: Text(l.S.current.factory_category)),
          DataColumn(label: Text(l.S.current.factory_uom)),
          DataColumn(label: Text(l.S.current.factory_initial_stock_qty)),
          DataColumn(label: Text(l.S.current.factory_stock_qty)),
          DataColumn(label: Text(l.S.current.factory_total_current_stock_qty)),
          DataColumn(label: Text(l.S.current.factory_minimum_stock_qty_alert)),
          DataColumn(label: Text(l.S.current.factory_business_location)),
          DataColumn(label: Text(l.S.current.factory_expiry_date)),
          DataColumn(label: Text(l.S.current.action)),
        ],
        rows: StoreIngredient.instance.data.datas!.map(
          (data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              selected: false,
              cells: [
                DataCell(Text(data.materialName)),
                DataCell(Text(data.categoryId.toString())),
                DataCell(Text(data.uomId.toString())),
                DataCell(Text(data.initialStockQty.toString())),
                DataCell(Text(data.stockQty.toString())),
                DataCell(Text(data.totalCurrentStockQty.toString())),
                DataCell(Text(data.minimumStockQtyAlert.toString())),
                DataCell(Text(data.businessLocationId.toString())),
                DataCell(
                  Text(DateFormat(AppDateConfig.appNumberOnlyDateFormat).format(
                      DateTime.fromMillisecondsSinceEpoch(
                          data.expiryDate as int))),
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
                        case 'Copy':
                          cloneData(data);
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
                        PopupMenuItem<String>(
                          value: 'Copy',
                          child: Text(
                            lang.copy,
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
