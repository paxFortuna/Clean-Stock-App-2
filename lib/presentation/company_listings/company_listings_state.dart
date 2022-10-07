import 'package:clean_stock_app_2/domain/model/company_listings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_listings_state.freezed.dart';

part 'company_listings_state.g.dart';

@freezed
class CompanyListingsState with _$CompanyListingsState {
  const factory CompanyListingsState({
    // 리스트 뷰에 보일 company 명
    @Default([]) List<CompanyListings> companies,
    // api로 불러올 때 로딩처리
    @Default(false) bool isLoading,
    // refreshIndicator 상태처리
    @Default(false) bool isRefreshing,
    // 검색 쿼리 상태 처리
    @Default('') String searchQuery,
  }) = _CompanyListingsState;

  factory CompanyListingsState.fromJson(Map<String, Object?> json) => _$CompanyListingsStateFromJson(json);
}