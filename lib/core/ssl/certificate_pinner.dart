import 'dart:convert';
import 'dart:io';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';

class CertificatePinner {
  // Public key hashes for api.themoviedb.org
  // These should be updated if the server's certificate changes
  static const List<String> pinnedHashes = [
    // Primary certificate
    'BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB',
    // Backup/Intermediate certificate (if available)
    'CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC',
  ];

  static const String apiDomain = 'api.themoviedb.org';
  static const Duration timeout = Duration(seconds: 10);

  static Future<SecurityContext> get securityContext async {
    final securityContext = SecurityContext();
    
    // Enable strict certificate validation
    securityContext.allowLegacyUnsafeRenegotiation = false;
    securityContext.setTrustedCertificatesBytes(
      asn1encode(utf8.encode(apiDomain)),
    );
    
    return securityContext;
  }

  /// Verifies the server's certificate against the pinned public key hashes
  static Future<bool> verifyPinning() async {
    try {
      final check = await HttpCertificatePinning.check(
        serverURL: apiDomain,
        headerHttp: const <String, String>{},
        sha: SHA.SHA256,
        allowedSHAFingerprints: pinnedHashes,
        timeout: timeout.inSeconds,
      );
      
      final isSecure = check.contains('CONNECTION_SECURE');
      if (isSecure) {
        print(' Certificate pinning successful for $apiDomain');
      } else {
        print(' Certificate pinning failed: $check');
      }
      return isSecure;
    } catch (e) {
      print(' Certificate pinning error: $e');
      rethrow;
    }
  }

  /// Checks certificate pinning and throws an exception if it fails
  static Future<void> checkPinning() async {
    final isSecure = await verifyPinning();
    if (!isSecure) {
      throw CertificatePinningException('Certificate pinning verification failed');
    }
  }
  
  // Helper method to encode data in ASN.1 format
  static List<int> asn1encode(List<int> data) {
    final result = <int>[];
    if (data.length <= 127) {
      result.add(data.length);
    } else {
      final lenBytes = <int>[];
      var len = data.length;
      while (len > 0) {
        lenBytes.add(len & 0xff);
        len >>= 8;
      }
      result.add(0x80 | lenBytes.length);
      result.addAll(lenBytes.reversed);
    }
    result.addAll(data);
    return result;
  }
}

/// Exception thrown when certificate pinning fails
class CertificatePinningException implements Exception {
  final String message;
  CertificatePinningException(this.message);
  
  @override
  String toString() => 'CertificatePinningException: $message';
}
