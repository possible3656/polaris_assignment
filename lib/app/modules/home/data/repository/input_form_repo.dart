import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:aws_s3_api/s3-2006-03-01.dart';
import 'package:either_dart/either.dart';

import '../../../../routes/api_routes.dart';
import '../../../../services/get_storage_service.dart';
import '../../../../utils/current_function_name.dart';
import '../../../../utils/dio_utils.dart';
import '../../../../utils/env.dart';
import '../../cubit/home_cubit.dart';
import '../model/input_form_model/input_form_model.dart';
import '../model/push_response_model/push_response_model.dart';

abstract class InputFormRepo {
  /// Retrieves the input form data from the server.
  ///
  /// This method makes an HTTP GET request to the [ApiRoutes.inputFormUrl] endpoint
  /// to fetch the input form data. It then converts the response data into an instance
  /// of [InputFormModel] using the [InputFormModel.fromJson] method. The converted
  /// data is then stored using the [GetStorageService.writeInputFormData] method.
  ///
  /// If the request is successful, the method returns a [Right] instance containing
  /// the [InputFormModel]. If an error occurs, the method returns a [Left] instance
  /// containing the error message.
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

  /// Pushes form data to the server.
  ///
  /// Takes a [userInputValue] map containing the user input values and sends it to the server.
  /// Returns a [PushResponseModel] if the request is successful, otherwise returns an error message.
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

  /// Posts the user input data to the server.
  ///
  /// Takes in [userInputValues] - a map of user input values,
  /// and [inputFormModel] - an instance of the InputFormModel class.
  ///
  /// Returns a [Future] that resolves to either a [String] error message
  /// or a [PushResponseModel] object, wrapped in an [Either] type.
  static Future<Either<String, PushResponseModel>?> postThisData(
    Map<String, dynamic> userInputValues,
  ) async {
    final updatedMapWithUrls = await uploadImagesToS3AndGetUrl(
      userInputValues,
      HomeCubit.inputFormModel!,
    );

    if (updatedMapWithUrls != null) {
      final res = await InputFormRepo.pushFormData(updatedMapWithUrls);
      return res;
    }
    return null;
  }

  /// Uploads images to S3 and returns the updated user input values with the image URLs.
  ///
  /// The [userInputValues] parameter is a map containing the user input values.
  /// The [inputFormModel] parameter is an instance of the InputFormModel class.
  /// Returns a Future that completes with a map containing the updated user input values with the image URLs.
  /// Returns null if there was an error uploading the images.
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

      final List? imageUrlList = await uploadImageToS3(paths);
      if (imageUrlList != null) {
        userInputValues[label] = imageUrlList;
      } else {
        return null;
      }
    }
    return userInputValues;
  }

  /// Uploads an image to S3 and returns the URL of the uploaded image.
  ///
  /// The [paths] parameter is a list of file paths of the images to be uploaded.
  /// Returns a Future that completes with a list of URLs of the uploaded images.
  /// Returns null if there was an error uploading the images.
  static Future<List<String>?> uploadImageToS3(List paths) async {
    final List<String> urls = [];
    final service = S3(
      region: Env.BUCKET_REGION,
      credentials: AwsClientCredentials(
        accessKey: Env.AWS_ACCESS_KEY,
        secretKey: Env.AWS_SECRET_KEY,
      ),
    );
    for (var i = 0; i < paths.length; i++) {
      try {
        final String uploadDir =
            'tasks/sambhav/${DateTime.now().microsecondsSinceEpoch}.jpeg';
        final String imageUrl =
            '${Env.BUCKET_NAME}.s3.${Env.BUCKET_REGION}.amazonaws.com/$uploadDir';

        final Uint8List imageData = await File(paths[i]).readAsBytes();

        await service
            .putObject(
          bucket: Env.BUCKET_NAME,
          key: uploadDir,
          body: imageData,
        )
            .then((value) {
          log(
            'uploadImageToS3 success: $imageUrl',
            name: getCurrentFunctionName(),
          );
        }).catchError((e) {
          log(
            'uploadImageToS3: error: $e',
            name: getCurrentFunctionName(),
          );
        });

        urls.add(imageUrl);
      } catch (e) {
        log('uploadImageToS3 error : $e', name: getCurrentFunctionName());
        return null;
      }
    }
    return urls;
  }
}
