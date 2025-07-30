import 'package:flutter/material.dart';

class TemplateManager extends StatelessWidget {
  final List<String> templates;
  final String? selectedTemplate;
  final Function(String) onTemplateSelected;
  final VoidCallback onSaveTemplate;
  final Function(String) onDeleteTemplate;

  const TemplateManager({
    super.key,
    required this.templates,
    required this.selectedTemplate,
    required this.onTemplateSelected,
    required this.onSaveTemplate,
    required this.onDeleteTemplate,
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
                Icon(Icons.save, color: Colors.indigo[600]),
                const SizedBox(width: 8),
                const Text(
                  'Templates',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onSaveTemplate,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Template'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
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
                  child: DropdownButtonFormField<String>(
                    value: selectedTemplate,
                    decoration: const InputDecoration(
                      labelText: 'Load Template',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.folder_open),
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('Select a template...'),
                      ),
                      ...templates.map((template) => DropdownMenuItem<String>(
                        value: template,
                        child: Text(template),
                      )),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        onTemplateSelected(value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                if (selectedTemplate != null)
                  ElevatedButton.icon(
                    onPressed: () => onDeleteTemplate(selectedTemplate!),
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
              ],
            ),
            if (templates.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Available templates: ${templates.length}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 