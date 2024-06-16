// To parse this JSON data, do
//
//     final pushResponseModel = pushResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_response_model.freezed.dart';
part 'push_response_model.g.dart';

PushResponseModel pushResponseModelFromJson(String str) =>
    PushResponseModel.fromJson(json.decode(str));

String pushResponseModelToJson(PushResponseModel data) =>
    json.encode(data.toJson());

@freezed
class PushResponseModel with _$PushResponseModel {
  const factory PushResponseModel({
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'data') PushResponseModelData? data,
  }) = _PushResponseModel;

  factory PushResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PushResponseModelFromJson(json);
}

@freezed
class PushResponseModelData with _$PushResponseModelData {
  const factory PushResponseModelData({
    @JsonKey(name: 'data') DataData? data,
  }) = _PushResponseModelData;

  factory PushResponseModelData.fromJson(Map<String, dynamic> json) =>
      _$PushResponseModelDataFromJson(json);
}

@freezed
class DataData with _$DataData {
  const factory DataData({
    @JsonKey(name: 'Phase Type') String? phaseType,
    @JsonKey(name: 'Consumer Mobile Number') String? consumerMobileNumber,
    @JsonKey(name: 'Consumer Status') List<String>? consumerStatus,
    @JsonKey(name: 'Meter Status') String? meterStatus,
    @JsonKey(name: 'Survey Images') List<String>? surveyImages,
    @JsonKey(name: 'Meter Validation Status') String? meterValidationStatus,
    @JsonKey(name: 'Consumer Images') List<String>? consumerImages,
  }) = _DataData;

  factory DataData.fromJson(Map<String, dynamic> json) =>
      _$DataDataFromJson(json);
}
