import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_info_dto.freezed.dart';

part 'company_info_dto.g.dart';

// 실재 json 데이터를 받을 객체 : 널러블?인 경우 처리

@freezed
class CompanyInfoDto with _$CompanyInfoDto {
  const factory CompanyInfoDto({
    @JsonKey(name: 'Symbol') String? symbol,
    @JsonKey(name: 'Description') String? description,
    @JsonKey(name: 'Name') String? name,
    @JsonKey(name: 'Country') String? country,
    @JsonKey(name: 'Industry') String? industry,

  }) = _CompanyInfoDto;

  factory CompanyInfoDto.fromJson(Map<String, Object?> json) => _$CompanyInfoDtoFromJson(json);
}