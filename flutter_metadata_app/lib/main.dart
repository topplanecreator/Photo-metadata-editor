import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/metadata_editor_screen.dart';

void main() {
  runApp(const PhotoMetadataApp());
}

class PhotoMetadataApp extends StatelessWidget {
  const PhotoMetadataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '📸 Photo Metadata Tool',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MetadataEditorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
} 