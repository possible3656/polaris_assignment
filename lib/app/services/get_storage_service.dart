import 'package:get_storage/get_storage.dart';

import '../modules/home/data/model/input_form_model.dart';

class GetStorageService {
  static String key = 'input_form_data';
  Future<void> init() async {
    await GetStorage.init();
  }

  static Future<void> writeInputFormData(InputFormModel value) async {
    final box = GetStorage();
    await box.write(key, value.toJson());
  }

  static Future<InputFormModel?> readInputFormData() async {
    final box = GetStorage();
    final data = box.read(key);
    if (data != null) {
      return InputFormModel.fromJson(data);
    }
    return null;
  }
}
