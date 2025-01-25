import 'package:rice_milling_mobile/domain/network/group_middleware.dart';
import 'package:rice_milling_mobile/domain/network/middleware.dart';
import 'package:http/http.dart' as http;

class ApiRequest {
  static Future<http.Response> get({
    required String url,
    Map<String, String>? headers,
    Map<String, String>? queryParam,
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    throw Exception('Unsupported Platform');
  }

  static Future<http.Response> post({
    required String url,
    String? body,
    Map<String, String>? headers,
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    throw Exception('Unsupported Platform');
  }

  static Future<http.Response> delete({
    required String url,
    String? body,
    Map<String, String>? headers,
    Map<String, String>? queryParam,
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    throw Exception('Unsupported Platform');
  }
}
