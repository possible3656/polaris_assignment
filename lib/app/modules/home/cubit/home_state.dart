part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.ready(InputFormModel inputFormModel) = _Ready;
  const factory HomeState.error(String message) = _Error;
}
