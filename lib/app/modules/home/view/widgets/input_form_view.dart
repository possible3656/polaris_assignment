import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/context_utils.dart';
import '../../../../utils/extensions/theme_extensions.dart';
import '../../../../utils/widgets/magic_check_boxes.dart';
import '../../../../utils/widgets/magic_drop_down.dart';
import '../../../../utils/widgets/magic_image_capture.dart';
import '../../../../utils/widgets/magic_radio_group.dart';
import '../../../../utils/widgets/magic_text_field.dart';
import '../../cubit/home_cubit.dart';
import '../../data/model/input_form_model/input_form_model.dart';

class InputFormView extends StatelessWidget {
  const InputFormView({
    super.key,
    required this.inputFormModel,
  });
  final InputFormModel inputFormModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var field in inputFormModel.fields!)
            BuildWidgets(
              field: field,
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: TextButton(
              onPressed: () => context
                  .read<HomeCubit>()
                  .onSubmitPressed(inputFormModel: inputFormModel),
              child: Text(
                'Submit',
                style: ContextUtils.theme.buttonTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuildWidgets extends StatelessWidget {
  const BuildWidgets({
    super.key,
    required this.field,
  });
  final Field field;

  @override
  Widget build(BuildContext context) {
    final fieldType = field.componentType ?? '';
    return switch (fieldType) {
      'EditText' => MagicTextField(field: field),
      'CheckBoxes' => MagicCheckBoxes(field: field),
      'DropDown' => MagicDropDown(field: field),
      'RadioGroup' => MagicRadioGroup(field: field),
      'CaptureImages' => MagicImageCapture(field: field),
      _ => const Text('ss'),
    };
  }
}
