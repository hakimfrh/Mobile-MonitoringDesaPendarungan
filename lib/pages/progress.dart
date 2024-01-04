import 'package:flutter/material.dart';
import 'package:KegiatanPendarungan/Models/work_model.dart';
import 'package:KegiatanPendarungan/Widgets/AppHeader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class progress extends StatefulWidget {
  progress({Key? key}) : super(key: key);

  @override
  State<progress> createState() => _progressState();
}

class _progressState extends State<progress> {
  String selectedYear = DateTime.now().year.toString();
  String searchText = '';
  List<dynamic> prokerData = [];
  late List<Map<String, dynamic>> userData;
  late ProgramKerja programkerja;
  List<String> yearsList = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
    userData = [];
    fetchDataTable().then((programKerjas) {
      setState(() {
        prokerData = programKerjas;
      });
    });
  }

// akun
  Future<void> fetchUserData() async {
    final response = await http
        .get(Uri.parse('https://kegiatanpendarungan.id/api/v1/users'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        userData = List<Map<String, dynamic>>.from(data['data']);

        // Periksa apakah ada user dengan role "pejabatdesa"
        bool isPejabatDesa =
            userData.any((user) => user['roleuser'] == 'pejabatdesa');
        String userName = isPejabatDesa
            ? userData.firstWhere((user) => user['roleuser'] == 'pejabatdesa',
                orElse: () => {'fullname': ''})['fullname']
            : '';

        if (isPejabatDesa) {
          print('User has role pejabatdesa');
          print('Selamat pagi, @$userName!');
        } else {
          print('User role is not pejabatdesa');
        }
      });
    } else {
      throw Exception('Failed to load user data');
    }
  }

