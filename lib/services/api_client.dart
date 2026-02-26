import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

class ApiClient {
  late final Dio _dio;
  final Logger _logger = Logger();

  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  ApiClient._internal() {
    final baseUrl =
        dotenv.env['API_BASE_URL'] ?? 'https://api.civicmind.example.com';

    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        _logger.d('REQUEST[${options.method}] => PATH: ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.d('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
        return handler.next(response);
      },
      onError: (error, handler) {
        _logger.e(
            'ERROR[${error.response?.statusCode}] => MESSAGE: ${error.message}');
        return handler.next(error);
      },
    ));
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      _logger.e('GET Error: $e');
      rethrow;
    }
  }

  Future<Response> post(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.post(path,
          data: data, queryParameters: queryParameters);
    } catch (e) {
      _logger.e('POST Error: $e');
      rethrow;
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } catch (e) {
      _logger.e('PUT Error: $e');
      rethrow;
    }
  }

  Future<Response> delete(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.delete(path, queryParameters: queryParameters);
    } catch (e) {
      _logger.e('DELETE Error: $e');
      rethrow;
    }
  }

  Future<Response> upload(String path, FormData formData) async {
    try {
      return await _dio.post(path, data: formData);
    } catch (e) {
      _logger.e('UPLOAD Error: $e');
      rethrow;
    }
  }
}
