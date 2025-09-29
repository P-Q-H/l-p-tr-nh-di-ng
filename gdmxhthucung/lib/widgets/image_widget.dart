import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

Widget buildImageWidget(String imagePath) {
  if (imagePath.isEmpty) {
    return const Icon(Icons.image_not_supported);
  }

  if (kIsWeb) {
    return Image.network(
      imagePath,
      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
    );
  } else {
    return Image.file(File(imagePath));
  }
}