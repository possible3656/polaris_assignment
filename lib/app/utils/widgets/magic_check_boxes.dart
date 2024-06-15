import 'package:flutter/material.dart';

import '../../modules/home/data/model/input_form_model.dart';
import 'default_label.dart';

class MagicCheckBoxes extends StatelessWidget {
  const MagicCheckBoxes({super.key, required this.field});
  final Field field;

  @override
  Widget build(BuildContext context) {
    final String label = field.metaInfo?.label ?? 'Check Boxes';
    final List<String> options = field.metaInfo?.options ?? [];
    final bool mandatory = field.metaInfo?.mandatory == 'yes';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultLabel(label: label, mandatory: mandatory),
        for (var option in options) _buildCheckBox(option),
      ],
    );
  }

  Widget _buildCheckBox(String option) {
    return Row(
      children: [
        SizedBox(
          height: 30,
          width: 30,
          child: Checkbox(value: false, onChanged: (value) {}),
        ),
        Text(option),
      ],
    );
  }
}
