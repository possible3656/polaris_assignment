import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/context_utils.dart';
import '../../../utils/extensions/theme_extensions.dart';
import '../cubit/home_cubit.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: TextButton(
            onPressed: context.read<HomeCubit>().getData,
            child: Text('Get Data', style: ContextUtils.theme.buttonTextStyle),
          ),
        ),
      ),
    );
  }
}
