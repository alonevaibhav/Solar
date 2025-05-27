// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? errorMessage;
  final int statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.errorMessage,
    required this.statusCode,
  });
}

class ApiService {
  static const String baseUrl = "https://7hmgmjzr-3000.inc1.devtunnels.ms";
  static const Duration _timeoutDuration = Duration(seconds: 30);

  static SharedPreferences? _prefs;

  // ==================== Init SharedPreferences ====================
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }


  /// ==================== JWT Management ====================
  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> setUid(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
  }

  static Future<String?> getUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  // static Future<void> setToken(String token) async {
  //   await _prefs?.setString('token', token);
  // }
  //
  // static String? getToken() => _prefs?.getString('token');
  //
  // static Future<void> setUid(String uid) async {
  //   await _prefs?.setString('uid', uid);
  // }
  //
  // static String? getUid() => _prefs?.getString('uid');

  static Future<void> clearAuthData() async {
    await _prefs?.remove('token');
    await _prefs?.remove('uid');
  }

  // ==================== Header Builder ====================

  static Map<String, String> _getHeaders({bool includeToken = true}) {
    final token = includeToken ? getToken() : null;
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ==================== Base API Methods ====================

  static Future<ApiResponse<T>> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParams,
    required T Function(dynamic) fromJson,
    bool includeToken = true,
  }) async {
    final uri =
        Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
    return _sendRequest<T>(
      method: 'GET',
      uri: uri,
      fromJson: fromJson,
      requestFunc: () =>
          http.get(uri, headers: _getHeaders(includeToken: includeToken)),
    );
  }

  static Future<ApiResponse<T>> post<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    required T Function(dynamic) fromJson,
    bool includeToken = true,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    return _sendRequest<T>(
      method: 'POST',
      uri: uri,
      body: body,
      fromJson: fromJson,
      requestFunc: () => http.post(uri,
          headers: _getHeaders(includeToken: includeToken),
          body: json.encode(body)),
    );
  }

  static Future<ApiResponse<T>> put<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    required T Function(dynamic) fromJson,
    bool includeToken = true,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    return _sendRequest<T>(
      method: 'PUT',
      uri: uri,
      body: body,
      fromJson: fromJson,
      requestFunc: () => http.put(uri,
          headers: _getHeaders(includeToken: includeToken),
          body: json.encode(body)),
    );
  }

  static Future<ApiResponse<T>> delete<T>({
    required String endpoint,
    Map<String, dynamic>? body,
    required T Function(dynamic) fromJson,
    bool includeToken = true,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    return _sendRequest<T>(
      method: 'DELETE',
      uri: uri,
      body: body,
      fromJson: fromJson,
      requestFunc: () => http.delete(
        uri,
        headers: _getHeaders(includeToken: includeToken),
        body: body != null ? json.encode(body) : null,
      ),
    );
  }

  static Future<ApiResponse<T>> multipartPost<T>({
    required String endpoint,
    required Map<String, String> fields,
    required List<MultipartFiles> files,
    required T Function(dynamic) fromJson,
    bool includeToken = true,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');

    _logRequest('MULTIPART POST', uri, body: fields);
    _logFiles(files);

    try {
      final request = http.MultipartRequest('POST', uri);
      final headers = _getHeaders(includeToken: includeToken);
      headers.remove('Content-Type');
      request.headers.addAll(headers);
      request.fields.addAll(fields);

      for (var file in files) {
        request.files.add(await http.MultipartFile.fromPath(
          file.field,
          file.filePath,
          contentType: file.contentType,
        ));
      }

      final streamedResponse = await request.send().timeout(_timeoutDuration);
      final response = await http.Response.fromStream(streamedResponse);
      _logResponse(response);
      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      return _handleError('MULTIPART POST', uri, 'No internet connection');
    } on TimeoutException {
      return _handleError('MULTIPART POST', uri, 'Request timeout');
    } catch (e) {
      return _handleError('MULTIPART POST', uri, e.toString());
    }
  }

  // ==================== Response Handling ====================

  static Future<ApiResponse<T>> _sendRequest<T>({
    required String method,
    required Uri uri,
    required Future<http.Response> Function() requestFunc,
    required T Function(dynamic) fromJson,
    Map<String, dynamic>? body,
  }) async {
    _logRequest(method, uri, body: body);
    try {
      final response = await requestFunc().timeout(_timeoutDuration);
      _logResponse(response);
      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      return _handleError(method, uri, 'No internet connection');
    } on TimeoutException {
      return _handleError(method, uri, 'Request timeout');
    } catch (e) {
      return _handleError(method, uri, e.toString());
    }
  }

  static ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic) fromJson,
  ) {
    final statusCode = response.statusCode;
    final responseBody = response.body;

    try {
      final jsonResponse = json.decode(responseBody);
      if (statusCode >= 200 && statusCode < 300) {
        _logSuccess(statusCode, jsonResponse);
        return ApiResponse<T>(
          success: true,
          data: fromJson(jsonResponse),
          statusCode: statusCode,
        );
      } else {
        final errorMessage = _extractErrorMessage(jsonResponse);
        _logError('RESPONSE', response.request?.url, errorMessage,
            statusCode: statusCode);
        return ApiResponse<T>(
          success: false,
          errorMessage: errorMessage,
          statusCode: statusCode,
        );
      }
    } catch (e) {
      _logError('RESPONSE PARSING', response.request?.url, e.toString());
      return ApiResponse<T>(
        success: false,
        errorMessage: 'Response parse error: ${e.toString()}',
        statusCode: statusCode,
      );
    }
  }

  static ApiResponse<T> _handleError<T>(
    String method,
    Uri uri,
    String message,
  ) {
    _logError(method, uri, message);
    return ApiResponse<T>(
      success: false,
      errorMessage: message,
      statusCode: -1,
    );
  }

  static String _extractErrorMessage(dynamic jsonResponse) {
    if (jsonResponse is Map<String, dynamic>) {
      final possibleFields = [
        'error',
        'message',
        'errorMessage',
        'error_message',
        'detail',
        'details'
      ];

      for (final field in possibleFields) {
        if (jsonResponse.containsKey(field)) {
          final value = jsonResponse[field];
          if (value is String) {
            return value;
          } else if (value is List) {
            return value.join(', ');
          } else if (value is Map) {
            return json.encode(value);
          }
          return value.toString();
        }
      }
      return json.encode(jsonResponse);
    }
    return 'Unknown error occurred';
  }

  static void _logRequest(String method, Uri uri,
      {Map<String, dynamic>? body}) {
    if (kDebugMode) {
      print('┌───────────────────────────────────────────────────');
      print('│ 🚀 API REQUEST: $method ${uri.toString()}');
      if (body != null) {
        print('│ 📦 REQUEST BODY: ${json.encode(body)}');
      }
      print('└───────────────────────────────────────────────────');
    }
  }

  static void _logFiles(List<MultipartFiles> files) {
    if (kDebugMode) {
      print('┌───────────────────────────────────────────────────');
      print('│ 📎 UPLOADING FILES:');
      for (var file in files) {
        print(
            '│   - ${file.field}: ${file.filePath} (${file.contentType.toString()})');
      }
      print('└───────────────────────────────────────────────────');
    }
  }

  static void _logResponse(http.Response response) {
    if (kDebugMode) {
      final statusCode = response.statusCode;
      final statusEmoji = statusCode >= 200 && statusCode < 300 ? '✅' : '❌';

      print('┌───────────────────────────────────────────────────');
      print(
          '│ $statusEmoji API RESPONSE: ${response.request?.method} ${response.request?.url}');
      print('│ 🔢 STATUS CODE: $statusCode');
      try {
        final jsonResponse = json.decode(response.body);
        final prettyJson =
            const JsonEncoder.withIndent('  ').convert(jsonResponse);
        print('│ 📄 RESPONSE BODY:');
        for (var line in prettyJson.split('\n')) {
          print('│   $line');
        }
      } catch (e) {
        print('│ 📄 RESPONSE BODY: ${response.body}');
      }
      print('└───────────────────────────────────────────────────');
    }
  }

  static void _logSuccess(int statusCode, dynamic response) {
    if (kDebugMode) {
      print('┌───────────────────────────────────────────────────');
      print('│ ✅ API CALL SUCCESSFUL: Status $statusCode');
      print('└───────────────────────────────────────────────────');
    }
  }

  static void _logError(String operation, Uri? url, String message,
      {int? statusCode}) {
    if (kDebugMode) {
      print('┌───────────────────────────────────────────────────');
      print('│ ❌ API ERROR: $operation ${url?.toString() ?? ''}');
      if (statusCode != null) {
        print('│ 🔢 STATUS CODE: $statusCode');
      }
      print('│ 🚨 ERROR MESSAGE: $message');
      print('└───────────────────────────────────────────────────');
    }
  }
}

