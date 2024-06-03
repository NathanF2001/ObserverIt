class UrlRequesterException implements Exception {
  final String message;

  const UrlRequesterException(this.message);

  @override
  String toString() => message;
}