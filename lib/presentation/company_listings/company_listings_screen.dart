import 'package:clean_stock_app_2/presentation/company_listings/company_listings_action.dart';
import 'package:clean_stock_app_2/presentation/company_listings/company_listings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../domain/repository/stock_repository.dart';
import '../company_info/company_info_screen.dart';
import '../company_info/company_info_view_model.dart';

class CompanyListingsScreen extends StatelessWidget {
  const CompanyListingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // main에서 ChangeNotifierProvider 설정
    final viewModel = context.watch<CompanyListingsViewModel>();
    final state = viewModel.state;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (query) {
                  viewModel.onAction(
                      CompanyListingsAction.onSearchQueryChange(query));
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.0,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.0,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  ),
                  labelText: '검색...',
                  labelStyle:
                  TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  viewModel.onAction(const CompanyListingsAction.refresh());
                },
                child: ListView.builder(
                  itemCount: state.companies.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(state.companies[index].name),
                          // 화면전환할 때 main의 providers에 주입할 수 없기에 뷰모델을 직접 주입한다.
                          // get_it 서비스 로케이터를 사용하는 것이 효율적이다
                          // main에서도 get_it 상태 로케이터 설정하여 DI 주입
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                // provider 대신 get_it으로 싱글턴 레퍼지토리 의존성 주입하여 사용
                                // context.read<StockRepository>();
                                final repository = GetIt.instance<StockRepository>();
                                final symbol = state.companies[index].symbol;
                                return ChangeNotifierProvider(
                                  create: (_) =>
                                      CompanyInfoViewModel(repository, symbol),
                                  child: const CompanyInfoScreen(),
                                );
                              },),
                            );
                          },
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ],
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
