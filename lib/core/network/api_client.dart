import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import '../ssl/certificate_pinner.dart';

class ApiClient {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = '2174d146bb9c0eab47529b2e77d6b526';
  
  late final Dio _dio;
  bool _isPinningVerified = false;
  
  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        queryParameters: {
          'api_key': _apiKey,
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    
    _setupInterceptors();
    _setupCertificatePinning();
  }
  
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (!_isPinningVerified && !kIsWeb) {
            try {
              await CertificatePinner.checkPinning();
              _isPinningVerified = true;
            } catch (e) {
              debugPrint('⚠️ Certificate pinning verification failed: $e');
              return handler.reject(
                DioException(
                  requestOptions: options,
                  error: 'Security error: Certificate verification failed',
                  type: DioExceptionType.unknown,
                ),
              );
            }
          }
          
          // Add any request headers or tokens here
          options.headers['Accept'] = 'application/json';
          options.headers['Content-Type'] = 'application/json';
          
          debugPrint('🌐 ${options.method} ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('✅ ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) async {
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
  
  void _setupCertificatePinning() async {
    if (kIsWeb) {
      debugPrint('⚠️ Certificate pinning is not supported on web platform');
      return;
    }
    
    try {
      // Configure certificate pinning
      final securityContext = await CertificatePinner.securityContext;
      
      (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
        final httpClient = HttpClient(context: securityContext);
        httpClient.badCertificateCallback = (cert, host, port) {
          debugPrint('⚠️ Bad certificate detected for $host:$port');
          debugPrint('Certificate subject: ${cert.subject}');
          debugPrint('Certificate issuer: ${cert.issuer}');
          return false; // Reject invalid certificates
        };
        return httpClient;
      };
      
      // Perform initial pinning check
      await CertificatePinner.checkPinning();
      _isPinningVerified = true;
    } catch (e) {
      debugPrint('❌ Failed to set up certificate pinning: $e');
      rethrow;
    }
  }
  
  // Example GET request
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      // Check certificate pinning before making the request
      await CertificatePinner.checkPinning();
      
      final response = await _dio.get(
        path,
        queryParameters: queryParams,
      );
      return response;
    } on DioException catch (e) {
      // Handle Dio errors
      if (e.response != null) {
        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx
        throw ApiException(
          message: e.response?.data?['status_message'] ?? 'An error occurred',
          statusCode: e.response?.statusCode,
        );
      } else {
        // Something happened in setting up or sending the request
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
