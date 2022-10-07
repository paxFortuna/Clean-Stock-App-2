import 'package:http/http.dart' as http;
class StockApi {
  static const baseUrl = 'https://www.alphavantage.co';
  static const apiKey = 'F1R68TCH0OSLYQ6T';

  final http.Client _client;

  StockApi({http.Client? client}) : _client = (client ?? http.Client());
  // csv 파일 호출
  Future<http.Response> getListings({String apiKey = apiKey}) async {
    return await _client.get(
      Uri.parse('$baseUrl/query?function=LISTING_STATUS&apiKey=$apiKey')
    );
  }

}