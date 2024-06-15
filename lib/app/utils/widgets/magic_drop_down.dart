import 'package:flutter/material.dart';

import '../../modules/home/data/model/input_form_model.dart';
import '../context_utils.dart';
import '../extensions/theme_extensions.dart';
import 'default_label.dart';

class MagicDropDown extends StatelessWidget {
  const MagicDropDown({super.key, required this.field});
  final Field field;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ContextUtils.theme;
    final String label = field.metaInfo?.label ?? 'Drop Down';
    final String hint = 'Select $label';
    final List<String> options = field.metaInfo?.options ?? [];
    final bool mandatory = field.metaInfo?.mandatory == 'yes';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultLabel(label: label, mandatory: mandatory),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.secondaryBackground,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<String>(
              isExpanded: true,
              borderRadius: BorderRadius.circular(8),
              hint: Text(
                hint,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.secondaryTextColor,
                  fontWeight: FontWeight.w300,
                ),
              ),
              dropdownColor: theme.secondaryBackground,
              style: theme.textTheme.bodyMedium,
              items: options
                  .map(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  )
                  .toList(),
              underline: const SizedBox.shrink(),
              onChanged: (String? value) {},
            ),
          ),
        ),
      ],
    );
  }
}
