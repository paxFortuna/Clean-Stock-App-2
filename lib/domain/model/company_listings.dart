import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_listings.freezed.dart';

part 'company_listings.g.dart';

// 화면에 보여줄 때는 불변객체 활용하지만,
// 가변객체인 hive local entity cache와 안전한 연결 위해 dto mapping 필요
@freezed
class CompanyListings with _$CompanyListings {
  const factory CompanyListings({
    required String symbol,
    required String name,
    required String exchange,
  }) = _CompanyListings;

  factory CompanyListings.fromJson(Map<String, Object?> json) => _$CompanyListingsFromJson(json);
}