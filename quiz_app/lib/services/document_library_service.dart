import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class DocumentLibraryService {
  static const String _documentsKey = 'saved_documents';

  Future<List<SavedDocument>> getDocuments() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> documents = prefs.getStringList(_documentsKey) ?? [];

    return documents.map((jsonString) {
      final map = jsonDecode(jsonString);
      return SavedDocument.fromMap(map);
    }).toList();
  }

  Future<void> saveDocument(SavedDocument document) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> documents = prefs.getStringList(_documentsKey) ?? [];

    documents.add(jsonEncode(document.toMap()));
    await prefs.setStringList(_documentsKey, documents);
  }

  Future<void> deleteDocument(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> documents = prefs.getStringList(_documentsKey) ?? [];

    documents.removeWhere((jsonString) {
      final map = jsonDecode(jsonString);
      return map['id'] == id;
    });

    await prefs.setStringList(_documentsKey, documents);

    // Also delete the actual file
    try {
      final doc = await getDocumentById(id);
      if (doc != null) {
        final file = File(doc.filePath);
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (e) {
      print('Error deleting file: $e');
    }
  }

  Future<SavedDocument?> getDocumentById(String id) async {
    final docs = await getDocuments();
    try {
      return docs.firstWhere((doc) => doc.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<String> getDocumentsDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final docsDir = Directory('${appDir.path}/user_documents');
    if (!await docsDir.exists()) {
      await docsDir.create(recursive: true);
    }
    return docsDir.path;
  }
}

class SavedDocument {
  final String id;
  final String name;
  final String filePath;
  final String fileType; // pdf, doc, txt, etc.
  final int fileSize; // in bytes
  final DateTime addedDate;
  final DateTime? lastOpened;

  SavedDocument({
    required this.id,
    required this.name,
    required this.filePath,
    required this.fileType,
    required this.fileSize,
    required this.addedDate,
    this.lastOpened,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'filePath': filePath,
      'fileType': fileType,
      'fileSize': fileSize,
      'addedDate': addedDate.toIso8601String(),
      'lastOpened': lastOpened?.toIso8601String(),
    };
  }

  factory SavedDocument.fromMap(Map<String, dynamic> map) {
    return SavedDocument(
      id: map['id'],
      name: map['name'],
      filePath: map['filePath'],
      fileType: map['fileType'],
      fileSize: map['fileSize'],
      addedDate: DateTime.parse(map['addedDate']),
      lastOpened:
          map['lastOpened'] != null ? DateTime.parse(map['lastOpened']) : null,
    );
  }

  String get formattedSize {
    if (fileSize < 1024) return '$fileSize B';
    if (fileSize < 1024 * 1024)
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
