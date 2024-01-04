import 'package:flutter/material.dart';
import 'package:KegiatanPendarungan/Widgets/AppHeader.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:KegiatanPendarungan/pages/proker_csv.dart';

class report extends StatefulWidget {
  report({Key? key}) : super(key: key);

  @override
  State<report> createState() => _reportState();
}

class _reportState extends State<report> {
 String selectedYear = DateTime.now().year.toString();
  String searchText = '';
  String selectedStatus = 'Semua Data';
  late List<Map<String, dynamic>> userData;
  late List<Map<String, dynamic>> prokerData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    userData = [];
    prokerData = [];
    fetchProkerData();
  }

//fungsi untuk filter status
  Future<void> fetchDataWithYearAndStatus(String year, String status) async {
    try {
      final response = await http
          .get(Uri.parse('https://kegiatanpendarungan.id/api/v1/proker'));
      if (response.statusCode == 200) {
        setState(() {
          List<dynamic> responseData = json.decode(response.body)['data'];
          List<Map<String, dynamic>> processedData =
              responseData.cast<Map<String, dynamic>>();
         prokerData = processedData
    .where((proker) =>
        proker['tahunAnggaran'].toString() == year &&
        (status == 'Semua Data' ||
            proker['status'].toUpperCase() == status.toUpperCase() ||
            (status == 'Proses' && proker['status'].toUpperCase() == 'PROGRESS') ||
            (status == 'Selesai' && proker['status'].toUpperCase() == 'SELESAI')))
    .toList();

        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

// Fungsi untuk mengambil data dari API proker berdasarkan tahun yang dipilih
  Future<void> fetchDataWithYear(String year) async {
    try {
      final response = await http
          .get(Uri.parse('https://kegiatanpendarungan.id/api/v1/proker'));
      if (response.statusCode == 200) {
        setState(() {
          List<dynamic> responseData = json.decode(response.body)['data'];
          List<Map<String, dynamic>> processedData =
              responseData.cast<Map<String, dynamic>>();
          prokerData = processedData
              .where((proker) => proker['tahunAnggaran'].toString() == year)
              .toList();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

// data table proker
  Future<void> fetchProkerData() async {
    try {
      final response = await http
          .get(Uri.parse('https://kegiatanpendarungan.id/api/v1/proker'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          prokerData = List<Map<String, dynamic>>.from(data['data']);
        });
      } else {
        throw Exception('Failed to load proker data');
      }
    } catch (error) {
      print('Error fetching proker data: $error');
    }
  }

//data login pengguna
  Future<void> fetchUserData() async {
    try {
      final response = await http
          .get(Uri.parse('https://kegiatanpendarungan.id/api/v1/users'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          userData = List<Map<String, dynamic>>.from(data['data']);
          // You can perform additional logic with the userData here
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    prokerData.sort(
        (a, b) => a['id'].compareTo(b['id'])); // untuk mengurutkan nomer 1 -5
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tittle(), // App header (tittle) ditempatkan di luar ListView
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    bottom: 1,
                  ),
                  child: Builder(
                    builder: (context) {
                      print('userData: $userData');
                      if (userData.isNotEmpty) {
                        print('User data is not empty');
                        print(
                            'UserData Roles: ${userData.map((user) => user['roleuser'])}');

                        bool isPejabatDesa = userData.any(
                                (user) => user['roleuser'] == 'pejabatdesa') ??
                            false;
                        String userName = isPejabatDesa
                            ? userData.firstWhere((user) =>
                                user['roleuser'] == 'pejabatdesa')['fullname']
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
                    '| Laporan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  child: Column(
                    children: [
                      Container(
                        // height: 550,
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
                                            top: 11,
                                            left: 8,
                                            right: 0,
                                            bottom: 0),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Back-Up',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            SizedBox(width: 10),
                                            // Export Data Button
                                            Container(
                                              width:
                                                  130, // Sesuaikan dengan lebar yang diinginkan
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  // Implement your export data logic here
                                                  await generateCSVFromAPI();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors
                                                      .black, // Ganti warna tombol sesuai kebutuhan
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  minimumSize:
                                                      Size(double.infinity, 5),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8),
                                                ),
                                                child: Text(
                                                  'Export Data',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white
                                                      // fontWeight: FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 0,
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 10, left: 10),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Tahun',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w300),
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
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all(),
                                                      ),
                                                      child: DropdownButton<String>(
                                                        dropdownColor: Colors.black,
                                                        value: selectedYear,
                                                        onChanged: (String? newValue) {
                                                          setState(() {
                                                            selectedYear = newValue!;
                                                            fetchDataWithYear(selectedYear);
                                                          });
                                                        },
                                                        underline: Container(),
                                                        icon: Image.asset(
                                                          'lib/assets/images/down-arrow.png',
                                                          width: 30,
                                                          height: 24,
                                                          color: Colors.white,
                                                        ),
                                                        padding: EdgeInsets.only(left: 20, right: 7),
                                                        items: List.generate(
                                                          DateTime.now().year - 2010 + 1,
                                                          (index) => (DateTime.now().year - index).toString(),
                                                        ).map<DropdownMenuItem<String>>(
                                                          (value) {
                                                            return DropdownMenuItem<String>(
                                                              value: value,
                                                              child: Text(
                                                                value,
                                                                style: TextStyle(color: Colors.white),
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
                                      SizedBox(
                                          // width: 10,
                                          ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 10, left: 10),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Status',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            SizedBox(width: 10),
                                            // Dropdown button
                                            Column(
                                              children: [
                                                Container(
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(),
                                                  ),
                                                  child: DropdownButton<String>(
                                                    dropdownColor: Colors.black,
                                                    value: selectedStatus,
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        selectedStatus =
                                                            newValue!;
                                                        fetchDataWithYearAndStatus(
                                                            selectedYear,
                                                            selectedStatus);
                                                      });
                                                    },
                                                    underline: Container(),
                                                    icon: Image.asset(
                                                      'lib/assets/images/down-arrow.png',
                                                      width: 30,
                                                      height: 24,
                                                      color: Colors.white,
                                                    ),
                                                    padding: EdgeInsets.only(
                                                        left: 20, right: 7),
                                                    items: <String>[
                                                      'Semua Data',
                                                      'Rencana',
                                                      'Proses',
                                                      'Selesai',
                                                    ].map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(),
                                      DataTable(
                                        columns: [
                                          DataColumn(
                                              label: Text('No',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text('Nama',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text('Tanggal Kegiatan',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text('Sumber Dana',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text('Rencana Anggaran',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text('Realisasi Anggaran',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text('Sisa Dana',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text('Status',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text('Deskripsi',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text('Hambatan',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text('Evaluasi',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                        ],
                                        rows: prokerData.map((data) {
                                          return DataRow(
                                            cells: [
                                              DataCell(
                                                  Text('${data['id'] ?? ''}')),
                                              DataCell(Text(
                                                  '${data['judul'] ?? ''}')),
                                              DataCell(Text(
                                                  '${data['tanggal'] ?? ''}')),
                                              DataCell(Text(
                                                  '${data['fundsName'] ?? ''}')),
                                              DataCell(Text(
                                                  '${data['jumlahAnggaran'] ?? ''}')),
                                              DataCell(Text(
                                                  '${data['jumlahRealisasi'] ?? ''}')),
                                              DataCell(Text(
                                                  '${data['jumlahAnggaran'] != null && data['jumlahRealisasi'] != null ? data['jumlahAnggaran'] - data['jumlahRealisasi'] : ''}')),
                                              DataCell(
                                                Container(
                                                  width: 100,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: data['status'] ==
                                                            'Selesai'
                                                        ? Color.fromARGB(
                                                            255, 176, 241, 187)
                                                        : data['status'] ==
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
                                                            color: data['status'] ==
                                                                    'Selesai'
                                                                ? Colors.green
                                                                : data['status'] ==
                                                                        'Progress'
                                                                    ? Colors
                                                                        .yellow
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
                                                          data['status'] ==
                                                                  'Progress'
                                                              ? 'Proses'
                                                              : data['status'],
                                                          style: TextStyle(
                                                            color: data['status'] ==
                                                                    'Selesai'
                                                                ? Colors.green
                                                                : data['status'] ==
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
                                              DataCell(Text(
                                                  '${data['deskripsi'] ?? 'Tidak ada deskripsi'}')),
                                              DataCell(Text(
                                                  '${data['hambatan'] ?? 'Tidak ada hambatan'}')),
                                              DataCell(Text(
                                                  '${data['evaluasi'] ?? 'Tidak ada evaluasi'}')),
                                            ],
                                          );
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
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: report(),
  ));
}
