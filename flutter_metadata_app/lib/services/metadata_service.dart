import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:exif/exif.dart';
import '../models/metadata_model.dart';

class MetadataService {
  static const String _templateKey = 'metadata_templates';
  
  // Platform detection
  static bool get isDesktop => Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  static bool get isMobile => Platform.isAndroid || Platform.isIOS;
  
  // Template Management
  static Future<List<String>> getTemplateNames() async {
    final prefs = await SharedPreferences.getInstance();
    final templatesJson = prefs.getStringList(_templateKey) ?? [];
    return templatesJson;
  }

  static Future<void> saveTemplate(String name, MetadataModel metadata) async {
    final prefs = await SharedPreferences.getInstance();
    final templates = await getTemplateNames();
    
    if (!templates.contains(name)) {
      templates.add(name);
      await prefs.setStringList(_templateKey, templates);
    }
    
    await prefs.setString('template_$name', jsonEncode(metadata.toJson()));
  }

  static Future<MetadataModel> loadTemplate(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final templateJson = prefs.getString('template_$name');
    
    if (templateJson == null) {
      throw Exception('Template not found: $name');
    }
    
    final json = jsonDecode(templateJson) as Map<String, dynamic>;
    return MetadataModel.fromJson(json);
  }

  static Future<void> deleteTemplate(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final templates = await getTemplateNames();
    templates.remove(name);
    await prefs.setStringList(_templateKey, templates);
    await prefs.remove('template_$name');
  }

  // File Operations
  static Future<List<File>> pickImages() async {
    // This would need to be implemented with file_picker
    // For now, returning empty list as placeholder
    return [];
  }

  static Future<void> renameFile(File file, String newName) async {
    final directory = path.dirname(file.path);
    final extension = path.extension(file.path);
    
    if (!newName.toLowerCase().endsWith(extension.toLowerCase())) {
      newName += extension;
    }
    
    final newPath = path.join(directory, newName);
    final newFile = File(newPath);
    
    if (await newFile.exists() && newPath != file.path) {
      throw Exception('A file with this name already exists');
    }
    
    await file.rename(newPath);
  }

  static Future<void> batchRenameFiles(List<File> files, String baseName) async {
    final directory = path.dirname(files.first.path);
    final extension = path.extension(files.first.path);
    
    for (int i = 0; i < files.length; i++) {
      final newName = '$baseName-${i + 1}$extension';
      final newPath = path.join(directory, newName);
      final newFile = File(newPath);
      
      if (await newFile.exists()) {
        throw Exception('File already exists: $newName');
      }
      
      await files[i].rename(newPath);
    }
  }

  // EXIF Metadata Operations - Read Only (works on all platforms)
  static Future<MetadataModel> readMetadataFromImage(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final exifData = await readExifFromBytes(bytes);
      
      if (exifData.isEmpty) {
        return MetadataModel();
      }

      final metadata = MetadataModel();
      
      // Read standard EXIF fields
      metadata.title = _getExifString(exifData, 'Image ImageDescription') ?? '';
      metadata.subject = _getExifString(exifData, 'Image XPSubject') ?? '';
      metadata.tags = _getExifString(exifData, 'Image XPKeywords') ?? '';
      metadata.authors = _getExifString(exifData, 'Image Artist') ?? '';
      metadata.copyright = _getExifString(exifData, 'Image Copyright') ?? '';
      metadata.comments = _getExifString(exifData, 'EXIF UserComment') ?? '';

      return metadata;
    } catch (e) {
      print('Error reading EXIF metadata: $e');
      return MetadataModel();
    }
  }

  // EXIF Metadata Operations - Write (disabled on desktop platforms)
  static Future<void> applyMetadataToImage(File file, MetadataModel metadata) async {
    if (isDesktop) {
      throw Exception('EXIF metadata writing is not supported on desktop platforms (Windows, macOS, Linux). This feature is only available on mobile devices (Android, iOS).');
    }
    
    // This code would only run on mobile platforms
    throw Exception('EXIF metadata writing is not implemented. Consider using native_exif package for mobile platforms.');
  }

  static Future<void> clearMetadataFromImage(File file) async {
    if (isDesktop) {
      throw Exception('EXIF metadata clearing is not supported on desktop platforms (Windows, macOS, Linux). This feature is only available on mobile devices (Android, iOS).');
    }
    
    // This code would only run on mobile platforms
    throw Exception('EXIF metadata clearing is not implemented. Consider using native_exif package for mobile platforms.');
  }

  static Future<void> applyMetadataToImages(List<File> files, MetadataModel metadata) async {
    if (isDesktop) {
      throw Exception('EXIF metadata writing is not supported on desktop platforms (Windows, macOS, Linux). This feature is only available on mobile devices (Android, iOS).');
    }
    
    // This code would only run on mobile platforms
    throw Exception('EXIF metadata writing is not implemented. Consider using native_exif package for mobile platforms.');
  }

  static Future<void> clearMetadataFromImages(List<File> files) async {
    if (isDesktop) {
      throw Exception('EXIF metadata clearing is not supported on desktop platforms (Windows, macOS, Linux). This feature is only available on mobile devices (Android, iOS).');
    }
    
    // This code would only run on mobile platforms
    throw Exception('EXIF metadata clearing is not implemented. Consider using native_exif package for mobile platforms.');
  }

  // Helper methods for EXIF operations
  static String? _getExifString(Map<String, IfdTag> exifData, String key) {
    final tag = exifData[key];
    if (tag == null) return null;
    
    try {
      if (key.contains('XP') && tag.type == IfdTagType.byte) {
        // Handle Windows XP specific fields (UTF-16LE)
        return _decodeUtf16Le(tag.value as List<int>);
      } else if (key == 'EXIF UserComment' && tag.type == IfdTagType.undefined) {
        // Handle UserComment with ASCII prefix
        final bytes = tag.value as List<int>;
        if (bytes.length > 8 && bytes.take(8).every((b) => b == 0x41 || b == 0x53 || b == 0x43 || b == 0x49 || b == 0x00)) {
          return String.fromCharCodes(bytes.skip(8));
        }
        return String.fromCharCodes(bytes);
      } else {
        return tag.printable;
      }
    } catch (e) {
      print('Error decoding EXIF field $key: $e');
      return null;
    }
  }

  static List<int> _encodeUtf16Le(String text) {
    final bytes = utf8.encode(text);
    final utf16Bytes = <int>[];
    for (int i = 0; i < bytes.length; i++) {
      utf16Bytes.add(bytes[i]);
      utf16Bytes.add(0); // Little-endian UTF-16
    }
    utf16Bytes.add(0); // Null terminator
    utf16Bytes.add(0);
    return utf16Bytes;
  }

  static String _decodeUtf16Le(List<int> bytes) {
    try {
      // Remove null terminators and decode as UTF-16LE
      final cleanBytes = bytes.takeWhile((b) => b != 0).toList();
      return String.fromCharCodes(cleanBytes);
    } catch (e) {
      return String.fromCharCodes(bytes);
    }
  }

  // File Info
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  static Future<String> getFileSize(File file) async {
    try {
      final size = await file.length();
      return formatFileSize(size);
    } catch (e) {
      return 'Unknown';
    }
  }
} 