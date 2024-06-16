import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/context_utils.dart';
import '../../../utils/extensions/theme_extensions.dart';
import '../../../utils/widgets/magic_loader.dart';
import '../cubit/home_cubit.dart';
import 'widgets/home_error_view.dart';
import 'widgets/home_loading_view.dart';
import 'widgets/input_form_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ContextUtils.theme.secondaryBackground,
        centerTitle: false,
        title: const Text(
          'Home',
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => const SizedBox.shrink(),
            initial: () => const HomeLoadingView(),
            ready: (inputFormModel) => SingleChildScrollView(
              child: InputFormView(inputFormModel: inputFormModel),
            ),
            uploadingForm: () => Center(
              child: MagicLoader(
                color: ContextUtils.theme.primaryColor,
              ),
            ),
            error: (message) => HomeErrorView(message: message),
          );
        },
      ),
    );
  }
}
