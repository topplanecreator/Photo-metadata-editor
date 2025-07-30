import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class FileControls extends StatelessWidget {
  final List<File> files;
  final int currentIndex;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onRename;
  final VoidCallback onBatchRename;

  const FileControls({
    super.key,
    required this.files,
    required this.currentIndex,
    required this.onPrevious,
    required this.onNext,
    required this.onRename,
    required this.onBatchRename,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.control_camera, color: Colors.orange[600]),
                const SizedBox(width: 8),
                const Text(
                  'File Controls',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onRename,
                    icon: const Icon(Icons.edit),
                    label: const Text('Rename Current'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onBatchRename,
                    icon: const Icon(Icons.batch_prediction),
                    label: const Text('Batch Rename'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onPrevious,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onNext,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildFileInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildFileInfo() {
    if (files.isEmpty) return const SizedBox.shrink();

    final currentFile = files[currentIndex];
    final fileName = path.basename(currentFile.path);
    final fileSize = _getFileSizeString(currentFile);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current: $fileName',
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          'Size: $fileSize',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Type: ${path.extension(currentFile.path).toUpperCase()}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  String _getFileSizeString(File file) {
    try {
      final size = file.lengthSync();
      return _formatFileSize(size);
    } catch (e) {
      return 'Unknown';
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
} 