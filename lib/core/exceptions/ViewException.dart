class ViewException implements Exception {
  final String message;

  const ViewException(this.message);

  @override
  String toString() => message;
}