import 'dart:async';

import 'package:clean_stock_app_2/presentation/company_listings/company_listings_action.dart';
import 'package:clean_stock_app_2/presentation/company_listings/company_listings_state.dart';
import 'package:flutter/material.dart';

import '../../domain/repository/stock_repository.dart';

class CompanyListingsViewModel with ChangeNotifier {
  // useCase 사용할 때는 repository는 useCase에서 호출한다
  final StockRepository _repository;

  // _state 상태 변수는 계속 변해야 하기에 final은 안됨
  var _state = const CompanyListingsState();
  // 외부에서 getter 확인하기 위해 타입 지정해줘야 한다
  CompanyListingsState get state => _state;

  // debounce는 사용후 지워져야 하기에 널러벌 해야 함
  Timer? _debounce;

  CompanyListingsViewModel(this._repository) {
    _getCompanyListings();
  }

  void onAction(CompanyListingsAction action) {
    // when: sealedclass action 기능 버그 방지
    action.when(refresh: () => _getCompanyListings(fetchFromRemote: true),
        onSearchQueryChange: (query) {
          // TextField가 널이면 디바운스 실행 안함
          _debounce?.cancel();
          _debounce = Timer(const Duration(milliseconds: 500), (){
            _getCompanyListings(query: query);
          });
        }
    );
  }

  // ui에서 veiwModel이 호출되면 아래 메서드를 호출하여 데이터 읽어옴.
  Future _getCompanyListings({
    bool fetchFromRemote = false,
    String query = '',
  }) async {
    //로딩이 먼저 시작되어야 함. state불변객체는 copyWith로 교체
    _state = state.copyWith(
      isLoading: true,
    );
    notifyListeners();

    final result = await _repository.getCompanyListings(fetchFromRemote, query);
    // when: sealedcalss Result freezed가 강제성 부여하여 버그 방지
    result.when(
      success: (listings) {
        _state = state.copyWith(
          companies: listings,
        );
      },
      error: (e) {
        Exception('리모트 에러!! : $e');
        // print('리모트 에러: $e');
      },
    );

    _state = state.copyWith(
      isLoading: false,
    );
    notifyListeners();
  }
}