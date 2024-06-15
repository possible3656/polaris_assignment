import 'package:flutter/material.dart';

import '../extensions/theme_extensions.dart';

class DefaultLabel extends StatelessWidget {
  const DefaultLabel({super.key, required this.label, required this.mandatory});
  final String label;
  final bool mandatory;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 8),
      child: RichText(
        text: TextSpan(
          text: label,
          style: theme.textTheme.bodyMedium,
          children: mandatory
              ? [
                  TextSpan(
                    text: ' *',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.redColor),
                  ),
                ]
              : [],
        ),
      ),
    );
  }
}
