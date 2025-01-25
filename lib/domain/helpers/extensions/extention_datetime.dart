import 'package:rice_milling_mobile/domain/core/static/_static_values.dart';
import 'package:intl/intl.dart';

extension StringToDateTime on String {
  DateTime get convertToDate =>
      DateFormat(AppDateConfig.appNumberOnlyDateFormat).parse(this);
  
  DateTime get convertToDateTime =>
      DateFormat(AppDateConfig.appNumberOnlyDateTimeFormat).parse(this);
}

extension DateTimeToInt on DateTime {
  int get convertToInt => millisecondsSinceEpoch;
}

extension DateTimeToString on DateTime {
  String get convertDateToString =>
      DateFormat(AppDateConfig.appNumberOnlyDateFormat).format(this);
  String get convertDateTimeToString =>
      DateFormat(AppDateConfig.appNumberOnlyDateTimeFormat).format(this);
}

extension IntToDateTime on int {
  DateTime get convertToDate => DateTime.fromMillisecondsSinceEpoch(this);
}
