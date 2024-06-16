import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/home/cubit/home_cubit.dart';
import '../../modules/home/data/model/input_form_model/input_form_model.dart';
import 'default_label.dart';

class MagicCheckBoxes extends StatefulWidget {
  const MagicCheckBoxes({super.key, required this.field});
  final Field field;

  @override
  State<MagicCheckBoxes> createState() => _MagicCheckBoxesState();
}

class _MagicCheckBoxesState extends State<MagicCheckBoxes> {
  List<String> selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    final String label = widget.field.metaInfo?.label ?? 'Check Boxes';
    final List<String> options = widget.field.metaInfo?.options ?? [];
    final bool mandatory = widget.field.metaInfo?.mandatory == 'yes';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultLabel(label: label, mandatory: mandatory),
        for (var option in options)
          Row(
            children: [
              SizedBox(
                height: 30,
                width: 30,
                child: Checkbox(
                  value: selectedOptions.contains(option),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        if (selectedOptions.contains(option)) {
                          selectedOptions.remove(option);
                        } else {
                          selectedOptions.add(option);
                        }
                      });
                      context
                          .read<HomeCubit>()
                          .editCheckBoxValue(selectedOptions, widget.field);
                    }
                  },
                ),
              ),
              Text(option),
            ],
          ),
      ],
    );
  }
}
