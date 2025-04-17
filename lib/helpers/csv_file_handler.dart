import 'dart:convert';
import 'package:asset_management_local/helpers/ui_components.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:file_saver/file_saver.dart';

/// CSV File Handler ///
class CsvFileHandler {
  static convertToCSV(List<List<dynamic>> rows, String fileLabel) async {
    String csv = const ListToCsvConverter().convert(rows);
    await saveCsvFile(csv, fileLabel);
  }

  static saveCsvFile(String content, String label) async {
    DateTime now = DateTime.now();
    label = "${label}_";

    /// Format the date as 'yyyyMMdd' ///
    String formattedDateTime =
        '${now.year.toString().substring(2, 4)}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';

    /// Define the document name ///
    String documentName = '$label$formattedDateTime.csv';

    /// File name ///
    final bytes = utf8.encode(content);
    try {
      await FileSaver.instance.saveFile(
        bytes: bytes,
        mimeType: MimeType.csv,
        name: documentName,
      );
      showToast("Report generated and downloaded successfully");
    } catch (e) {
      showToast("Unable to generate report");
    }
  }

  /// Load CSV File ///
  static loadCSV(File file) async {
    final input = file.openRead();
    return await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
  }

  /// Load CSV File ///
}
/// CSV File Handler ///