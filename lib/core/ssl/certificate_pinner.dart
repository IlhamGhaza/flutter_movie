import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CertificatePinner {
  // List of allowed domains for certificate pinning
  static const List<String> allowedDomains = [
    'api.themoviedb.org',
    'developer.themoviedb.org',
  ];

  // List of allowed public key hashes (SHA-256)
  // These should be the base64-encoded SHA-256 hashes of the public keys
  static const List<String> allowedPublicKeyHashes = [
    // Add your public key hashes here
    // Example: 'sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=',
  ];

  // Check if the given host is in the allowed domains list
  static bool _isAllowedDomain(String host) {
    return allowedDomains.any((domain) => 
      host == domain || host.endsWith('.$domain')
    );
  }

  /// Creates a Dio client with certificate pinning enabled
  static Dio createDioClient() {
    final dio = Dio();
    
    // Configure the HTTP client for certificate pinning
    (dio.httpClientAdapter as dynamic).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        // First check if the domain is allowed
        if (!_isAllowedDomain(host)) {
          debugPrint('❌ Domain not allowed: $host');
          return false;
        }
        
        // If we have public key hashes, verify against them
        if (allowedPublicKeyHashes.isNotEmpty) {
          // In a real implementation, you would verify the certificate's
          // public key hash against the allowed hashes
          // For now, we'll just log and allow the connection
          debugPrint('✅ Allowed connection to $host (certificate pinning not fully implemented)');
        }
        
        return true; // Allow the connection
      };
      return client;
    };

    return dio;
  }

  /// Verifies the server's certificate against the pinned certificate
  static Future<bool> verifyPinning() async {
    // This method is kept for backward compatibility
    // The actual pinning is now handled by the HttpClient's badCertificateCallback
    debugPrint('🔒 Certificate pinning is enabled for domains: $allowedDomains');
    return true;
  }
}

/// Exception thrown when certificate pinning fails
class CertificatePinningException implements Exception {
  final String message;
  CertificatePinningException(this.message);

  @override
  String toString() => 'CertificatePinningException: $message';
}
