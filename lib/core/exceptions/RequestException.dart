class RequestException implements Exception {
  final String message;

  const RequestException(this.message);

  @override
  String toString() => message;
}