import 'dart:io';
import 'package:rice_milling_mobile/domain/helpers/main_helpers.dart';
import 'package:rice_milling_mobile/domain/network/bio_api_response.dart';
import 'package:rice_milling_mobile/domain/network/group_middleware.dart';
import 'package:rice_milling_mobile/domain/network/interceptor_logger.dart';
import 'package:rice_milling_mobile/domain/network/middleware.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ApiRequest {
  static Future<http.Response> get({
    required String url,
    Map<String, String>? headers,
    Map<String, String>? queryParam,
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    Uri uri = Uri.parse(url);
    Map<String, String> headerMap = {
      ...commonHeader,
      ...authHeader,
      ...headers ?? {}
    };
    final response = await http.get(uri, headers: headerMap);
    LoggerInterceptor(response);
    return BioApiResponse.check(response,
        middleware: middleware, groupMiddleWare: groupMiddleWare);
  }

  static Future<http.Response> post({
    required String url,
    String body = '',
    Map<String, String>? headers,
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    Uri uri = Uri.parse(url);
    Map<String, String> headerMap = {
      ...commonHeader,
      ...authHeader,
      ...headers ?? {}
    };
    final response = await http.post(uri, headers: headerMap, body: body);
    LoggerInterceptor(response);
    return BioApiResponse.check(response,
        middleware: middleware, groupMiddleWare: groupMiddleWare);
  }

  static Future<http.Response> delete({
    required String url,
    Map<String, String>? headers,
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    Uri uri = Uri.parse(url);
    Map<String, String> headerMap = {
      ...commonHeader,
      ...authHeader,
      ...headers ?? {}
    };
    final response = await http.delete(uri, headers: headerMap);
    LoggerInterceptor(response);
    return BioApiResponse.check(response,
        middleware: middleware, groupMiddleWare: groupMiddleWare);
  }

  static Future<String?> postFormData({
    required String url,
    Map<String, String>? headers,
    required Map<String, String> body,
    List<File>? files,
    List<String>? keyFiles,
    String keyFile = 'photo[]',
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    Map<String, String> headerMap = {
      ...commonHeader,
      ...authHeader,
      ...headers ?? {}
    };
    Uri uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri)
      ..fields.addAll(body)
      ..headers.addAll(headerMap);
    if (files != null) {
      files.asMap().entries.forEach((e) async {
        if (keyFiles == null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              keyFile,
              e.value.path,
              contentType: MediaType.parse(lookupMimeType(e.value.path) ?? ''),
            ),
          );
        } else {
          request.files.add(
            await http.MultipartFile.fromPath(
              keyFiles[e.key],
              e.value.path,
              contentType: MediaType.parse(lookupMimeType(e.value.path) ?? ''),
            ),
          );
        }
      });
    }
    try {
      final response = await request.send();
      print(response.statusCode);
      final res = await response.stream.bytesToString();
      return res;
    } catch (err) {
      return null;
    }
  }

  static Future<String?> postSingleFile({
    required String url,
    required Map<String, String> body,
    required File? fileData,
    required String keyFile,
    Map<String, String>? headers,
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    Map<String, String> headerMap = {
      ...commonHeader,
      ...authHeader,
      ...headers ?? {}
    };
    Uri uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri)
      ..fields.addAll(body)
      ..headers.addAll(headerMap);
    if (fileData != null) {
      request.files.addAll([
        await http.MultipartFile.fromPath(
          keyFile,
          fileData.path,
          contentType: MediaType.parse(lookupMimeType(fileData.path) ?? ''),
        ),
      ]);
    }

    try {
      final response = await request.send();
      final res = await response.stream.bytesToString();
      return res;
    } catch (err) {
      return null;
    }
  }
}
