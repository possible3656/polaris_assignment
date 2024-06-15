import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/assets.gen.dart';
import '../../../utils/context_utils.dart';
import '../../../utils/extensions/theme_extensions.dart';
import '../cubit/home_cubit.dart';
import 'widgets/home_loading_view.dart';

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
            orElse: () => HomeLoadingView(),
            initial: () =>
                Center(child: Image.asset(Assets.images.loading.keyName)),
          );
        },
      ),
    );
  }
}
