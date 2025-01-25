import 'package:rice_milling_mobile/infrastructure/locals/shared_manager.dart';
import 'package:intl/intl.dart';

bool isNumber(String text) {
  return RegExp('^[0-9]+\$').hasMatch(text);
}

String capitalize(String text) {
  return toBeginningOfSentenceCase(text) ?? text;
}

Map<String, String> get commonHeader => {
      "Accept": "*/*",
      "Content-Type": "application/json",
      //"App-Language": app_language.$!,
    };

Map<String, String> get authHeader => {
      "Authorization":
          "Bearer ${SharedPreferencesProvider.instance.accessToken}"
    };

// Map<String, String> get currencyHeader =>
//     SystemConfig.systemCurrency?.code == null
//         ? {}
//         : {
//             "Currency-Code": SystemConfig.systemCurrency!.code!,
//             "Currency-Exchange-Rate":
//                 SystemConfig.systemCurrency!.exchangeRate.toString(),
//           };

// String convertPrice(String amount) {
//   return amount.replaceAll(
//       SystemConfig.systemCurrency!.code!, SystemConfig.systemCurrency!.symbol!);
// }
