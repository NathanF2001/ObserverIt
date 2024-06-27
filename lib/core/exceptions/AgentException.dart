class AgentException implements Exception {
  final String message;

  const AgentException(this.message);

  @override
  String toString() => message;
}