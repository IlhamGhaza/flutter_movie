import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../ssl/certificate_pinner.dart';

class ApiClient {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = '2174d146bb9c0eab47529b2e77d6b526';
  
  late final Dio _dio;
  
  ApiClient() {
    // Create a Dio client with certificate pinning
    _dio = CertificatePinner.createDioClient();
    
    // Configure base options
    _dio.options = BaseOptions(
      baseUrl: _baseUrl,
      queryParameters: {
        'api_key': _apiKey,
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('🌐 ${options.method} ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('✅ ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          debugPrint('❌ ${error.response?.statusCode ?? 'No Status'} ${error.requestOptions.method} ${error.requestOptions.path}');
          debugPrint('Error: ${error.message}');
          
          if (error.response != null) {
            debugPrint('Response data: ${error.response?.data}');
          }
          
          return handler.next(error);
        },
      ),
    );
  }
  
  // GET request
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParams,
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        throw ApiException(
          message: e.response?.data?['status_message'] ?? 'An error occurred',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw ApiException(message: e.message ?? 'Network error');
      }
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }
  
  // Add other HTTP methods (POST, PUT, DELETE, etc.) as needed
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  
  ApiException({required this.message, this.statusCode});
  
  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
