import 'package:clean_stock_app_2/presentation/company_info/company_info_state.dart';
import 'package:flutter/material.dart';

import '../../domain/repository/stock_repository.dart';

class CompanyInfoViewModel with ChangeNotifier {
  final StockRepository _repository;

  // final _state = const CompanyInfoState(); 하면 안됨!!!
  var _state = const CompanyInfoState();

  CompanyInfoState get state => _state;

  CompanyInfoViewModel(this._repository, String symbol) {
    loadCompanyInfo(symbol);
  }

  // 회상정보 데이터 가져오는 기능
  Future<void> loadCompanyInfo(String symbol) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    //실재 데이터 가져오는 기능 when은 freezed 내장함수
    final result = await _repository.getCompanyInfo(symbol);
    result.when(
        success: (info) {
          _state = state.copyWith(
            companyInfo: info,
            isLoading: false,
            errorMessage: null,
          );
        },
        error: (e) {
          _state = state.copyWith(
            companyInfo: null,
            isLoading: false,
            errorMessage: e.toString(),
          );
        });

    // _state = state.copyWith(isLoading: false);
    notifyListeners();

    // final intradayInfo = await _repository.getIntradayInfo(symbol);
    // intradayInfo.when(
    //   success: (infos) {
    //     _state = state.copyWith(
    //       stockInfos: infos,
    //       isLoading: false,
    //       errorMessage: null,
    //     );
    //   },
    //   error: (e) {
    //     _state = state.copyWith(
    //       stockInfos: [],
    //       isLoading: true,
    //       errorMessage: e.toString(),
    //     );
    //   },
    // );
    // notifyListeners();
  }
}