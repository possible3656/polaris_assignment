// To parse this JSON data, do
//
//     final inputFormModel = inputFormModelFromJson(jsonString);

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'input_form_model.freezed.dart';
part 'input_form_model.g.dart';

InputFormModel inputFormModelFromJson(String str) =>
    InputFormModel.fromJson(json.decode(str));

String inputFormModelToJson(InputFormModel data) => json.encode(data.toJson());

@freezed
class InputFormModel with _$InputFormModel {
  const factory InputFormModel({
    @JsonKey(name: 'form_name') String? formName,
    @JsonKey(name: 'fields') List<Field>? fields,
  }) = _InputFormModel;

  factory InputFormModel.fromJson(Map<String, dynamic> json) =>
      _$InputFormModelFromJson(json);
}

@freezed
class Field with _$Field {
  const factory Field({
    @JsonKey(name: 'meta_info') MetaInfo? metaInfo,
    @JsonKey(name: 'component_type') String? componentType,
  }) = _Field;

  factory Field.fromJson(Map<String, dynamic> json) => _$FieldFromJson(json);
}

@freezed
class MetaInfo with _$MetaInfo {
  const factory MetaInfo({
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'component_input_type') String? componentInputType,
    @JsonKey(name: 'mandatory') String? mandatory,
    @JsonKey(name: 'options') List<String>? options,
    @JsonKey(name: 'no_of_images_to_capture') int? noOfImagesToCapture,
    @JsonKey(name: 'saving_folder') String? savingFolder,
  }) = _MetaInfo;

  factory MetaInfo.fromJson(Map<String, dynamic> json) =>
      _$MetaInfoFromJson(json);
}
