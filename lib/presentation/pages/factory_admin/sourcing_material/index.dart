import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:rice_milling_mobile/domain/core/static/_static_values.dart';
import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
import 'package:rice_milling_mobile/presentation/pages/factory_admin/sourcing_material/models/sourcing_material.dart';
import 'package:rice_milling_mobile/presentation/pages/shell_route_wrapper/components/base_view/index.dart';
import 'package:rice_milling_mobile/presentation/widgets/custom_button/custom_app_button.dart';
import 'package:rice_milling_mobile/generated/l10n.dart' as l;

import 'form_add.dart';

class SourcingMaterialView extends StatelessWidget {
  const SourcingMaterialView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SourcingDataListView();
  }
}

class _SourcingDataListView extends StatefulWidget {
  const _SourcingDataListView();

  @override
  State<_SourcingDataListView> createState() => _SourcingDataListViewState();
}

class _SourcingDataListViewState extends State<_SourcingDataListView> {
  @override
  void initState() {
    super.initState();
    iniFetch();
  }

  iniFetch() async {
    await StoreSourcingMaterial.instance.data.initFetch();
    setState(() {});
  }

  refresh() async {
    StoreSourcingMaterial.instance.data.datas = null;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    await StoreSourcingMaterial.instance.data.refresh();
    setState(() {});
  }

  fetchNextPage() async {
    await StoreSourcingMaterial.instance.data.fetchNextPage();
    setState(() {});
  }

  void _showFormDialog(BuildContext context, MSourcingMaterial? data) async {
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
      bodyWidget: StoreSourcingMaterial.instance.data.datas == null
          ? const Center(child: CircularProgressIndicator())
          : StoreSourcingMaterial.instance.data.datas!.isEmpty
              ? const SizedBox(
                  height: 500,
                  child: Center(
                    child: Text('No data'),
                  ),
                )
              : sourcingDataTable(context),
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

  Theme sourcingDataTable(BuildContext context) {
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
          DataColumn(label: Text('Sourcing Id')),
          DataColumn(label: Text('Sourcing Date')),
          DataColumn(label: Text('Farmer Name')),
          DataColumn(label: Text('Total Land Holding')),
          DataColumn(label: Text('Vehicle Id')),
          DataColumn(label: Text('Vehicle Capacity')),
          DataColumn(label: Text('Source Location')),
          DataColumn(label: Text('Destination Location')),
          DataColumn(label: Text('Paddy Variety')),
          DataColumn(label: Text('Quantity Sourced')),
          DataColumn(label: Text('Lot Id')),
          DataColumn(label: Text('Comments')),
          DataColumn(label: Text('Actions')),
        ],
        rows: StoreSourcingMaterial.instance.data.datas!.map(
          (data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              selected: false,
              cells: [
                DataCell(Text(data.sourcingId.toString())),
                DataCell(Text(DateFormat(AppDateConfig.appNumberOnlyDateTimeFormat)
                      .format(DateTime.fromMillisecondsSinceEpoch(
                          data.sourcingDate as int))),),
                DataCell(Text(data.farmerId.toString())),
                DataCell(Text(data.totalLandHolding.toString())),
                DataCell(Text(data.vehicleId.toString())),
                DataCell(Text(data.vehicleCapacity.toString())),
                DataCell(Text(data.sourceLocation.toString())),
                DataCell(Text(data.destinationLocation.toString())),
                DataCell(Text(data.cropVariety.toString())),
                DataCell(Text(data.qtySourced.toString())),
                DataCell(Text(data.lotId.toString())),
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
