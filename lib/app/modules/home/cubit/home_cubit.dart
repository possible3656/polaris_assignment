import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../services/get_storage_service.dart';
import '../../../services/internet_connection_service.dart';
import '../../../utils/context_utils.dart';
import '../../../utils/current_function_name.dart';
import '../data/model/input_form_model/input_form_model.dart';
import '../data/repository/input_form_repo.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState.initial()) {
    _initialize();
  }

  Map<String, dynamic> userInputValues = {};
  static late InputFormModel? inputFormModel;

  /// Initializes the [HomeCubit] by fetching input data and setting the initial state.
  ///
  /// This method checks for internet connectivity and performs the following steps:
  /// 1. If there is an internet connection, it checks for any previous data that needs to be uploaded.
  /// 2. It then fetches the input form data from the repository.
  /// 3. If the fetch is successful, it emits the [HomeState.ready] state with the fetched data.
  /// 4. If there is an error during the fetch, it emits the [HomeState.error] state with the error message.
  /// 5. If there is no internet connection, it tries to read the input form data from the local storage.
  /// 6. If the data is found in the local storage, it emits the [HomeState.ready] state with the stored data.
  /// 7. If there is no data in the local storage, it emits the [HomeState.error] state with a specific error message.
  ///
  /// Note: This method is asynchronous and returns a [Future] that completes when the initialization is done.
  Future<void> _initialize() async {
    log(
      'HomeCubit initialized: getting input fom data...',
      name: getCurrentFunctionName(),
    );
    if (await InternetConnectionService.isConnected()) {
      GetStorageService.checkAndUploadPreviousData();

      final res = await InputFormRepo.getInputFormData();
      res.fold(
        (left) => emit(HomeState.error(left)),
        (right) {
          inputFormModel = right;
          emit(HomeState.ready(inputFormModel!));
        },
      );
    } else {
      inputFormModel = await GetStorageService.readInputFormData();
      if (inputFormModel != null) {
        emit(HomeState.ready(inputFormModel!));
      } else {
        emit(const HomeState.error('No internet connection\nno cache found!'));
      }
    }
  }

  void onTextFieldChanged({required String value, required Field field}) {
    log('onTextFieldChanged: $value', name: getCurrentFunctionName());
    userInputValues[field.metaInfo!.label!] = value;
  }

  bool returnCheckBoxValue(String option, Field field) {
    final List<String>? options = userInputValues[field.metaInfo!.label!];
    if (options == null) {
      return false;
    } else {
      return options.contains(option);
    }
  }

  void editCheckBoxValue(List<String> option, Field field) {
    log('editCheckBoxValue: $option', name: getCurrentFunctionName());
    userInputValues[field.metaInfo!.label!] = option;
  }

  void onDropDownChanged({String? value, required Field field}) {
    log('onDropDownChanged: $value', name: getCurrentFunctionName());
    userInputValues[field.metaInfo!.label!] = value;
  }

  void onRadioChanged({required String value, required Field field}) {
    log('onRadioChanged: $value', name: getCurrentFunctionName());
    userInputValues[field.metaInfo!.label!] = value;
  }

  void onImageCaptured({
    required List<String> imagePaths,
    required Field field,
  }) {
    log('onImageCaptured: $imagePaths', name: getCurrentFunctionName());
    userInputValues[field.metaInfo!.label!] = imagePaths;
  }

  /// Handles the submission of the input form.
  ///
  /// This method takes an [InputFormModel] as a parameter and checks if all the mandatory fields are filled.
  /// If any mandatory field is missing, it displays a toast message with the names of the missing fields.
  /// If all the mandatory fields are filled, it uploads the images to AWS S3 and posts the data to the server.
  /// If there is an internet connection, it sends the data to the server and updates the state accordingly.
  /// If there is no internet connection, it adds the form data to the queue and displays a toast message.
  /// Finally, it emits the appropriate state based on the success or failure of the submission.
  ///
  /// Parameters:
  /// - [inputFormModel]: The input form model containing the form fields and metadata.
  ///
  /// Returns: A [Future] that completes when the submission process is finished.
  Future<void> onSubmitPressed({required InputFormModel inputFormModel}) async {
    final List<Field> fields = inputFormModel.fields!;
    final List<String> missingFields = [];
    for (final field in fields) {
      if (field.metaInfo!.mandatory == 'yes' &&
          userInputValues[field.metaInfo!.label!] == null) {
        missingFields.add(field.metaInfo!.label!);
      }
    }
    if (missingFields.isNotEmpty) {
      ContextUtils.showToast(
        'Please fill the following fields:\n${missingFields.join(', ')}',
      );
    } else {
      // upload images to aws s3

      emit(const HomeState.uploadingForm());
      if (await InternetConnectionService.isConnected()) {
        final res = await InputFormRepo.postThisData(userInputValues);
        res?.fold(
          (left) {
            log(
              'onSubmitPressed: error: $left',
              name: getCurrentFunctionName(),
            );
            emit(HomeState.error(left));
          },
          (right) {
            log(
              'onSubmitPressed: success: $right',
              name: getCurrentFunctionName(),
            );
            ContextUtils.showToast('Form submitted successfully');
            emit(HomeState.ready(inputFormModel));
          },
        );
      } else {
        log(
          'onSubmitPressed: no internet connection',
          name: getCurrentFunctionName(),
        );
        ContextUtils.showToast('Form added to queue. Will be uploaded later.');
        GetStorageService.queueInputData(userInputValues);
        emit(HomeState.ready(inputFormModel));
      }
    }
  }
}
