import 'dart:ui';
import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/formula/models/formula_model.dart';
import 'package:rice_milling_mobile/presentation/pages/shell_route_wrapper/components/base_view/index.dart';
import 'package:rice_milling_mobile/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:rice_milling_mobile/generated/l10n.dart' as l;

import 'components/add_formula.dart';
import 'components/view_formula_ingredient.dart';
import 'models/storage_model.dart';

class FormulaView extends StatelessWidget {
  const FormulaView({super.key});

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
    await StoreFormula.instance.data.initFetch();
    setState(() {});
  }

  refresh() async {
    StoreFormula.instance.data.datas = null;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    await StoreFormula.instance.data.refresh();
    StoreFormulaIngredientDDown.instance.clear();
    setState(() {});
  }

  fetchNextPage() async {
    await StoreFormula.instance.data.fetchNextPage();
    setState(() {});
  }

  void _showFormDialog(BuildContext context, MFormula? mFormula) async {
    final res = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: AddFormulaDialog(mFormula: mFormula));
      },
    );
    if (res == null) return;
    if (res) refresh();
  }

  void _showViewDialog(BuildContext context, MFormula data) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: ViewFormulaIngredient(formula: data));
      },
    );
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
      bodyWidget: StoreFormula.instance.data.datas == null
          ? const Center(child: CircularProgressIndicator())
          : StoreFormula.instance.data.datas!.isEmpty
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
          const DataColumn(label: Text('Id')),
          DataColumn(label: Text(l.S.current.factory_formula)),
          DataColumn(label: Text(l.S.current.factory_formula)),
          DataColumn(
              label: Text(l.S.current.factory_approx_waster_percentage_qty)),
          DataColumn(label: Text(l.S.current.factory_expected_yield_per_batch)),
          DataColumn(label: Text(l.S.current.action)),
        ],
        rows: StoreFormula.instance.data.datas!.map(
          (data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              selected: false,
              cells: [
                DataCell(Text(data.formulaId)),
                DataCell(Text(data.formulaName)),
                DataCell(Text(data.cloneFormulaId)),
                DataCell(Text(data.approxWastageQty.toString())),
                DataCell(Text(data.expectedYieldPerBatch.toString())),
                DataCell(
                  PopupMenuButton<String>(
                    iconColor: theme.colorScheme.onTertiary,
                    color: theme.colorScheme.primaryContainer,
                    onSelected: (action) {
                      switch (action) {
                        case 'View':
                          _showViewDialog(context, data);
                          break;
                        // case 'Edit':
                        //   _showFormDialog(context, data);
                        //   break;
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'View',
                          child: Text(
                            lang.view,
                            style: textTheme.bodyMedium,
                          ),
                        ),
                        // PopupMenuItem<String>(
                        //   value: 'Edit',
                        //   child: Text(
                        //     lang.edit,
                        //     style: textTheme.bodyMedium,
                        //   ),
                        // ),
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
