import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
// import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> generateCSVFromAPI() async {
  try {
    final response =
        await http.get(Uri.parse('https://kegiatanpendarungan.id/api/v1/proker'));

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> prokerData =
          List<Map<String, dynamic>>.from(json.decode(response.body)['data']);

      List<List<dynamic>> csvData = [
        [
          'No',
          'Nama',
          'Tanggal Kegiatan',
          'Sumber Dana',
          'Rencana Anggaran',
          'Realisasi Anggaran',
          'Sisa Dana',
          'Status',
          'Deskripsi',
          'Hambatan',
          'Evaluasi',
        ],
        // Data rows for CSV file
        ...prokerData.map((data) => [
              data['id'],
              data['judul'],
              data['tanggal'],
              data['fundsName'],
              data['jumlahAnggaran'],
              data['jumlahRealisasi'],
              (data['jumlahAnggaran'] != null && data['jumlahRealisasi'] != null)
                  ? data['jumlahAnggaran'] - data['jumlahRealisasi']
                  : '',
              data['status'],
              data['deskripsi'] ?? 'Tidak ada deskripsi',
              data['hambatan'] ?? 'Tidak ada hambatan',
              data['evaluasi'] ?? 'Tidak ada evaluasi',
            ]),
      ];

      // Get the download directory
      Directory? downloadsDirectory;
      if (Platform.isAndroid || Platform.isIOS) {
        // Ask for storage permission if not granted yet
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }

        downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
      }

      if (downloadsDirectory != null) {
        final String path = '${downloadsDirectory.path}/proker_data.csv';
        final File file = File(path);
        String csv = const ListToCsvConverter().convert(csvData);
        await file.writeAsString(csv);

        // Display a message that the file has been downloaded
        print('CSV file created at: $path');
      } else {
        print('Failed to get downloads directory');
      }
    } else {
      throw Exception('Failed to fetch proker data');
    }
  } catch (e) {
    print('Error creating CSV file: $e');
  }
}
