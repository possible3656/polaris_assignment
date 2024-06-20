import 'dart:developer';

import 'package:get_storage/get_storage.dart';

import '../modules/home/data/model/input_form_model/input_form_model.dart';
import '../modules/home/data/repository/input_form_repo.dart';
import '../utils/context_utils.dart';
import '../utils/current_function_name.dart';

/// A service class that provides methods for interacting with GetStorage.
class GetStorageService {
  static String key = 'input_form_data';
  static String userInputDataKey = 'user_input_data';
  static bool isUploading = false;

  /// Initializes GetStorage.
  Future<void> init() async {
    await GetStorage.init();
  }

  /// Writes the input form data to GetStorage.
  static Future<void> writeInputFormData(InputFormModel value) async {
    final box = GetStorage();
    await box.write(
      key,
      value.toJson(),
    );
  }

  /// Reads the input form data from GetStorage.
  static Future<InputFormModel?> readInputFormData() async {
    final box = GetStorage();
    final data = box.read(key);
    log('Data: $data', name: 'GetStorageService');
    if (data != null) {
      return InputFormModel.fromJson(data);
    }
    return null;
  }

  /// Queues the user input data to be uploaded later.
  static void queueInputData(Map<String, dynamic> userInputValues) {
    final box = GetStorage();
    List? data = box.read(userInputDataKey);
    if (data != null && data.isNotEmpty) {
      data.add(userInputValues);
      box.write(userInputDataKey, data);
    } else {
      box.write(userInputDataKey, [userInputValues]);
    }
  }

  /// Checks and uploads any previously queued data.
  static void checkAndUploadPreviousData() async {
    final box = GetStorage();
    List? data = box.read(userInputDataKey);
    List updatedList = [...data ?? []];
    if (data != null && data.isNotEmpty && !isUploading) {
      log('Data to upload: $data', name: 'GetStorageService');
      for (var item in data) {
        log('Uploading data: $item', name: 'GetStorageService');
        isUploading = true;
        ContextUtils.showToast('Uploading previous data');
        final res = await InputFormRepo.postThisData(item);
        res?.fold(
          (left) {
            log(
              'onSubmitPressed: error: $left',
              name: getCurrentFunctionName(),
            );
          },
          (right) {
            log(
              'onSubmitPressed: success: $right',
              name: getCurrentFunctionName(),
            );
            updatedList.remove(item);
          },
        );
      }
      isUploading = false;
      box.write(userInputDataKey, updatedList);
      ContextUtils.showToast('Previous Data uploaded successfully');
    } else {
      isUploading = false;
      log('No data to upload', name: 'GetStorageService');
    }
    return;
  }
}