class MultipartFiles {
  final String field;
  final String filePath;
  final MediaType contentType;

  MultipartFiles({
    required this.field,
    required this.filePath,
    MediaType? contentType,
  }) : contentType = contentType ?? _detectContentType(filePath);

  static MediaType _detectContentType(String path) {
    final ext = extension(path).toLowerCase().replaceFirst('.', '');
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'pdf':
        return MediaType('application', 'pdf');
      case 'doc':
        return MediaType('application', 'msword');
      case 'docx':
        return MediaType('application',
            'vnd.openxmlformats-officedocument.wordprocessingml.document');
      case 'xls':
        return MediaType('application', 'vnd.ms-excel');
      case 'xlsx':
        return MediaType('application',
            'vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      default:
        return MediaType('application', 'octet-stream');
    }
  }
}

// Shared preference Example:
// await ApiService.setToken(response.data['token']);
// await ApiService.setUid(response.data['uid']);
// final token = ApiService.getToken();
// final uid = ApiService.getUid();

// Token Passing Example:
// final response = await ApiService.post<User>(
// endpoint: 'public/submit',
// body: {'name': 'John'},
// fromJson: (json) => User.fromJson(json),
// includeToken: false, // 👈 token will NOT be sent
// );

// //it used in simgle dataset come
// fromJson: (json) => User.fromJson(json),
// //it used when arrey come
// fromJson: (jsonList) {return (jsonList as List).map((item) => Product.fromJson(item)).toList();},
