import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import '../ssl/certificate_pinner.dart';


class ApiClient {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = '2174d146bb9c0eab47529b2e77d6b526';
  
  late final Dio _dio;
  
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
          // Add any request headers or tokens here
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Handle errors globally
          return handler.next(error);
        },
      ),
    );
  }
  
  void _setupCertificatePinning() async {
    // Configure certificate pinning
    final securityContext = await CertificatePinner.securityContext;
    
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
      final httpClient = HttpClient(context: securityContext);
      httpClient.badCertificateCallback = (cert, host, port) {
        // Implement additional certificate validation if needed
        return false; // Reject invalid certificates
      };
      return httpClient;
    };
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
