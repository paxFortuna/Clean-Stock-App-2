import 'dart:convert';

import 'package:clean_stock_app_2/data/source/remote/dto/company_info_dto.dart';
import 'package:http/http.dart' as http;

class StockApi {
  static const baseUrl = 'https://www.alphavantage.co';
  static const apiKey = 'F1R68TCH0OSLYQ6T';

  final http.Client client;

  // client가 null이면 : client...을 불러 기본 Client불러온다. test 코드작성용
  StockApi({http.Client? client}) : client = (client ?? http.Client());

  // csv 파일 호출
  Future<http.Response> getListings({String apiKey = apiKey}) async {
    return await client.get(
        Uri.parse('$baseUrl/query?function=LISTING_STATUS&apikey=$apiKey'));
  }

// https://apikey : lowercase

  Future<CompanyInfoDto> getCompanyInfo({
    required String symbol,
    String apiKey = apiKey,
  }) async {
    final response = await client.get(Uri.parse(
        '$baseUrl/query?function=OVERVIEW&symbol=$symbol&apikey=$apiKey'));
    return CompanyInfoDto.fromJson(jsonDecode(response.body));
  }
  Future<http.Response> getIntradayInfo({
    required String symbol,
    String apiKey = apiKey,
  }) async {
    return await client.get(Uri.parse(
        '$baseUrl/query?function=TIME_SERIES_INTRADAY&'
            'symbol=$symbol&interval=60min&apikey=$apiKey&datatype=csv'));
  }
}
