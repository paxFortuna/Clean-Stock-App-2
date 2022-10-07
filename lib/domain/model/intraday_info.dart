import 'package:freezed_annotation/freezed_annotation.dart';

part 'intraday_info.freezed.dart';

part 'intraday_info.g.dart';

// intraday_info_dto에서는 timestamp 형식으로 받는다
@freezed
class IntradayInfo with _$IntradayInfo {
  const factory IntradayInfo({
    required DateTime date,
    required double close,

  }) = _IntradayInfo;

  factory IntradayInfo.fromJson(Map<String, Object?> json) => _$IntradayInfoFromJson(json);
}