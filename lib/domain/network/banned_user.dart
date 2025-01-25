import 'dart:convert';
import 'package:rice_milling_mobile/domain/network/middleware.dart';
import 'package:http/http.dart' as http;

class BannedUser extends Middleware {
  @override
  bool next(http.Response response) {
    var jsonData = jsonDecode(response.body);
    if (jsonData.runtimeType != List &&
        jsonData.containsKey("result") &&
        !jsonData['result']) {
      if (jsonData.containsKey("status") && jsonData['status'] == "banned") {
        // AuthHelper.clearUserData();
        // Navigator.pushAndRemoveUntil(
        //     OneContext().context!,
        //     MaterialPageRoute(builder: (context) => MainScreen()),
        //     (route) => false);
        return false;
      }
    }
    return true;
  }
}
