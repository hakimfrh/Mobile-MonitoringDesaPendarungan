import 'package:flutter/material.dart';
import 'package:monitoringdesa_app/Widgets/AppHeader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monitoringdesa_app/Models/work_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class report extends StatefulWidget {
  report({Key? key}) : super(key: key);

  @override
  State<report> createState() => _reportState();
}

class _reportState extends State<report> {
  String selectedYear = "2023";
  String searchText = '';
  String selectedStatus = 'Semua Data';
  late List<ProgramKerja> prokerData;

  @override
  @override
  void initState() {
    super.initState();
    prokerData = [];
    fetchDataTable().then((programKerjas) {
      setState(() {
        prokerData = programKerjas;
      });
    });
  }

   Future<List<ProgramKerja>> fetchDataTable() async {
    try {
      final response = await http.get(
        Uri.parse('https://kegiatanpendarungan.id/api/v1/proker'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['data'];

        List<ProgramKerja> programKerjas = responseData
            .map((programJson) => ProgramKerja.fromJson(programJson))
            .toList();

        return programKerjas;
      } else {
        throw Exception('Gagal memuat data');
      }
    } catch (error) {
      print('Error fetching data: $error');
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tittle(), // App header (tittle) ditempatkan di luar ListView
          Expanded(
            child: ListView(
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
                                                onPressed: () {
                                                  // Implement your export data logic here
                                                  print(
                                                      'Export Data Button Pressed');
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
                                                  // width: ,
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
                                                    value: selectedYear,
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        selectedYear =
                                                            newValue!;
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
                                                    padding: EdgeInsets.only(
                                                        left: 20, right: 7),
                                                    items: <String>[
                                                      '2023',
                                                      '2022',
                                                      '2021',
                                                      '2020',
                                                      '2019',
                                                      '2018',
                                                      '2017',
                                                      '2016',
                                                      '2015',
                                                      '2014',
                                                      '2013',
                                                      '2012',
                                                      '2011',
                                                      '2010',
                                                      /* Add more years as needed */
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
                                            label: Text(
                                              'No',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Nama',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Tanggal Kegiatan',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Sumber Dana',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Rencana Anggaran',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Realisasi Anggaran',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Sisa Dana',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Status',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Deskripsi',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Hambatan',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Evaluasi',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Aksi',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                        rows: [
                                          DataRow(
                                            cells: [
                                              DataCell(Container(
                                                width: 50,
                                                child: Text('1'),
                                              )),
                                              DataCell(Container(
                                                width: 100,
                                                child: Text('John Doe'),
                                              )),
                                              DataCell(Container(
                                                width: 150,
                                                child: Text('2023-12-12'),
                                              )),
                                              DataCell(Container(
                                                width: 100,
                                                child: Text('Dana Umum'),
                                              )),
                                              DataCell(Container(
                                                width: 100,
                                                child: Text('Rencana 1'),
                                              )),
                                              DataCell(Container(
                                                width: 100,
                                                child: Text('Realisasi 1'),
                                              )),
                                              DataCell(Container(
                                                width: 100,
                                                child: Text('Sisa 1'),
                                              )),
                                              DataCell(
                                                Container(
                                                  width: 100,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 176, 241, 187),
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
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          'Finish',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(Container(
                                                width: 100,
                                                child: Text('Deskripsi 1'),
                                              )),
                                              DataCell(Container(
                                                width: 100,
                                                child: Text('Hambatan 1'),
                                              )),
                                              DataCell(Container(
                                                width: 100,
                                                child: Text('Evaluasi 1'),
                                              )),
                                              DataCell(
                                                Container(
                                                  width: 100,
                                                  child: InkWell(
                                                    onTap: () {
                                                      // Aksi yang dijalankan saat tombol di-klik
                                                    },
                                                    child: SvgPicture.asset(
                                                      'lib/assets/open.svg',
                                                      height: 24,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          DataRow(
                                            cells: [
                                              DataCell(Container(
                                                width: 50,
                                                child: Text('2'),
                                              )),
                                              DataCell(Container(
                                                width: 100,
                                                child: Text('PP'),
                                              )),
                                              DataCell(Container(
                                                width: 150,
                                                child: Text('2023-12-12'),
                                              )),
                                              DataCell(Container(
                                                width: 100,
                                                child: Text('APBN'),
                                              )),
                                              DataCell(Container(
                                                width: 100,
                                                child: Text('Rencana 2'),
                                              )),
                                              DataCell(Container(
                                                width: 100,
                                                child: Text('Realisasi 2'),
                                              )),
                                              DataCell(Container(
                                                width: 100,
                                                child: Text('Sisa 2'),
                                              )),
                                              DataCell(
                                                Container(
                                                  width: 100,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 200, 214, 155),
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
                                                            color:
                                                                Colors.yellow,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          'Proses',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .yellow),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(Container(
                                                width: 100,
                                                child: Text('Deskripsi 2'),
                                              )),
                                              DataCell(Container(
                                                width: 100,
                                                child: Text('Hambatan 2'),
                                              )),
                                              DataCell(Container(
                                                width: 100,
                                                child: Text('Evaluasi 2'),
                                              )),
                                              DataCell(
                                                Container(
                                                  width: 100,
                                                  child: InkWell(
                                                    onTap: () {
                                                      // Aksi yang dijalankan saat tombol di-klik
                                                    },
                                                    child: SvgPicture.asset(
                                                      'lib/assets/open.svg',
                                                      height: 24,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
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