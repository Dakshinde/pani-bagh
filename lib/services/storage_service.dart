import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;

class StorageService {
  // Function to save data to a CSV string
  Future<void> saveToCsv(double level) async {
    String timestamp = DateTime.now().toIso8601String();
    String dataRow = "$timestamp, $level\n";

    if (kIsWeb) {
      // Use debugPrint to satisfy the lint warning
      debugPrint("CSV LOG [Web]: $dataRow");
    } else {
      // CORRECTED METHOD NAME BELOW
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/water_logs.csv');
      await file.writeAsString(dataRow, mode: FileMode.append);
    }
  }

  // Function to share the file (Mobile only)
  Future<void> shareLogFile() async {
    if (!kIsWeb) {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/water_logs.csv';
      
      final file = File(path);
      if (await file.exists()) {
        await Share.shareXFiles([XFile(path)], text: 'Pani Bagh Water Logs');
      } else {
        debugPrint("No log file found to share.");
      }
    }
  }
}