import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_listings.freezed.dart';

part 'company_listings.g.dart';

@freezed
class CompanyListings with _$CompanyListings {
  const factory CompanyListings({
    required String symbol,
    required String name,
    required String exchange,
  }) = _CompanyListings;

  factory CompanyListings.fromJson(Map<String, Object?> json) => _$CompanyListingsFromJson(json);
}