
import '../../domain/model/intraday_info.dart';
import '../source/remote/dto/intraday_info_dto.dart';
import 'package:intl/intl.dart';

// intraday_info_dto To intraday_info
extension ToIntradayInfo on IntradayInfoDto {
  IntradayInfo toIntradayInfo() {
    // 2022-09-26  5:50:00
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return IntradayInfo(
      // intraday_info_dto의 timestamp를 DateTime date로 변환
      date: formatter.parse(timestamp),
      close: close,
    );
  }
}
