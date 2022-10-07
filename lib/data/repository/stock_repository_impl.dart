import 'package:clean_stock_app_2/data/csv/company_listings_parser.dart';
import 'package:clean_stock_app_2/data/mapper/company_mapper.dart';
import 'package:clean_stock_app_2/data/source/local/stock_dao.dart';
import 'package:clean_stock_app_2/data/source/remote/stock_api.dart';
import 'package:clean_stock_app_2/domain/model/company_info.dart';
import 'package:clean_stock_app_2/domain/model/company_listings.dart';
import 'package:clean_stock_app_2/domain/model/intraday_info.dart';

import 'package:clean_stock_app_2/util/result.dart';

import '../../domain/repository/stock_repository.dart';
import '../csv/intraday_info_parser.dart';

class StockRepositoryImpl implements StockRepository {
  final StockApi _api;
  final StockDao _dao;
  final _companyListingsParser = CompanyListingsParser();
  final _intradayInfoParser = IntradayInfoParser();

  StockRepositoryImpl(this._api, this._dao);

  @override
  Future<Result<List<CompanyListings>>> getCompanyListings(
    bool fetchFromRemote,
    String query,
  ) async {
    // _dao캐시에서 먼저 찾는다. 있다면 Entity에서 가져오고,
    final localListings = await _dao.searchCompanyListings(query);

    //  없다면 리모트에서 가져온다.
    final isDbEmpty = localListings.isEmpty && query.isEmpty;
    final shouldJustLoadFromCache = !isDbEmpty && !fetchFromRemote;

    // 캐시에 있다면
    if (shouldJustLoadFromCache) {
      return Result.success(
          localListings.map((e) => e.toCompanyListing()).toList());
    }
    // 리모트에 있다면
    // Future<http.Response> getListings({String apiKey = apiKey}) 수정
    try {
      final response = await _api.getListings();
      // csv parsing => remoteListings에 저장
      final remoteListings = await _companyListingsParser.parse(response.body);

      // 캐시 있을 수 있으니 _dao cahche 먼저 비운 후 캐싱
      await _dao.clearCompanyListings();

      // 캐싱 추가 -- entity로 변환해서 hive db에 저장
      await _dao.insertCompanyListings(
          remoteListings.map((e) => e.toCompanyListingEntity()).toList());

      return Result.success(remoteListings);

      // csv 파생 변환전에는 []
      // return Result.success([]);

    } catch (e) {
      return Result.error(Exception('데이터 로드 실패'));
    }
  }

  @override
  Future<Result<CompanyInfo>> getCompanyInfo(String symbol) async {
    try {
      final dto = await _api.getCompanyInfo(symbol: symbol);
      // dto와 CompanyInfo 변환은 Mapper에 추가해야 함
      return Result.success(dto.toCompanyInfo());
    } catch (e) {
      // return Result.error(Exception('회사 정보 로드 실패!! : ${e.toString()}'));
      return Result.error(Exception('회사 정보 로드 실패!! : $e'));
    }
  }

  // intraday_info 가져오기 위해 _parser 만들어야 한다
  @override
  Future<Result<List<IntradayInfo>>> getIntradayInfo(String symbol) async{
    try{
      final response = await _api.getIntradayInfo(symbol: symbol);
      final results = await _intradayInfoParser.parse(response.body);
      return Result.success(results);

    }catch(e){
      return Result.error(Exception('intraday 정보 로드 실패!!! : $e'));
    }
  }
}

