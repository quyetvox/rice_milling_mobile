import 'package:rice_milling_mobile/domain/models/other/country_model.dart';
import 'package:rice_milling_mobile/domain/models/other/currency_model.dart';
import 'package:rice_milling_mobile/domain/models/other/timezone_model.dart';
import 'package:rice_milling_mobile/presentation/pages/admin/business_setting/models/business_setting_model.dart';

class StoreOther {
  StoreOther._privateConstructor();
  static final StoreOther instance =
      StoreOther._privateConstructor();

  List<MTimeZone>? timezones;
  List<MCurrency>? currencies;
  List<MCountry>? coutries;


  List<MBusinessSetting>? businessSettings;
}

