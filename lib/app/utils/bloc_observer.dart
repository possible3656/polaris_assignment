import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'current_function_name.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    log('${bloc.runtimeType} Created', name: getCurrentFunctionName());
    super.onCreate(bloc);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    log(
      'an event Happened in $bloc the event is ${event.runtimeType}',
      name: getCurrentFunctionName(),
    );
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    log(
      'There was a transition from ${transition.currentState.runtimeType} to ${transition.nextState.runtimeType}',
      name: getCurrentFunctionName(),
    );
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log(
      'Error happened in ${bloc.runtimeType} with error ${error.runtimeType} and the stacktrace is $stackTrace',
      name: getCurrentFunctionName(),
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    log('${bloc.runtimeType} is closed', name: getCurrentFunctionName());
    super.onClose(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    log(
      'Change on ${bloc.runtimeType} from ${change.currentState.runtimeType} to ${change.nextState.runtimeType}',
      name: getCurrentFunctionName(),
    );
    super.onChange(bloc, change);
  }
}
