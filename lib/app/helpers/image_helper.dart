import 'dart:io';

import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  /// Select a single image from gallery
  static Future<File?> getFromGallery(bool enforceAspectRatio) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      final pickedImage = File(pickedFile.path);
      logger.w('Current filepath: ${pickedFile.path}');
      return pickedImage;
    } else {
      return null;
    }
  }

  static Future<CroppedFile> cropImage(
    File? imageFile,
    bool applyAspectRatio,
  ) async {
    var croppedFile = await ImageCropper().cropImage(
      aspectRatio: applyAspectRatio
          ? const CropAspectRatio(ratioX: 1.0, ratioY: 1.0)
          : null,
      compressFormat: ImageCompressFormat.png,
      sourcePath: imageFile!.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: AppStrings.tidyTechTitle,
          toolbarColor: AppColors.fullBlack,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: AppStrings.tidyTechTitle),
      ],
    );
    return croppedFile ?? CroppedFile(imageFile.path);
  }
}
