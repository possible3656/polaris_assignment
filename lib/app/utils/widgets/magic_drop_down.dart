import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/home/cubit/home_cubit.dart';
import '../../modules/home/data/model/input_form_model/input_form_model.dart';
import '../context_utils.dart';
import '../extensions/theme_extensions.dart';
import 'default_label.dart';

class MagicDropDown extends StatefulWidget {
  const MagicDropDown({super.key, required this.field});
  final Field field;

  @override
  State<MagicDropDown> createState() => _MagicDropDownState();
}

class _MagicDropDownState extends State<MagicDropDown> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ContextUtils.theme;
    final String label = widget.field.metaInfo?.label ?? 'Drop Down';
    final String hint = 'Select $label';
    final List<String> options = widget.field.metaInfo?.options ?? [];
    final bool mandatory = widget.field.metaInfo?.mandatory == 'yes';
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
              value: selectedOption,
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
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
                context
                    .read<HomeCubit>()
                    .onDropDownChanged(value: value, field: widget.field);
              },
            ),
          ),
        ),
      ],
    );
  }
}
