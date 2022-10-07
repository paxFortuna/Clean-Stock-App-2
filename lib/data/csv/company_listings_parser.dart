// 인터페이스 구현 기능 전에 csv 플러그인 설치
import 'package:clean_stock_app_2/data/csv/csv_parser.dart';
import 'package:clean_stock_app_2/domain/model/company_listings.dart';
import 'package:csv/csv.dart';

// 인터페이스 기능 구현 후 impl의 csv parsing 처리
class CompanyListingsParser implements CsvParser<CompanyListings> {

  @override
  Future<List<CompanyListings>> parse(String csvString) async {
    // 전체 csv 데이트 모음
    List<List<dynamic>> csvValues =
   const CsvToListConverter().convert(csvString);

    csvValues.removeAt(0); // 컬럼명 row(0) 제거

    return csvValues.map((e) {
      // e가 dynamic이라 null값이 들어올 수 있으니, 널 체크해준다.
      final symbol = e[0] ?? '';  // null인 경우 '' 처리
      final name = e[1] ?? '';
      final exchange = e[2] ?? '';
      return CompanyListings(
        symbol: symbol,
        name: name,
        exchange: exchange,
      );
    }).where((e) =>
    e.symbol.isNotEmpty && e.name.isNotEmpty && e.exchange.isNotEmpty)
        .toList();
  }
}
