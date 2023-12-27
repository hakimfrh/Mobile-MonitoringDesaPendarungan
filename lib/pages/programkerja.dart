import 'package:flutter/material.dart';
import 'package:monitoringdesa_app/Widgets/AppHeader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Proker extends StatefulWidget {
  Proker({Key? key}) : super(key: key);

  @override
  State<Proker> createState() => _ProkerState();
}

class _ProkerState extends State<Proker> {
  String selectedYear = "2023";
  String searchText = '';
  List<dynamic> prokerData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

// Table
  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('https://kegiatanpendarungan.id/api/v1/proker'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['data'];
        // Urutkan data berdasarkan 'id' sebelum menetapkannya ke prokerData
        responseData.sort((a, b) => a['id'].compareTo(b['id']));
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
  void showProgramKerjaDetail(BuildContext context, int prokerID) async {
    try {
      Map<String, dynamic> prokerDetails =
          await ProgramKerjaService.fetchProgramKerjaDetail(prokerID);
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
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Selamat pagi, @kepaladesa!',
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
                                                        // DetailProgramKerja(context, proker['id']);
                                                        showProgramKerjaDetail(
                                                            context,
                                                            proker['id']);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Dialog(
        // Custom styling untuk dialog
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: SingleChildScrollView(
            child: SizedBox(
              // width: MediaQuery.of(context).size.width * 1.0,
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    buildDetailText(
                        'Status Program Kerja', prokerDetails['status']),
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
                            // background color of button
                            primary: Colors.white,
                          ),
                          child: Text(
                            'Tutup',
                            style: TextStyle(
                              color:
                                  Colors.black, // Set warna teks menjadi hitam
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
      ),
    );
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
}

void main() {
  runApp(MaterialApp(
    home: Proker(),
  ));
}
