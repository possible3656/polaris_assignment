import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/home/cubit/home_cubit.dart';

import '../../modules/home/data/model/input_form_model/input_form_model.dart';
import 'default_label.dart';

class MagicRadioGroup extends StatefulWidget {
  const MagicRadioGroup({super.key, required this.field});
  final Field field;

  @override
  State<MagicRadioGroup> createState() => _MagicRadioGroupState();
}

class _MagicRadioGroupState extends State<MagicRadioGroup> {
  late String selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.field.metaInfo?.options?.first ?? '';
    context.read<HomeCubit>().onRadioChanged(
          value: selectedOption,
          field: widget.field,
        );
  }

  @override
  Widget build(BuildContext context) {
    final String label = widget.field.metaInfo?.label ?? 'Radio Group';
    final List<String> options = widget.field.metaInfo?.options ?? [];
    final bool mandatory = widget.field.metaInfo?.mandatory == 'yes';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultLabel(label: label, mandatory: mandatory),
        Column(
          children: options
              .map(
                (String value) => Row(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Radio<String>(
                        value: value,
                        groupValue: selectedOption,
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() {
                              selectedOption = value;
                            });
                            context.read<HomeCubit>().onRadioChanged(
                                  value: value,
                                  field: widget.field,
                                );
                          }
                        },
                      ),
                    ),
                    Text(value),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
