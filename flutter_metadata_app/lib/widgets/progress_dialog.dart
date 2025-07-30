import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  final String title;
  final String message;
  final double progress;
  final bool isIndeterminate;

  const ProgressDialog({
    super.key,
    required this.title,
    required this.message,
    this.progress = 0.0,
    this.isIndeterminate = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 16),
          if (isIndeterminate)
            const LinearProgressIndicator()
          else
            LinearProgressIndicator(value: progress),
          const SizedBox(height: 8),
          if (!isIndeterminate)
            Text('${(progress * 100).toInt()}%'),
        ],
      ),
    );
  }
}

class ProgressService {
  static void showProgress(
    BuildContext context, {
    required String title,
    required String message,
    double progress = 0.0,
    bool isIndeterminate = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProgressDialog(
        title: title,
        message: message,
        progress: progress,
        isIndeterminate: isIndeterminate,
      ),
    );
  }

  static void updateProgress(
    BuildContext context, {
    required String title,
    required String message,
    required double progress,
  }) {
    Navigator.of(context).pop();
    showProgress(
      context,
      title: title,
      message: message,
      progress: progress,
    );
  }

  static void hideProgress(BuildContext context) {
    Navigator.of(context).pop();
  }
} 