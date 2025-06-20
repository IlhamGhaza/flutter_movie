import 'package:dio/dio.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';

class CertificatePinner {
  // Public key hashes for api.themoviedb.org
  // These are SHA-256 fingerprints of the public keys (not the certificate)
  // You can get these using: openssl s_client -connect api.themoviedb.org:443 -showcerts < /dev/null | openssl x509 -pubkey -noout | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64
  static const List<String> pinnedHashes = [
    // Current public key hash for api.themoviedb.org
    'sha256/uyPYgclc5Jt69vKgkhqr+43PsiQDvQ3FvkQjXG0NWSI=',
    // Backup/Intermediate certificate hash
    'sha256/++MBgDH5WGvL9Bcn5Be30cRcL0f5O+NyoXuWtQdX1aI=',
  ];

  static const String apiDomain = 'api.themoviedb.org';

  /// Creates a Dio client with certificate pinning enabled
  static Dio createDioClient() {
    final dio = Dio();
    
    // Add certificate pinning interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          // Verify certificate pinning before making the request
          await verifyPinning();
          return handler.next(options);
        } catch (e) {
          return handler.reject(DioException(
            requestOptions: options,
            error: 'Certificate pinning verification failed',
            type: DioExceptionType.unknown,
          ));
        }
      },
    ));

    return dio;
  }

  /// Verifies the server's certificate against the pinned public key hashes
  static Future<bool> verifyPinning() async {
    try {
      final check = await HttpCertificatePinning.check(
        serverURL: 'https://$apiDomain',
        headerHttp: const <String, String>{},
        sha: SHA.SHA256,
        allowedSHAFingerprints: pinnedHashes,
        timeout: 30, // 30 seconds timeout
      );
      
      final isSecure = check.contains('CONNECTION_SECURE');
      if (isSecure) {
        print('✅ Certificate pinning successful for $apiDomain');
      } else {
        print('❌ Certificate pinning failed: $check');
      }
      return isSecure;
    } catch (e) {
      print('❌ Certificate pinning error: $e');
      rethrow;
    }
  }
}

/// Exception thrown when certificate pinning fails
class CertificatePinningException implements Exception {
  final String message;
  CertificatePinningException(this.message);
  
  @override
  String toString() => 'CertificatePinningException: $message';
}
