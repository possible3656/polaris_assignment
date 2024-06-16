import 'dart:developer';
import 'dart:io';

import 'package:aws_s3_upload_lite/aws_s3_upload_lite.dart';
import 'package:either_dart/either.dart';

import '../../../../routes/api_routes.dart';
import '../../../../services/get_storage_service.dart';
import '../../../../utils/current_function_name.dart';
import '../../../../utils/dio_utils.dart';
import '../../../../utils/env.dart';
import '../model/input_form_model/input_form_model.dart';
import '../model/push_response_model/push_response_model.dart';

abstract class InputFormRepo {
  static Future<Either<String, InputFormModel>> getInputFormData() async {
    try {
      DioUtils.close();
      final res = await DioUtils.sharedInstance.get(ApiRoutes.inputFormUrl);
      log(
        'InputFormRepo: getInputFormData: $res',
        name: getCurrentFunctionName(),
      );
      final inputFormModel = InputFormModel.fromJson(res.data);
      GetStorageService.writeInputFormData(inputFormModel);
      return Right(inputFormModel);
    } catch (e) {
      log(e.toString(), name: getCurrentFunctionName());
      return Left(e.toString());
    }
  }

  static Future<Either<String, PushResponseModel>> pushFormData(
    Map<String, dynamic> userInputValue,
  ) async {
    try {
      DioUtils.close();

      final res = await DioUtils.sharedInstance.post(
        ApiRoutes.pushFormDataUrl,
        data: {'data': userInputValue},
      );
      log(
        'InputFormRepo: pushFormData: $res',
        name: getCurrentFunctionName(),
      );
      return Right(PushResponseModel.fromJson(res.data));
    } catch (e) {
      log(e.toString(), name: getCurrentFunctionName());
      return Left(e.toString());
    }
  }

  static Future<Either<String, PushResponseModel>?> postThisData(
    Map<String, dynamic> userInputValues,
    InputFormModel inputFormModel,
  ) async {
    final updatedMapWithUrls =
        await uploadImagesToS3AndGetUrl(userInputValues, inputFormModel);
    if (updatedMapWithUrls != null) {
      final res = await InputFormRepo.pushFormData(updatedMapWithUrls);
      return res;
    }
    return null;
  }

  static Future<Map<String, dynamic>?> uploadImagesToS3AndGetUrl(
    Map<String, dynamic> userInputValues,
    InputFormModel inputFormModel,
  ) async {
    final List fieldWithImageType = inputFormModel.fields!
        .where((element) => element.componentType == 'CaptureImages')
        .toList();

    for (final field in fieldWithImageType) {
      final label = field.metaInfo!.label!;
      final List paths = userInputValues[label];
      log(
        'uploadImagesToS3AndGetUrl: $paths on $label',
        name: getCurrentFunctionName(),
      );
      final List? imageUrlList = await uploadImageToS3(paths);
    }
    return userInputValues;
  }

  static Future<List<String>?> uploadImageToS3(List paths) async {
    final List<String> urls = [];
    for (var i = 0; i < paths.length; i++) {
      try {
        final value = await AwsS3.uploadFile(
          accessKey: Env.awsAccessKey,
          secretKey: Env.awsSecretKey,
          file: File(paths[i]),
          bucket: 'plrs-assignments-sambhav',
          region: 'ap-south-1',
          destDir: '/tasks/sambhav/',
          filename: '${DateTime.now().millisecondsSinceEpoch.toString()}.png',
        );
        log('uploadImageToS3 on value: $value', name: getCurrentFunctionName());
        urls.add(value);
      } catch (e) {
        log('uploadImageToS3 error : $e', name: getCurrentFunctionName());
        return null;
      }
    }
    return urls;
  }
}
