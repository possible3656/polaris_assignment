import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/home/cubit/home_cubit.dart';

import '../../modules/home/data/model/input_form_model/input_form_model.dart';
import '../context_utils.dart';
import '../extensions/theme_extensions.dart';
import 'default_label.dart';

class MagicTextField extends StatelessWidget {
  const MagicTextField({super.key, required this.field});
  final Field field;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ContextUtils.theme;
    final String label = field.metaInfo?.label ?? 'Text Field';
    final String hint = 'Enter $label';
    final bool mandatory = field.metaInfo?.mandatory == 'yes';
    final TextInputType inputType =
        field.metaInfo?.componentInputType == 'INTEGER'
            ? TextInputType.number
            : TextInputType.text;
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
          child: TextField(
            cursorColor: theme.white,
            style: theme.textTheme.bodyMedium,
            onChanged: (value) => context
                .read<HomeCubit>()
                .onTextFieldChanged(value: value, field: field),
            keyboardType: inputType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: theme.textTheme.bodyMedium!.copyWith(
                color: theme.secondaryTextColor,
                fontWeight: FontWeight.w300,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }
}
