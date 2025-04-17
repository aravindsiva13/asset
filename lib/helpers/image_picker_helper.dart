import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// <!-- Image Picker Helper --!> ///
class ImagePickerHelper {
  static final ImagePickerHelper _singleton = ImagePickerHelper._internal();

  factory ImagePickerHelper() {
    return _singleton;
  }

  ImagePickerHelper._internal();
  late String result;

  static final picker = ImagePicker();

  /// Pick Image from the devices
  static Future pickImageFromGallery(int quality) async {
    XFile? image;

    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: quality != 0 ? quality : 100);

    if (pickedFile != null) {
      image = XFile(pickedFile.path);
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
    }

    return image;
  }
}
/// <!-- Image Picker Helper --!> ///
