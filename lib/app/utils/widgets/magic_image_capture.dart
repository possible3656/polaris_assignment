import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../modules/home/cubit/home_cubit.dart';

import '../../modules/home/data/model/input_form_model/input_form_model.dart';
import 'default_label.dart';

class MagicImageCapture extends StatefulWidget {
  const MagicImageCapture({super.key, required this.field});
  final Field field;

  @override
  State<MagicImageCapture> createState() => _MagicImageCaptureState();
}

class _MagicImageCaptureState extends State<MagicImageCapture> {
  List<File?> capturedImages = [];
  List<String> imagePaths = [];

  @override
  Widget build(BuildContext context) {
    final String label = widget.field.metaInfo?.label ?? 'Capture Images';
    final bool mandatory = widget.field.metaInfo?.mandatory == 'yes';
    final int noOfImagesToCapture =
        widget.field.metaInfo?.noOfImagesToCapture ?? 1;

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
              return GestureDetector(
                onTap: () {
                  _captureImage(index);
                },
                child: Padding(
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
                    child: capturedImages.length > index &&
                            capturedImages[index] != null
                        ? Image.file(
                            capturedImages[index]!,
                            fit: BoxFit.cover,
                          )
                        : const Center(
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                            ),
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

  Future<void> _captureImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      // Get the directory for storing images
      final directory = await getApplicationDocumentsDirectory();
      final String savingFolder =
          widget.field.metaInfo?.savingFolder ?? 'PolarisSurvey';
      final String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      final String folderPath = '${directory.path}/$savingFolder';
      final String imagePath = '$folderPath/$imageName.jpg';

      // Ensure the directory exists
      final Directory folder = Directory(folderPath);
      if (!folder.existsSync()) {
        folder.createSync(recursive: true);
      }

      // Save the captured image to the specified path
      final File imageFile = File(pickedFile.path);
      await imageFile.copy(imagePath);

      setState(() {
        if (capturedImages.length > index) {
          capturedImages[index] = File(imagePath);
          imagePaths[index] = imagePath;
        } else {
          capturedImages.add(File(imagePath));
          imagePaths.add(imagePath);
        }
      });
      context
          .read<HomeCubit>()
          .onImageCaptured(imagePaths: imagePaths, field: widget.field);
    }
  }
}
