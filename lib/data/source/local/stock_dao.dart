import 'package:clean_stock_app_2/data/source/local/company_listings_entity.dart';
import 'package:hive/hive.dart';

// entity 하이브 객체를 통해 local db(cache)에 crud dao기능 작성
// 시나리오: remote _api로 csv 파일을 불러오면,
// local entity 통해 dao에 캐시 저장하여 사용

class StockDao {
  // 키값은 상수로 정의해서 사용하면 휴먼 에러 방지
  static const companyListings = 'companyListings';

  // openBox 사용할 때 box 지우지 않으면 버그 발생
  // final box = Hive.box('stock.db');

  // cache 추가
  Future<void> insertCompanyListings(
      List<CompanyListingsEntity> companyListingsEntities) async {
    // await box.put(StockDao.companyListings, companyListingsEntities);
    final box = await Hive.openBox<CompanyListingsEntity>('stock.db');
    await box.addAll(companyListingsEntities);
  }

  // 클리어
  Future clearCompanyListings() async {
    final box = await Hive.openBox<CompanyListingsEntity>('stock.db');
    await box.clear();
  }

  // 검색
  Future<List<CompanyListingsEntity>> searchCompanyListings(
      String query) async {
    // final List<CompanyListingsEntity> companyListings =
    //     box.get(StockDao.companyListings, defaultValue: []);

    final box = await Hive.openBox<CompanyListingsEntity>('stock.db');
    final List<CompanyListingsEntity> companyListings = box.values.toList();

    return companyListings
        .where((e) =>
            e.name.toLowerCase().contains(query.toLowerCase()) ||
            query.toUpperCase() == e.symbol)
        .toList();
  }
}
