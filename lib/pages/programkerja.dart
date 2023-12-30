import 'package:flutter/material.dart';
import 'package:monitoringdesa_app/Widgets/AppHeader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:monitoringdesa_app/Models/user_model.dart';

class Proker extends StatefulWidget {
  Proker({Key? key}) : super(key: key);

  @override
  State<Proker> createState() => _ProkerState();
}

class _ProkerState extends State<Proker> {
  String selectedYear = "2023";
  String searchText = '';
  List<dynamic> prokerData = [];
    late User user;

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchUserData();
    user = User(id: 0, fullname: '', email: '', password: '', roleuser: '');
  }

//data pengguna untuk login
Future<void> fetchUserData() async {
  try {
    final response = await http.get(Uri.parse('https://kegiatanpendarungan.id/api/v1/users'));
    if (response.statusCode == 200) {
      final List<dynamic> userData = json.decode(response.body)['data'];
      final Map<String, dynamic> currentUserData = userData.firstWhere(
        (user) => user['roleuser'] == 'pejabatdesa',
      );

      print('Data Pengguna: $currentUserData');

      setState(() {
        user = User.fromJson(currentUserData);
      });
    } else {
      throw Exception('Gagal mengambil data pengguna');
    }
  } catch (error) {
    print('Error fetching user data: $error');
  }
}

// data untuk Table
  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('https://kegiatanpendarungan.id/api/v1/proker'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['data'];
        // Urutkan data berdasarkan 'id' sebelum menetapkannya ke prokerData
        responseData.sort((a, b) => a['id'].compareTo(b['id']));

        // Pastikan setiap objek proker memiliki atribut 'status'
        responseData.forEach((proker) {
          if (!proker.containsKey('status')) {
            proker['status'] = 'Undefined';
          }
        });

        setState(() {
          prokerData = responseData;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

// data untuk filter
  Future<void> fetchDataWithYear(String year) async {
    try {
      final response = await http
          .get(Uri.parse('https://kegiatanpendarungan.id/api/v1/proker'));
      if (response.statusCode == 200) {
        setState(() {
          List<dynamic> responseData = json.decode(response.body)['data'];
          prokerData = responseData
              .where((proker) =>
                  proker['tahunAnggaran'].toString() ==
                  year) // Filter data berdasarkan tahun yang dipilih
              .toList();
        });
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
            prokerData = responseData.where((proker) {
              return proker['judul']
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase());
            }).toList();
          } else {
            // Jika tidak ada teks pencarian, tampilkan semua data
            prokerData = responseData;
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
          tittle(), // App header
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top:24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'Selamat pagi, ${user.fullname}!',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 16),
                      child: Text(
                        '| Program Kerja',
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

                                                            fetchDataWithYear(
                                                                selectedYear);
                                                          });
                                                        },
                                                        underline: Container(),
                                                        icon: Image.asset(
                                                          'lib/assets/images/down-arrow.png', // Gantilah dengan nama dan ekstensi gambar yang sesuai
                                                          width: 30,
                                                          height: 24,
                                                          color: Colors.white,
                                                        ),
                                                        // alignment: Alignment.bottomCenter,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20,
                                                                right: 7),
                                                        items: List.generate(
                                                                14,
                                                                (index) =>
                                                                    2023 -
                                                                    index) // Generate tahun dari 2023 hingga 2010
                                                            .map<
                                                                    DropdownMenuItem<
                                                                        String>>(
                                                                (value) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: value
                                                                .toString(),
                                                            child: Text(
                                                              value.toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
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
                                                                    fetchDataSearching(); // Panggil fungsi pencarian setiap kali teks berubah
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
                                                label: Text(
                                                  'No',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Nama',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Tanggal Kegiatan',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Sumber Dana',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'Aksi',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                            rows: prokerData
                                                .map<DataRow>((proker) {
                                              return DataRow(
                                                cells: [
                                                  DataCell(Text(
                                                      proker['id'].toString())),
                                                  DataCell(
                                                      Text(proker['judul'])),
                                                  DataCell(
                                                      Text(proker['tanggal'])),
                                                  DataCell(Text(
                                                      proker['fundsName'] ??
                                                          'Unknown')),
                                                  DataCell(
                                                    InkWell(
                                                      onTap: () {
                                                        showProgramKerjaDetail(
                                                            context, proker);
                                                      },
                                                      child: SvgPicture.asset(
                                                        'lib/assets/open.svg',
                                                        height: 24,
                                                      ),
                                                    ),
                                                  ),
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
      backgroundColor = Color.fromARGB(255, 219, 236, 174);
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
      // Pisahkan URL dengan koma dan titik koma (asumsi beberapa URL dipisahkan dengan koma dan titik koma)
      List<String> imageUrls =
          value.split(RegExp(r'[;,]')).map((e) => e.trim()).toList();

      // Ganti base URL dengan sesuai struktur API
      String baseUrl = 'https://kegiatanpendarungan.id/api/v1/proker/';

      // Tambahkan URL dasar API
      List<Widget> imageWidgets = imageUrls
          .map(
            (url) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Image.network(
                baseUrl + url,
                width: 200, // Sesuaikan lebar sesuai kebutuhan
                height: 200, // Sesuaikan tinggi sesuai kebutuhan
                fit: BoxFit.cover,
              ),
            ),
          )
          .toList();

      // Kembalikan kolom gambar
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          // Tampilkan gambar
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
    home: Proker(),
  ));
}