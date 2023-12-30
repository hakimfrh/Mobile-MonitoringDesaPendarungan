import 'package:flutter/material.dart';
import 'package:monitoringdesa_app/Models/work_model.dart';
import 'package:monitoringdesa_app/Widgets/AppHeader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monitoringdesa_app/Models/user_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class progress extends StatefulWidget {
  progress({Key? key}) : super(key: key);

  @override
  State<progress> createState() => _progressState();
}

class _progressState extends State<progress> {
  String selectedYear = "2023";
  String searchText = '';
  List<dynamic> prokerData = [];
  late User user;
  late ProgramKerja programkerja;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    user = User(id: 0, fullname: '', email: '', password: '', roleuser: '');
    fetchDataTable().then((programKerjas) {
      setState(() {
        prokerData = programKerjas;
      });
    });
  }

// data table
  Future<List<ProgramKerja>> fetchDataTable() async {
    try {
      final response = await http
          .get(Uri.parse('https://kegiatanpendarungan.id/api/v1/proker'));
          
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['data'];

        List<dynamic> sortedResponseData = responseData
          ..sort((a, b) => a['id'].compareTo(b['id']));

        List<ProgramKerja> programKerjas = sortedResponseData
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

//data pengguna untuk login
  Future<void> fetchUserData() async {
    try {
      final response = await http
          .get(Uri.parse('https://kegiatanpendarungan.id/api/v1/users'));
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

  @override
  Widget build(BuildContext context) {
    //  FlutterStatusbarcolor.setStatusBarColor(Colors.yellow);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tittle(), // App header (tittle)
          Expanded(
            child: ListView(
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
                    '| Progress Program Kerja',
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
                                        padding:
                                            EdgeInsets.only(top: 10, left: 10),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Tahun',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w200),
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
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.black),
                                              ),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
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
                                                            child: TextField(
                                                              cursorWidth: 2,
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
                                                                setState(() {
                                                                  searchText =
                                                                      value;
                                                                });
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
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text('Nama',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text('Status',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text('Aksi',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                        ],
                                        rows: prokerData.map<DataRow>((proker) {
                                          return DataRow(
                                            cells: [
                                              DataCell(Container(
                                                  width: 50,
                                                  child: Text(
                                                      proker.id.toString()))),
                                              DataCell(Container(
                                                  width: 100,
                                                  child: Text(proker.judul))),
                                              DataCell(
                                                Container(
                                                  width: 100,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: proker.status ==
                                                            'Selesai'
                                                        ? Color.fromARGB(
                                                            255, 176, 241, 187)
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
                                                          proker.status,
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
    home: progress(),
  ));
}