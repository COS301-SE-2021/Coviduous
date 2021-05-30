class HttpException implements Exception
{
  final String message;

  HttpException(this.message);

  // TODO: implement toString
  @override
  String toString() {
    return message;
  }
}
