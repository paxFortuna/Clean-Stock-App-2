// repository 만들기 전 Result 클래스를 통해 에러 체크한다

import '../../util/result.dart';
import '../model/company_listings.dart';

abstract class StockRepository {
  // 모든 정보를 가지고 오는 기능
  Future<Result<List<CompanyListings>>> getCompanyListings(
    bool fetchFromRemote,
    String query,
  );

  //Future<Result<CompanyInfo>> getCompanyInfo(String symbol);

  //Future<Result<List<IntradayInfo>>> getIntradayInfo(String symbol);

}
