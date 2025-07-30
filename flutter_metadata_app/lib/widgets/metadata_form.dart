import 'package:flutter/material.dart';
import '../models/metadata_model.dart';

class MetadataForm extends StatefulWidget {
  final MetadataModel metadata;
  final Function(MetadataModel) onMetadataChanged;

  const MetadataForm({
    super.key,
    required this.metadata,
    required this.onMetadataChanged,
  });

  @override
  State<MetadataForm> createState() => _MetadataFormState();
}

class _MetadataFormState extends State<MetadataForm> {
  late TextEditingController _titleController;
  late TextEditingController _subjectController;
  late TextEditingController _tagsController;
  late TextEditingController _commentsController;
  late TextEditingController _authorsController;
  late TextEditingController _copyrightController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.metadata.title);
    _subjectController = TextEditingController(text: widget.metadata.subject);
    _tagsController = TextEditingController(text: widget.metadata.tags);
    _commentsController = TextEditingController(text: widget.metadata.comments);
    _authorsController = TextEditingController(text: widget.metadata.authors);
    _copyrightController = TextEditingController(text: widget.metadata.copyright);
  }

  @override
  void didUpdateWidget(MetadataForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.metadata != widget.metadata) {
      _titleController.text = widget.metadata.title;
      _subjectController.text = widget.metadata.subject;
      _tagsController.text = widget.metadata.tags;
      _commentsController.text = widget.metadata.comments;
      _authorsController.text = widget.metadata.authors;
      _copyrightController.text = widget.metadata.copyright;
    }
  }

  void _updateMetadata() {
    final metadata = MetadataModel(
      title: _titleController.text,
      subject: _subjectController.text,
      tags: _tagsController.text,
      comments: _commentsController.text,
      authors: _authorsController.text,
      copyright: _copyrightController.text,
    );
    widget.onMetadataChanged(metadata);
  }

  void _clearAll() {
    _titleController.clear();
    _subjectController.clear();
    _tagsController.clear();
    _commentsController.clear();
    _authorsController.clear();
    _copyrightController.clear();
    _updateMetadata();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    _tagsController.dispose();
    _commentsController.dispose();
    _authorsController.dispose();
    _copyrightController.dispose();
    super.dispose();
  }

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
                Icon(Icons.description, color: Colors.purple[600]),
                const SizedBox(width: 8),
                const Text(
                  'Metadata Fields',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _titleController,
              label: 'Title',
              icon: Icons.title,
              onChanged: (_) => _updateMetadata(),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _subjectController,
              label: 'Subject',
              icon: Icons.subject,
              onChanged: (_) => _updateMetadata(),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _tagsController,
              label: 'Tags (comma separated)',
              icon: Icons.tag,
              onChanged: (_) => _updateMetadata(),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _commentsController,
              label: 'Comments',
              icon: Icons.comment,
              maxLines: 3,
              onChanged: (_) => _updateMetadata(),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _authorsController,
              label: 'Authors',
              icon: Icons.person,
              onChanged: (_) => _updateMetadata(),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _copyrightController,
              label: 'Copyright',
              icon: Icons.copyright,
              onChanged: (_) => _updateMetadata(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _clearAll,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear All'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
        hintText: 'Enter $label',
      ),
      maxLines: maxLines,
      onChanged: onChanged,
    );
  }
} 