import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:read_pdf_text/read_pdf_text.dart';

class FileParsingService {
  Future<String?> pickAndParseFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'txt'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;

        if (file.path == null) return null;

        if (file.extension == 'pdf') {
          return await _parsePdf(file.path!);
        } else if (file.extension == 'txt') {
          return await _parseTxt(file.path!);
        }
      }
      return null;
    } catch (e) {
      print('Error picking file: $e');
      throw Exception('Failed to pick file: $e');
    }
  }

  Future<String> _parsePdf(String path) async {
    try {
      String text = await ReadPdfText.getPDFtext(path);
      return text;
    } catch (e) {
      print('Error parsing PDF: $e');
      throw Exception('Failed to parse PDF: $e');
    }
  }

  Future<String> _parseTxt(String path) async {
    try {
      final file = File(path);
      return await file.readAsString();
    } catch (e) {
      print('Error parsing TXT: $e');
      throw Exception('Failed to parse TXT: $e');
    }
  }
}
