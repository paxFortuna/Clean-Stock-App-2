
import 'package:hive/hive.dart';

part 'company_listings_entity.g.dart';

// pub.dev/hiev 우측 documents에서 설명 확인
// hive_generator 설치 후 g.dart는 직접 입력 후 main에서 registerAdater() 등록

@HiveType(typeId: 0)
class CompanyListingsEntity extends HiveObject {
  @HiveField(0)
  String symbol;

  @HiveField(1)
  String name;

  @HiveField(2)
  String exchange;

  CompanyListingsEntity({
    required this.symbol,
    required this.name,
    required this.exchange,
  });
}
