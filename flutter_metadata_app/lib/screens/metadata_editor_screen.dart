import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import '../models/metadata_model.dart';
import '../services/metadata_service.dart';
import '../widgets/metadata_form.dart';
import '../widgets/image_preview.dart';
import '../widgets/template_manager.dart';
import '../widgets/file_controls.dart';
import '../widgets/progress_dialog.dart';

class MetadataEditorScreen extends StatefulWidget {
  const MetadataEditorScreen({super.key});

  @override
  State<MetadataEditorScreen> createState() => _MetadataEditorScreenState();
}

class _MetadataEditorScreenState extends State<MetadataEditorScreen> {
  List<File> _selectedFiles = [];
  int _currentIndex = 0;
  MetadataModel _metadata = MetadataModel();
  List<String> _templates = [];
  String? _selectedTemplate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    try {
      final templates = await MetadataService.getTemplateNames();
      setState(() {
        _templates = templates;
      });
    } catch (e) {
      _showMessage('Error loading templates: $e');
    }
  }

  Future<void> _pickImages() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
      );

      if (result != null && result.files.isNotEmpty) {
        final files = result.files
            .where((file) => file.path != null)
            .map((file) => File(file.path!))
            .where((file) => file.existsSync())
            .toList();

        if (files.isNotEmpty) {
          setState(() {
            _selectedFiles = files;
            _currentIndex = 0;
          });
          _showMessage('Selected ${files.length} image(s)', isError: false);
          _loadCurrentImageMetadata();
        } else {
          _showMessage('No valid image files selected');
        }
      }
    } catch (e) {
      _showMessage('Error picking images: $e');
    }
  }

  Future<void> _loadCurrentImageMetadata() async {
    if (_selectedFiles.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final metadata = await MetadataService.readMetadataFromImage(_selectedFiles[_currentIndex]);
      setState(() {
        _metadata = metadata;
      });
    } catch (e) {
      _showMessage('Error loading metadata: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _applyMetadata() async {
    if (_selectedFiles.isEmpty) {
      _showMessage('Please select images first');
      return;
    }

    ProgressService.showProgress(
      context,
      title: 'Applying Metadata',
      message: 'Applying metadata to images...',
      isIndeterminate: true,
    );

    try {
      for (int i = 0; i < _selectedFiles.length; i++) {
        final progress = (i + 1) / _selectedFiles.length;
        ProgressService.updateProgress(
          context,
          title: 'Applying Metadata',
          message: 'Processing ${i + 1} of ${_selectedFiles.length} images...',
          progress: progress,
        );
        
        await MetadataService.applyMetadataToImage(_selectedFiles[i], _metadata);
      }
      
      ProgressService.hideProgress(context);
      _showMessage('Metadata applied successfully to ${_selectedFiles.length} image(s)!', isError: false);
    } catch (e) {
      ProgressService.hideProgress(context);
      _showMessage('Error applying metadata: $e');
    }
  }

  Future<void> _clearMetadata() async {
    if (_selectedFiles.isEmpty) {
      _showMessage('Please select images first');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Metadata'),
        content: Text('Remove ALL metadata from ${_selectedFiles.length} image(s)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ProgressService.showProgress(
        context,
        title: 'Clearing Metadata',
        message: 'Clearing metadata from images...',
        isIndeterminate: true,
      );

      try {
        for (int i = 0; i < _selectedFiles.length; i++) {
          final progress = (i + 1) / _selectedFiles.length;
          ProgressService.updateProgress(
            context,
            title: 'Clearing Metadata',
            message: 'Processing ${i + 1} of ${_selectedFiles.length} images...',
            progress: progress,
          );
          
          await MetadataService.clearMetadataFromImage(_selectedFiles[i]);
        }
        
        ProgressService.hideProgress(context);
        _showMessage('Metadata cleared successfully from ${_selectedFiles.length} image(s)!', isError: false);
      } catch (e) {
        ProgressService.hideProgress(context);
        _showMessage('Error clearing metadata: $e');
      }
    }
  }

  Future<void> _renameCurrentFile() async {
    if (_selectedFiles.isEmpty) {
      _showMessage('Please select images first');
      return;
    }

    final currentFile = _selectedFiles[_currentIndex];
    final currentName = path.basenameWithoutExtension(currentFile.path);
    final extension = path.extension(currentFile.path);

    final newName = await _showRenameDialog(currentName);
    if (newName == null || newName.trim().isEmpty) return;

    try {
      final newFileName = newName.trim() + extension;
      await MetadataService.renameFile(currentFile, newFileName);
      
      // Update the file list with the new file
      final newFile = File(path.join(path.dirname(currentFile.path), newFileName));
      setState(() {
        _selectedFiles[_currentIndex] = newFile;
      });
      
      _showMessage('File renamed successfully!', isError: false);
    } catch (e) {
      _showMessage('Error renaming file: $e');
    }
  }

  Future<void> _batchRenameFiles() async {
    if (_selectedFiles.isEmpty) {
      _showMessage('Please select images first');
      return;
    }

    final baseName = await _showBatchRenameDialog();
    if (baseName == null || baseName.trim().isEmpty) return;

    ProgressService.showProgress(
      context,
      title: 'Batch Renaming',
      message: 'Renaming files...',
      isIndeterminate: true,
    );

    try {
      final newFiles = <File>[];
      for (int i = 0; i < _selectedFiles.length; i++) {
        final progress = (i + 1) / _selectedFiles.length;
        ProgressService.updateProgress(
          context,
          title: 'Batch Renaming',
          message: 'Renaming file ${i + 1} of ${_selectedFiles.length}...',
          progress: progress,
        );
        
        final file = _selectedFiles[i];
        final extension = path.extension(file.path);
        final newFileName = '${baseName.trim()}-${i + 1}$extension';
        
        await MetadataService.renameFile(file, newFileName);
        final newFile = File(path.join(path.dirname(file.path), newFileName));
        newFiles.add(newFile);
      }
      
      setState(() {
        _selectedFiles = newFiles;
        _currentIndex = 0;
      });
      
      ProgressService.hideProgress(context);
      _showMessage('Successfully renamed ${_selectedFiles.length} files!', isError: false);
    } catch (e) {
      ProgressService.hideProgress(context);
      _showMessage('Error during batch rename: $e');
    }
  }

  Future<String?> _showRenameDialog(String currentName) async {
    final controller = TextEditingController(text: currentName);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename File'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'New Filename',
            hintText: 'Enter new filename (without extension)',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  Future<String?> _showBatchRenameDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batch Rename'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Base Filename',
                hintText: 'e.g., 2025-KYE-D3-P8',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 8),
            Text(
              'Files will be renamed as: BaseName-1.ext, BaseName-2.ext, etc.',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Rename All'),
          ),
        ],
      ),
    );
  }

  void _showNextImage() {
    if (_selectedFiles.isNotEmpty) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _selectedFiles.length;
      });
      _loadCurrentImageMetadata();
    }
  }

  void _showPreviousImage() {
    if (_selectedFiles.isNotEmpty) {
      setState(() {
        _currentIndex = (_currentIndex - 1) % _selectedFiles.length;
      });
      _loadCurrentImageMetadata();
    }
  }

  void _showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📸 Photo Metadata Tool'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_selectedFiles.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _pickImages,
              tooltip: 'Pick New Images',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // File Selection
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.folder_open, color: Colors.blue[600]),
                              const SizedBox(width: 8),
                              const Text(
                                'File Selection',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: _pickImages,
                                icon: const Icon(Icons.folder_open),
                                label: const Text('Select Images'),
                              ),
                              if (_selectedFiles.isNotEmpty) ...[
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    '${_selectedFiles.length} image(s) selected',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // File Controls
                  if (_selectedFiles.isNotEmpty) ...[
                    FileControls(
                      files: _selectedFiles,
                      currentIndex: _currentIndex,
                      onPrevious: _showPreviousImage,
                      onNext: _showNextImage,
                      onRename: _renameCurrentFile,
                      onBatchRename: _batchRenameFiles,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Image Preview
                  if (_selectedFiles.isNotEmpty) ...[
                    ImagePreview(
                      file: _selectedFiles[_currentIndex],
                      currentIndex: _currentIndex,
                      totalImages: _selectedFiles.length,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Template Manager
                  TemplateManager(
                    templates: _templates,
                    selectedTemplate: _selectedTemplate,
                    onTemplateSelected: (template) async {
                      try {
                        final metadata = await MetadataService.loadTemplate(template);
                        setState(() {
                          _metadata = metadata;
                          _selectedTemplate = template;
                        });
                        _showMessage('Template loaded: $template', isError: false);
                      } catch (e) {
                        _showMessage('Error loading template: $e');
                      }
                    },
                    onSaveTemplate: () async {
                      final name = await _showSaveTemplateDialog();
                      if (name != null) {
                        try {
                          await MetadataService.saveTemplate(name, _metadata);
                          await _loadTemplates();
                          _showMessage('Template saved: $name', isError: false);
                        } catch (e) {
                          _showMessage('Error saving template: $e');
                        }
                      }
                    },
                    onDeleteTemplate: (template) async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Template'),
                          content: Text('Are you sure you want to delete template "$template"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        try {
                          await MetadataService.deleteTemplate(template);
                          await _loadTemplates();
                          if (_selectedTemplate == template) {
                            setState(() {
                              _selectedTemplate = null;
                            });
                          }
                          _showMessage('Template deleted: $template', isError: false);
                        } catch (e) {
                          _showMessage('Error deleting template: $e');
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Metadata Form
                  MetadataForm(
                    metadata: _metadata,
                    onMetadataChanged: (metadata) {
                      setState(() {
                        _metadata = metadata;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Action Buttons
                  if (_selectedFiles.isNotEmpty) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.settings, color: Colors.orange[600]),
                                const SizedBox(width: 8),
                                const Text(
                                  'Actions',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _applyMetadata,
                                    icon: const Icon(Icons.save),
                                    label: const Text('Apply Metadata'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _clearMetadata,
                                    icon: const Icon(Icons.clear),
                                    label: const Text('Clear Metadata'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Future<String?> _showSaveTemplateDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Template'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Template Name',
            hintText: 'Enter template name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
} 