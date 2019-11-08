import 'dart:async';
import 'package:flutter/services.dart';

const String kTypeImage = 'image';
const String kTypeVideo = 'video';

/// Specifies the source where the picked image should come from.
enum ImageSource {
  /// Opens up the device camera, letting the user to take a new picture.
  camera,

  /// Opens the user's photo gallery.
  gallery,
}

class MultiImagePicker {
  static const MethodChannel _channel =
  const MethodChannel('plugins.flutter.io/image_picker');

  static Future pickImageAndVideo() {
    return _channel.invokeMethod('getGallery');
  }


}
