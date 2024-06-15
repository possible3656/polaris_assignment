import 'package:flutter/material.dart';

import '../../modules/home/data/model/input_form_model.dart';
import 'default_label.dart';

class MagicRadioGroup extends StatelessWidget {
  const MagicRadioGroup({super.key, required this.field});
  final Field field;

  @override
  Widget build(BuildContext context) {
    final String label = field.metaInfo?.label ?? 'Radio Group';
    final List<String> options = field.metaInfo?.options ?? [];
    final bool mandatory = field.metaInfo?.mandatory == 'yes';

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
                        groupValue: options.first,
                        onChanged: (String? value) {},
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
