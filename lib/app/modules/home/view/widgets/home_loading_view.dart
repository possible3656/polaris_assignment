import 'package:flutter/material.dart';

import '../../../../generated/assets.gen.dart';
import '../../../../utils/context_utils.dart';

class HomeLoadingView extends StatelessWidget {
  const HomeLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Assets.images.loading.keyName,
            width: ContextUtils.size.width * .7,
          ),
          const SizedBox(height: 16),
          Text(
            'Getting data...',
            style: ContextUtils.theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
