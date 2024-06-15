import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../services/get_storage_service.dart';
import '../../../services/internet_connection_service.dart';
import '../../../utils/current_function_name.dart';
import '../data/model/input_form_model.dart';
import '../data/repository/input_form_repo.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState.initial()) {
    _initialize();
  }

  Future<void> getData() async {}

  Future<void> _initialize() async {
    log(
      'HomeCubit initialized: getting input fom data...',
      name: getCurrentFunctionName(),
    );
    if (await InternetConnectionService.isConnected()) {
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
        emit(const HomeState.error('No internet connection'));
      }
    }
  }
}
