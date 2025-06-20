class ServerException implements Exception {
  final String message;
  
  ServerException([this.message = '']);
  
  @override
  String toString() => 'ServerException${message.isNotEmpty ? ': $message' : ''}';
}

class DatabaseException implements Exception {
  final String message;

  DatabaseException(this.message);
}
