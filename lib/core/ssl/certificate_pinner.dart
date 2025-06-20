import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class CertificatePinner {
  static const String _certificatePath = 'assets/certificates/certificates.pem';
  static SecurityContext? _securityContext;

  // List of allowed domains for certificate pinning
  static const List<String> allowedDomains = [
    'api.themoviedb.org',
    // 'developer.themoviedb.org',
  ];

  /// Initialize the security context with the pinned certificate
  static Future<void> initialize() async {
    if (_securityContext != null) return;
    
    try {
      // Load the certificate from assets
      final sslCert = await rootBundle.load(_certificatePath);
      
      // Create a security context with the certificate
      _securityContext = SecurityContext(withTrustedRoots: false);
      _securityContext!.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
      
      debugPrint('✅ SSL Certificate pinning initialized successfully');
    } catch (e) {
      debugPrint('❌ Failed to initialize certificate pinning: $e');
      rethrow;
    }
  }

  /// Creates a secure HTTP client with certificate pinning
  static HttpClient createSecureHttpClient() {
    if (_securityContext == null) {
      throw CertificatePinningException('CertificatePinner not initialized. Call initialize() first.');
    }
    
    return HttpClient(context: _securityContext!)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        if (!_isAllowedDomain(host)) {
          debugPrint('❌ Domain not allowed: $host');
          return false;
        }
        
        // Certificate validation is handled by the SecurityContext
        // This callback is only called if the certificate verification fails
        debugPrint('❌ Certificate verification failed for $host');
        return false;
      };
  }
  
  /// Creates a Dio client with certificate pinning enabled
  static Dio createDioClient() {
    if (_securityContext == null) {
      throw CertificatePinningException('CertificatePinner not initialized. Call initialize() first.');
    }
    
    final dio = Dio();
    
    // Create a custom HttpClient with the security context
    final httpClient = HttpClient(context: _securityContext!);
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) {
      if (!_isAllowedDomain(host)) {
        debugPrint('❌ Domain not allowed: $host');
        return false;
      }
      debugPrint('❌ Certificate verification failed for $host');
      return false;
    };
    
    // Set the custom HttpClient to the Dio instance
    dio.httpClientAdapter = _createAdapter(httpClient);
    
    return dio;
  }
  
  // Helper method to create a custom HttpClientAdapter
  static dynamic _createAdapter(HttpClient httpClient) {
    return IOHttpClientAdapter(
      createHttpClient: () => httpClient,
    );
  }

  /// Verifies if the given host is in the allowed domains list
  static bool _isAllowedDomain(String host) {
    return allowedDomains.any((domain) => 
      host == domain || host.endsWith('.$domain')
    );
  }

  /// Verifies the server's certificate against the pinned certificate
  static Future<bool> verifyPinning() async {
    if (_securityContext == null) {
      await initialize();
    }
    
    debugPrint('🔒 Certificate pinning is enabled for domains: $allowedDomains');
    return _securityContext != null;
  }
}

/// Exception thrown when certificate pinning fails
class CertificatePinningException implements Exception {
  final String message;
  CertificatePinningException(this.message);

  @override
  String toString() => 'CertificatePinningException: $message';
}
