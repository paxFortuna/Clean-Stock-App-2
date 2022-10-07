import 'package:clean_stock_app_2/domain/model/company_listings.dart';

import '../../domain/model/company_info.dart';
import '../source/local/company_listings_entity.dart';
import '../source/remote/dto/company_info_dto.dart';

// company_listing_eintity To company_listings
// 매퍼를 통해 가변객체인 캐시 entity와 불변객체인 listings를 전환하는 확장함수

extension ToComapnyListings on CompanyListingsEntity {
  // ComapnyListings객체로 변환
  CompanyListings toCompanyListing() {
    return CompanyListings(
      symbol: symbol,
      name: name,
      exchange: exchange,
    );
  }
}

// 실재 데이터에서는 listings는 널러블?인데, entity는 required인 경우도 있음
extension ToComapnyListingEntity on CompanyListings {
  // ComapnyListings객체로 변환
  CompanyListingsEntity toCompanyListingEntity() {
    return CompanyListingsEntity(
      symbol: symbol,
      name: name,
      exchange: exchange,
    );
  }
}

// CompanyInfoDto To CompanyInfo
extension ToCompanyInfo on CompanyInfoDto {
  CompanyInfo toCompanyInfo() {
    return CompanyInfo(
      symbol: symbol ?? '',
      description: description ?? '',
      name: name ?? '',
      country: country ?? '',
      industry: industry ?? '',
    );
  }
}
