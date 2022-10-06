
import 'package:hive/hive.dart';

part 'company_lisings_entity.g.dart';

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
