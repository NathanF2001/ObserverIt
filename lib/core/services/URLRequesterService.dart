import 'package:http/http.dart' as http;
import 'package:observerit/core/exceptions/UrlRequesterException.dart';
import 'package:observerit/entities/UrlResponse.dart';

class UrlRequesterService {

  Future<UrlResponse> requestUrl(String url) async {
    try {
      final startTime = DateTime.now();
      final response = await http.get(Uri.parse(url));
      final endTime = DateTime.now();

      final executionTime = endTime.difference(startTime).inMilliseconds;

      return UrlResponse.fromJson({
        "timeMS": executionTime,
        "contentType": response.headers["content-type"],
        "statusCode": response.statusCode,
        "runDate": startTime
      });
    } catch (error){
      throw UrlRequesterException("An error occurred while making the request, try later");
    }
  }
}