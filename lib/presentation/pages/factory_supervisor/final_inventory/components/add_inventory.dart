// import 'package:rice_milling_mobile/application/admin/app_product.dart';
// import 'package:rice_milling_mobile/application/stage/app_final_inventory.dart';
// import 'package:rice_milling_mobile/domain/core/theme/_app_colors.dart';
// import 'package:rice_milling_mobile/presentation/pages/admin/business_location/models/business_location_model.dart';
// import 'package:rice_milling_mobile/presentation/pages/admin/business_location/models/storage_model.dart';
// import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/final_inventory/models/inventory_model.dart';
// import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/packaging/models/packaging_model.dart';
// import 'package:rice_milling_mobile/presentation/pages/factory_supervisor/packaging/models/store_model.dart';
// import 'package:rice_milling_mobile/presentation/widgets/input_field/input_select.dart';
// import 'package:rice_milling_mobile/presentation/widgets/input_field/input_text.dart';
// import 'package:flutter/material.dart';
// import 'package:responsive_framework/responsive_framework.dart' as rf;
// import 'package:rice_milling_mobile/generated/l10n.dart' as l;

// class AddInventoryDialog extends StatefulWidget {
//   const AddInventoryDialog({super.key, this.data});
//   final MInventoryStage? data;

//   @override
//   State<AddInventoryDialog> createState() => _AddBusinessSettingState();
// }

// class _AddBusinessSettingState extends State<AddInventoryDialog> {
//   late MInventoryStage termData;

//   String? batchIndex;
//   List<MPackagingStage> batchs = [];

//   String? warehouseIndex;
//   List<MBusinessLocation> warehouses = [];

//   final _ctrlInputStock = TextEditingController();
//   final _ctrlCurrentStock = TextEditingController();

//   final _ctrlComment = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     initData();
//   }

//   @override
//   void dispose() {
//     _ctrlComment.dispose();
//     _ctrlInputStock.dispose();
//     super.dispose();
//   }

//   initData() async {
//     await fetchingData();
//     if (widget.data == null) {
//       termData = MInventoryStage.fromJson({});
//     } else {
//       termData = MInventoryStage.copy(widget.data!);
//       batchIndex = batchs
//           .indexWhere(
//               (e) => e.batchId.toString() == termData.batchId.toString())
//           .toString();
//       warehouseIndex = warehouses
//           .indexWhere((e) => e.id.toString() == termData.warehouseId.toString())
//           .toString();
//       _ctrlInputStock.text = termData.existingStock.toString();
//       _ctrlCurrentStock.text = termData.currentStock.toString();
//       _ctrlComment.text = termData.comments;
//     }
//     setState(() {});
//   }

//   saveData() async {
//     FocusManager.instance.primaryFocus?.unfocus();
//     final batch = batchs[int.parse(batchIndex ?? '0')];
//     termData.batchId = batch.batchId;
//     termData.finishedProductId = batch.productId.toInt();
//     termData.warehouseId = warehouses[int.parse(warehouseIndex ?? '0')].id;

//     termData.existingStock = double.parse(_ctrlInputStock.text);
//     termData.currentStock = double.parse(_ctrlCurrentStock.text);
//     termData.comments = _ctrlComment.text;
//     print(termData.toMapUpdate());

//     if (widget.data == null) {
//       final res = await AppInventory.insert(termData.toMapCreate());
//       if (!res) return;
//     } else {
//       final res = await AppInventory.update(
//           termData.toMapUpdate(), termData.id.toString());
//       if (!res) return;
//     }
//     Navigator.pop(context, true);
//   }

//   fetchingData() async {
//     await Future.wait([
//       fetchMixing(),
//       fetchWarehouse(),
//     ]);
//   }

//   Future fetchMixing() async {
//     await StorePackaging.instance.data.initFetch();
//     batchs = StorePackaging.instance.data.datas ?? [];
//   }

//   Future fetchWarehouse() async {
//     await StoreBusinessLocation.instance.data.initFetch();
//     warehouses = StoreBusinessLocation.instance.data.datas ?? [];
//   }

