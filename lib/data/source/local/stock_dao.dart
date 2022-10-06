import 'package:clean_stock_app_2/data/source/local/company_lisings_entity.dart';
import 'package:hive/hive.dart';

// local db(cache)에 crud 기능

class StockDao {
  // 키값은 상수로 정의해서 사용하면 휴먼 에러 방지
  static const companyListings = 'companyListings';

  final box = Hive.box('stock.db');

  // 추가
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
