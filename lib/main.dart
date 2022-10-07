import 'package:clean_stock_app_2/data/repository/stock_repository_impl.dart';
import 'package:clean_stock_app_2/data/source/local/company_listings_entity.dart';
import 'package:clean_stock_app_2/data/source/local/stock_dao.dart';
import 'package:clean_stock_app_2/data/source/remote/stock_api.dart';
import 'package:clean_stock_app_2/domain/repository/stock_repository.dart';
import 'package:clean_stock_app_2/presentation/company_listings/company_listings_view_model.dart';
import 'package:clean_stock_app_2/util/color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'presentation/company_listings/company_listings_screen.dart';

void main() async {
  await Hive.initFlutter();
  // hive_generator build_runner 실행 이후 설정
  Hive.registerAdapter(CompanyListingsEntityAdapter());

  final repository = StockRepositoryImpl(
    StockApi(),
    StockDao(),
  );

  // GetIt으로 서비스 로케이터 생성하여 관리하면, repository를 여기저기서 사용할 수 있다.
  GetIt.instance.registerSingleton<StockRepository>(repository);

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => CompanyListingsViewModel(
          repository,
          // StockRepositoryImpl(
          //   StockApi(),
          //   StockDao(),
          // ),
        ),
      ),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
      ),
      themeMode: ThemeMode.system,
      home: const CompanyListingsScreen(),
    );
  }
}
