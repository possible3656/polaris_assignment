import 'dart:developer';

import 'package:either_dart/either.dart';

import '../../../../routes/api_routes.dart';
import '../../../../utils/current_function_name.dart';
import '../../../../utils/dio_utils.dart';
import '../model/input_form_model.dart';

abstract class InputFormRepo {
  static Future<Either<String, InputFormModel>> getInputFormData() async {
    try {
      DioUtils.close();
      final res = await DioUtils.sharedInstance.get(ApiRoutes.inputFormUrl);
      log(
        'InputFormRepo: getInputFormData: $res',
        name: getCurrentFunctionName(),
      );
      return Right(InputFormModel.fromJson(res.data));
    } catch (e) {
      log(e.toString(), name: getCurrentFunctionName());
      return Left(e.toString());
    }
  }
}