//   Future fetchProductInfor() async {
//     var batch = batchs[int.parse(batchIndex ?? '0')];
//     _ctrlInputStock.text = batch.totalPackage.toString();
//     final product = await AppProduct.fetchById(batch.productId.toInt());
//     if (product == null) {
//       _ctrlCurrentStock.text = '0';
//     } else {
//       _ctrlCurrentStock.text = product.totalStockQty.toString();
//     }
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     final lang = l.S.of(context);
//     final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
//       context,
//       conditionalValues: [
//         const rf.Condition.between(
//           start: 0,
//           end: 480,
//           value: _SizeInfo(
//             alertFontSize: 12,
//             padding: EdgeInsets.all(16),
//             innerSpacing: 16,
//           ),
//         ),
//         const rf.Condition.between(
//           start: 481,
//           end: 576,
//           value: _SizeInfo(
//             alertFontSize: 14,
//             padding: EdgeInsets.all(16),
//             innerSpacing: 16,
//           ),
//         ),
//         const rf.Condition.between(
//           start: 577,
//           end: 992,
//           value: _SizeInfo(
//             alertFontSize: 14,
//             padding: EdgeInsets.all(16),
//             innerSpacing: 16,
//           ),
//         ),
//       ],
//       defaultValue: const _SizeInfo(),
//     ).value;
//     TextTheme textTheme = Theme.of(context).textTheme;
//     final theme = Theme.of(context);
//     return GestureDetector(
//       onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//       child: AlertDialog(
//         contentPadding: EdgeInsets.zero,
//         alignment: Alignment.center,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16.0),
//         ),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ///---------------- header section
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(l.S.current.stage_inventory_for_finished_products),
//                     IconButton(
//                       onPressed: () => Navigator.pop(context, false),
//                       icon: const Icon(
//                         Icons.close,
//                         color: AcnooAppColors.kError,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Divider(
//                 thickness: 0.1,
//                 color: theme.colorScheme.outline,
//                 height: 0,
//               ),

//               ///---------------- header section
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: SizedBox(
//                   width: 606,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       InputSelect(
//                         label: l.S.current.stage_batch,
//                         hintText: l.S.current.action_select,
//                         isDisable: widget.data != null,
//                         items: batchs.map((e) => e.batchId.toString()).toList(),
//                         index: batchIndex,
//                         onChange: (value) {
//                           batchIndex = value;
//                           fetchProductInfor();
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       InputSelect(
//                         label: l.S.current.stage_warehouse,
//                         hintText: l.S.current.action_select,
//                         items: warehouses.map((e) => e.locationCode).toList(),
//                         index: warehouseIndex,
//                         onChange: (value) {
//                           warehouseIndex = value;
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       InputText(
//                           label:
//                               l.S.current.stage_quantity_of_finished_products,
//                           keyboardType: TextInputType.number,
//                           isDisable: true,
//                           controller: _ctrlInputStock),
//                       const SizedBox(height: 20),
//                       InputText(
//                           label: l.S.current.stage_current_stock,
//                           isDisable: true,
//                           keyboardType: TextInputType.number,
//                           controller: _ctrlCurrentStock),
//                       const SizedBox(height: 20),
//                       InputText(
//                           label: l.S.current.stage_comments,
//                           maxlines: 3,
//                           controller: _ctrlComment),
//                       const SizedBox(height: 24),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: _sizeInfo.innerSpacing),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             OutlinedButton.icon(
//                               style: ElevatedButton.styleFrom(
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: _sizeInfo.innerSpacing),
//                                   backgroundColor:
//                                       theme.colorScheme.primaryContainer,
//                                   textStyle: textTheme.bodySmall
//                                       ?.copyWith(color: AcnooAppColors.kError),
//                                   side: const BorderSide(
//                                       color: AcnooAppColors.kError)),
//                               onPressed: () => Navigator.pop(context, false),
//                               label: Text(
//                                 lang.cancel,
//                                 style: textTheme.bodySmall
//                                     ?.copyWith(color: AcnooAppColors.kError),
//                               ),
//                             ),
//                             SizedBox(width: _sizeInfo.innerSpacing),
//                             ElevatedButton.icon(
//                               style: ElevatedButton.styleFrom(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: _sizeInfo.innerSpacing),
//                               ),
//                               onPressed: () => saveData(),
//                               label: Text(lang.save),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _SizeInfo {
//   final double? alertFontSize;
//   final EdgeInsetsGeometry padding;
//   final double innerSpacing;
//   const _SizeInfo({
//     this.alertFontSize = 18,
//     this.padding = const EdgeInsets.all(24),
//     this.innerSpacing = 24,
//   });
// }
