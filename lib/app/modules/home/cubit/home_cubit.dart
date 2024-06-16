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
        (right) => emit(HomeState.ready(right)),
      );
    } else {
      final InputFormModel? inputFormModel =
          await GetStorageService.readInputFormData();
      if (inputFormModel != null) {
        emit(HomeState.ready(inputFormModel));
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
        final res =
            await InputFormRepo.postThisData(userInputValues, inputFormModel);
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
