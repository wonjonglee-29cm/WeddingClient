import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClipboardUtils {
  static void copy(BuildContext context, {
    required String text,
    required String snackBarMessage,
    Duration duration = const Duration(seconds: 3),
  }) {
    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(snackBarMessage),
        duration: duration,
      ),
    );
  }
}