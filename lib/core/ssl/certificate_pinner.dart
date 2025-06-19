import 'dart:convert';
import 'dart:io';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';

class CertificatePinner {
  static Future<SecurityContext> get securityContext async {
    // Replace with your actual certificate hashes
    final hashes = <String>[
      'BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB',
      'CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC',
    ];

    final securityContext = SecurityContext();
    
    // Add your certificate authority (CA) certificate
    // securityContext.setTrustedCertificates('path/to/certificate.pem');
    
    // Enable certificate pinning
    securityContext.allowLegacyUnsafeRenegotiation = false;
    securityContext.setTrustedCertificatesBytes(
      asn1encode(utf8.encode('your-domain.com')),
    );
    
    return securityContext;
  }

  static Future<void> checkPinning() async {
    // Example domain to check
    const domain = 'api.themoviedb.org';
    
    try {
      final check = await HttpCertificatePinning.check(
        serverURL: domain,
        headerHttp: <String, String>{},
        sha: SHA.SHA256,
        allowedSHAFingerprints: [
          'BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB:BB',
          'CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC:CC',
        ],
        timeout: 60,
      );
      
      if (check.contains('CONNECTION_SECURE')) {
        print('Certificate pinning successful');
      } else {
        print('Certificate pinning failed: $check');
        throw Exception('Certificate pinning failed');
      }
    } catch (e) {
      print('Certificate pinning error: $e');
      rethrow;
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
