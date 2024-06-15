import 'package:flutter/material.dart';

import '../../modules/home/data/model/input_form_model.dart';
import 'default_label.dart';

class MagicImageCapture extends StatelessWidget {
  const MagicImageCapture({super.key, required this.field});
  final Field field;

  @override
  Widget build(BuildContext context) {
    final String label = field.metaInfo?.label ?? 'Capture Images';
    final bool mandatory = field.metaInfo?.mandatory == 'yes';
    final int noOfImagesToCapture = field.metaInfo?.noOfImagesToCapture ?? 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultLabel(label: label, mandatory: mandatory),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: noOfImagesToCapture,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