// data table
 Future<List<ProgramKerja>> fetchDataTable() async {
  try {
    final response = await http.get(Uri.parse('https://kegiatanpendarungan.id/api/v1/proker'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];

      List<dynamic> sortedResponseData = responseData
          .where((element) => element['id'] != null)
          .toList()
        ..sort((a, b) => a['id'].compareTo(b['id']));

      List<ProgramKerja> programKerjas = sortedResponseData
          .map((programJson) => ProgramKerja.fromJson(programJson))
          .toList();

      // Ambil daftar tahun dari data API
      Set<String> uniqueYears = programKerjas.map((proker) => proker.tahunAnggaran.toString()).toSet();
      yearsList = uniqueYears.toList()..sort((a, b) => b.compareTo(a));

      return programKerjas;
    } else {
      throw Exception('Gagal memuat data');
    }
  } catch (error) {
    print('Error fetching data: $error');
    throw error;
  }
}

  // data untuk filter
 Future<void> fetchDataWithYear(String year, String status) async {
  try {
    final response = await http.get(Uri.parse('https://kegiatanpendarungan.id/api/v1/proker'));
    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body)['data'];

      // Mengganti cara cast data ke List<Map<String, dynamic>>
      List<Map<String, dynamic>> processedData = List<Map<String, dynamic>>.from(responseData);

      // Pengecekan apakah widget masih terpasang sebelum memanggil setState
      if (mounted) {
        // Ganti bagian ini sesuai dengan yang telah diperbaiki sebelumnya
        setState(() {
          prokerData = processedData
              .where((proker) =>
                  proker['tahunAnggaran'].toString() == year &&
                  (status == 'Semua Data' ||
                      proker['status'].toUpperCase() == status.toUpperCase() ||
                      (status == 'Proses' &&
                          proker['status'].toUpperCase() == 'PROGRESS') ||
                      (status == 'Selesai' &&
                          proker['status'].toUpperCase() == 'SELESAI')))
              .map((programJson) => ProgramKerja.fromJson(programJson))
              .toList();

          // Tambahkan print statement untuk melihat hasil filter
          print('Filtered Data: $prokerData');
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  } catch (error) {
    print('Error fetching data: $error');
  }
}

  // data untuk searching
  Future<void> fetchDataSearching() async {
    try {
      final response = await http
          .get(Uri.parse('https://kegiatanpendarungan.id/api/v1/proker'));
      if (response.statusCode == 200) {
        setState(() {
          List<dynamic> responseData = json.decode(response.body)['data'];
          if (searchText.isNotEmpty) {
            // Jika ada teks pencarian, filter data berdasarkan teks yang dicari
            List<ProgramKerja> filteredData = responseData
                .where((proker) {
                  return proker['judul']
                      .toString()
                      .toLowerCase()
                      .contains(searchText.toLowerCase());
                })
                .map((programJson) => ProgramKerja.fromJson(programJson))
                .toList();
            prokerData = filteredData;
          } else {
            // Jika tidak ada teks pencarian, tampilkan semua data
            List<ProgramKerja> programKerjas = responseData
                .map((programJson) => ProgramKerja.fromJson(programJson))
                .toList();
            prokerData = programKerjas;
          }
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  //fungsi untuk menampilkan  detail program kerja
  void showProgramKerjaDetail(
      BuildContext context, Map<String, dynamic> proker) async {
    try {
      Map<String, dynamic> prokerDetails =
          await ProgramKerjaService.fetchProgramKerjaDetail(proker['id']);
      if (prokerDetails != null && prokerDetails.isNotEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return DetailProgramKerja(prokerDetails: prokerDetails);
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to fetch program details.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print('Error: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'Failed to fetch program details. Please try again later.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tittle(), // App header (tittle)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        top: 1,
                      ),
                      child: Builder(
                        builder: (context) {
                          print('userData: $userData');
                          if (userData.isNotEmpty) {
                            print('User data is not empty');
                            print(
                                'UserData Roles: ${userData.map((user) => user['roleuser'])}');

                            bool isPejabatDesa = userData.any((user) =>
                                    user['roleuser'] == 'pejabatdesa') ??
                                false;
                            String userName = isPejabatDesa
                                ? userData.firstWhere((user) =>
                                    user['roleuser'] ==
                                    'pejabatdesa')['fullname']
                                : (userData.isNotEmpty
                                    ? userData[0]['fullname']
                                    : '');

                            if (isPejabatDesa) {
                              print('User has role pejabatdesa');
                              return Text(
                                'Selamat pagi, ${isPejabatDesa ? '@$userName' : ''}!',
                                style: TextStyle(fontSize: 20),
                              );
                            } else {
                              print('User role is not pejabatdesa');
                            }
                          } else {
                            print('User data is empty');
                          }
                          return Text(
                            'Selamat pagi!',
                            style: TextStyle(fontSize: 20),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 16),
                      child: Text(
                        '| Progress Program Kerja',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 10),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white10),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 8,
                                  offset: Offset(0, 5),
                                  spreadRadius: 0,
                                ),
                              ],
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 10, left: 10),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Tahun',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w200),
                                                ),
                                                SizedBox(
                                                    width:
                                                        10), // Add some space between text and dropdown
                                                // Dropdown button
                                                Column(
                                                  children: [
                                                    Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(),
                                                      ),
                                                      child: DropdownButton<
                                                          String>(
                                                        dropdownColor:
                                                            Colors.black,
                                                        value: selectedYear,
                                                        onChanged:
                                                            (String? newValue) {
                                                          setState(() {
                                                            selectedYear =
                                                                newValue!;
                                                           fetchDataWithYear(selectedYear, '');
                                                          });
                                                        },
                                                        underline: Container(),
                                                        icon: Image.asset(
                                                          'lib/assets/images/down-arrow.png',
                                                          width: 30,
                                                          height: 24,
                                                          color: Colors.white,
                                                        ),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20,
                                                                right: 7),
                                                        items: List.generate(
                                                          DateTime.now().year -
                                                              2010 +
                                                              1,
                                                          (index) => (DateTime
                                                                          .now()
                                                                      .year -
                                                                  index)
                                                              .toString(),
                                                        ).map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                          (value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value,
                                                              child: Text(
                                                                value,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            );
                                                          },
                                                        ).toList(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.only(),
                                            child: Row(
                                              children: [
                                                SizedBox(width: 10),
                                                Container(
                                                  width: 260,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: Colors.black),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: SvgPicture.asset(
                                                          'lib/assets/search.svg',
                                                          width: 18,
                                                          height: 18,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child:
                                                                  SingleChildScrollView(
                                                                child:
                                                                    TextField(
                                                                  cursorWidth:
                                                                      2,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                  decoration:
                                                                      InputDecoration(
                                                                    hintText:
                                                                        'Cari program kerja',
                                                                    hintStyle: TextStyle(
                                                                        color: Colors
                                                                            .grey),
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                  ),
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      searchText =
                                                                          value;
                                                                    });
                                                                    fetchDataSearching(); // Panggil fungsi pencarian di sini saat nilai teks berubah
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          DataTable(
                                            columns: [
                                              DataColumn(
                                                label: Text('No',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              DataColumn(
                                                label: Text('Nama',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              DataColumn(
                                                label: Text('Status',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              DataColumn(
                                                label: Text('Aksi',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ],
                                            rows: prokerData
                                                .map<DataRow>((proker) {
                                              return DataRow(cells: [
                                                DataCell(
                                                    Text(proker.id.toString())),
                                                DataCell(Text(proker.judul)),
                                                DataCell(
                                                  Container(
                                                    width: 100,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      color: proker.status ==
                                                              'Selesai'
                                                          ? Color.fromARGB(255,
                                                              176, 241, 187)
                                                          : proker.status ==
                                                                  'Progress'
                                                              ? Color.fromARGB(
                                                                  255,
                                                                  200,
                                                                  214,
                                                                  155)
                                                              : Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                    ),
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            width: 20,
                                                            height: 20,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: proker
                                                                          .status ==
                                                                      'Selesai'
                                                                  ? Colors.green
                                                                  : proker.status ==
                                                                          'Progress'
                                                                      ? Colors
                                                                          .yellow // Ganti dengan warna yang diinginkan
                                                                      : Colors
                                                                          .grey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          ),
                                                          SizedBox(width: 5),
                                                          Text(
                                                            proker.status ==
                                                                    'Progress' // Ganti 'Progress' menjadi 'Proses'
                                                                ? 'Proses' // Ganti kata yang ditampilkan
                                                                : proker.status,
                                                            style: TextStyle(
                                                              color: proker
                                                                          .status ==
                                                                      'Selesai'
                                                                  ? Colors.green
                                                                  : proker.status ==
                                                                          'Progress'
                                                                      ? Colors
                                                                          .yellow
                                                                      : Colors
                                                                          .grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  InkWell(
                                                    onTap: () {
                                                      final programKerjaData = {
                                                        'id': proker.id,
                                                      };
                                                      showProgramKerjaDetail(
                                                          context,
                                                          programKerjaData);
                                                    },
                                                    child: SvgPicture.asset(
                                                      'lib/assets/open.svg',
                                                      height: 24,
                                                    ),
                                                  ),
                                                ),
                                              ]);
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//kelas untuk ngambil api nya data proker dimasukkan kedalam detail proker
class ProgramKerjaService {
  static Future<Map<String, dynamic>> fetchProgramKerjaDetail(
      int prokerID) async {
    try {
      final response = await http.get(
          Uri.parse('https://kegiatanpendarungan.id/api/v1/proker/$prokerID'));
      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      } else {
        throw Exception('Failed to load program details');
      }
    } catch (error) {
      throw Exception('Error fetching program details: $error');
    }
  }
}

//tampilan untuk detail program kerja
class DetailProgramKerja extends StatelessWidget {
  final Map<String, dynamic> prokerDetails;

  const DetailProgramKerja({Key? key, required this.prokerDetails})
      : super(key: key);

  Widget buildStatusWidget(String status) {
    Color backgroundColor;
    Color textColor;
    String statusText;

    // Tentukan warna dan teks berdasarkan status
    if (status.toUpperCase() == 'SELESAI') {
      backgroundColor = Color.fromARGB(255, 176, 241, 187);
      textColor = Colors.green;
      statusText = 'Selesai';
    } else if (status.toUpperCase() == 'PROGRESS' ||
        status.toUpperCase() == 'PROSES') {
      backgroundColor = Color.fromARGB(255, 200, 214, 155);
      textColor = Colors.yellow;
      statusText = 'Proses';
    } else {
      // Tambahkan penanganan status lain jika diperlukan
      backgroundColor = Colors.grey;
      textColor = Colors.white;
      statusText = 'Undefined';
    }

    // Buat dan kembalikan widget status
    return Container(
      width: 100,
      height: 30,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: textColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(width: 5),
            Text(
              statusText,
              style: TextStyle(color: textColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailText(String label, String value) {
    print('Label yang diterima: $label');

    if (label == 'Status Program Kerja') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          buildStatusWidget(value), // Gunakan prokerDetails['status'] di sini
          SizedBox(height: 12),
        ],
      );
    } else if (label == 'Dokumentasi Program Kerja') {
      List<String> imageUrls =
          value.split(RegExp(r'[;,]')).map((e) => e.trim()).toList();
      String baseUrl = 'https://kegiatanpendarungan.id/api/v1/proker/';

      List<Widget> imageWidgets = imageUrls.map((url) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Image.network(
            baseUrl + url,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        );
      }).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Column(
            children: imageWidgets,
          ),
          SizedBox(height: 12),
        ],
      );
    } else {
      // Untuk label lainnya, tampilkan sebagai teks biasa
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(value),
          SizedBox(height: 12),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 500,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              padding: EdgeInsets.all(22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '| Detail Program Kerja',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  // Menampilkan detail program kerja
                  buildDetailText('Judul', prokerDetails['judul']),
                  buildDetailText('Deskripsi', prokerDetails['deskripsi']),
                  buildDetailText('Hambatan Program Kerja',
                      prokerDetails['hambatan'] ?? 'Tidak ada'),
                  buildDetailText('Evaluasi Program Kerja',
                      prokerDetails['evaluasi'] ?? 'Tidak ada'),
                  buildDetailText(
                      'Sumber Dana', prokerDetails['fundsName'] ?? 'Unknown'),
                  buildDetailText('Status Program Kerja',
                      prokerDetails['status'].toString().toUpperCase()),
                  buildDetailText('Jumlah Realisasi Anggaran',
                      prokerDetails['jumlahRealisasi'].toString()),
                  buildDetailText('Jumlah Anggaran',
                      prokerDetails['jumlahAnggaran'].toString()),
                  buildDetailText(
                      'Tanggal Pelaksanaan', prokerDetails['tanggal']),
                  buildDetailText('Realisasi Tanggal Pelaksanaan',
                      prokerDetails['tanggalRealisasi'] ?? 'Belum ada'),
                  buildDetailText('Dokumentasi Program Kerja',
                      prokerDetails['dokumentasi'] ?? 'Belum ada'),
                  SizedBox(height: 20),
                  // Tombol untuk menutup dialog
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                        ),
                        child: Text(
                          'Tutup',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildDetailText(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '$label:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 6),
      Text(
        value,
        style: TextStyle(fontSize: 16),
      ),
      SizedBox(height: 12),
    ],
  );
}

void main() {
  runApp(MaterialApp(
    home: progress(),
  ));
}
