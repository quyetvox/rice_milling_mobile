import 'dart:ui';
import 'package:rice_milling_mobile/domain/core/static/_static_values.dart';
import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/domain/models/other/uom_model.dart';
import 'package:rice_milling_mobile/infrastructure/storages/index.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/formula/models/formula_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/formula/models/storage_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/ingredient/models/ingredient_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/ingredient/models/storage_model.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/production_planning/models/production_planning_model.dart';
import 'package:rice_milling_mobile/presentation/pages/shell_route_wrapper/components/base_view/index.dart';
import 'package:rice_milling_mobile/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:rice_milling_mobile/generated/l10n.dart' as l;
import 'package:intl/intl.dart';

import 'components/add_planning.dart';
import 'models/storage_model.dart';

class ProductionPlanningView extends StatelessWidget {
  const ProductionPlanningView({super.key});

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
  final ScrollController _scrollController = ScrollController();
  List<MFormula> formulas = [];
  List<MUom> uoms = [];
  List<MIngredient> materials = [];

  @override
  void initState() {
    super.initState();
    iniFetch();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  iniFetch() async {
    //await fetchingData();
    await StoreProductionPlanning.instance.data.initFetch();
    setState(() {});
  }

  refresh() async {
    StoreProductionPlanning.instance.data.datas = null;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    await StoreProductionPlanning.instance.data.refresh();
    StoreIngredient.instance.clear();
    setState(() {});
  }

  fetchNextPage() async {
    await StoreProductionPlanning.instance.data.fetchNextPage();
    setState(() {});
  }

  fetchingData() async {
    await Future.wait([
      fetchMaterial(),
      fetchUom(),
      fetchFormula(),
    ]);
  }

  Future fetchMaterial() async {
    await StoreIngredient.instance.data.initFetch();
    materials = StoreIngredient.instance.data.datas ?? [];
  }

  Future fetchUom() async {
    await Storage.instance.uom.initFetch();
    uoms = Storage.instance.uom.datas ?? [];
  }

  Future fetchFormula() async {
    await StoreFormula.instance.data.initFetch();
    formulas = StoreFormula.instance.data.datas ?? [];
  }

  void _showFormDialog(BuildContext context, MProductionPlanning? data) async {
    final res = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5,
            sigmaY: 5,
          ),
          child: AddPlanningDialog(mProductionPlanning: data),
        );
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
      bodyWidget: StoreProductionPlanning.instance.data.datas == null
          ? const Center(child: CircularProgressIndicator())
          : StoreProductionPlanning.instance.data.datas!.isEmpty
              ? SizedBox(
                  height: 500,
                  child: Center(
                    child: Text(l.S.current.no_data),
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
          DataColumn(label: Text(l.S.current.factory_planning)),
          DataColumn(label: Text(l.S.current.factory_total_batch_qty)),
          DataColumn(label: Text(l.S.current.factory_start_date)),
          DataColumn(label: Text(l.S.current.factory_end_date)),
          DataColumn(label: Text(l.S.current.factory_shift_or_time_slot)),
          DataColumn(label: Text(l.S.current.factory_status)),
          DataColumn(label: Text(l.S.current.action)),
        ],
        rows: StoreProductionPlanning.instance.data.datas!.map(
          (data) {
            // final _uom = uoms.firstWhereOrNull((e) => e.id == data.uomId);
            // final _material =
            //     materials.firstWhereOrNull((e) => e.id == data.materialId);
            return DataRow(
              color: WidgetStateColor.transparent,
              selected: false,
              cells: [
                DataCell(Text(data.productionPlanId)),
                DataCell(Text(data.totalBatchQty.toString())),
                DataCell(
                  Text(DateFormat(AppDateConfig.appNumberOnlyDateFormat).format(
                      DateTime.fromMillisecondsSinceEpoch(
                          data.startDate as int))),
                ),
                DataCell(
                  Text(DateFormat(AppDateConfig.appNumberOnlyDateFormat).format(
                      DateTime.fromMillisecondsSinceEpoch(
                          data.endDate as int))),
                ),
                DataCell(Text(data.shift.toString())),
                DataCell(Text(data.status.toString())),
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
