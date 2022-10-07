// repository 만들기 전 Result 클래스를 통해 에러 체크한다

import '../../util/result.dart';
import '../model/company_info.dart';
import '../model/company_listings.dart';
import '../model/intraday_info.dart';

abstract class StockRepository {
  // 모든 정보를 가지고 오는 기능
  Future<Result<List<CompanyListings>>> getCompanyListings(
    bool fetchFromRemote,
    String query,
  );
  // symbol 쿼리를 통해 회사 정보 가져오기
  Future<Result<CompanyInfo>> getCompanyInfo(String symbol);

  // 하루동안 주식 정보 가져오기
  Future<Result<List<IntradayInfo>>> getIntradayInfo(String symbol);

}
