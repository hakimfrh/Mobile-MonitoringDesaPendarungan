import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:KegiatanPendarungan/Widgets/AppHeader.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);
  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  late List<Map<String, dynamic>> userData;
  late int currentYear = DateTime.now().year;
  late List<Map<String, dynamic>> programData = [];
  num totalAnggaran = 0;
  num totalRealisasi = 0;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    userData = [];
    fetchData();
    fetchDataDana();
    fetchDataStatistik();
  }

  //data statistik desa
  Future<void> fetchDataStatistik() async {
    final response = await http
        .get(Uri.parse('https://kegiatanpendarungan.id/api/v1/proker'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        programData = jsonData['data'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

// Kalkulasi untuk mendapatkan data statistik desa
  double calculateProgress(String status) {
    int total = programData.length;
    int count = programData
        .where((program) => program['status'] == status)
        .toList()
        .length;
    double progress = total > 0 ? count / total.toDouble() : 0.0;
    return progress > 0 ? progress : 0;
  }

  //fungsi jumlah,realisasi, sisa dana
  Future<void> fetchDataDana() async {
  try {
    final response = await http.get(Uri.parse('https://kegiatanpendarungan.id/api/v1/proker'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];

      // Filter data untuk tahun saat ini (currentYear)
      final List<dynamic> currentYearData = responseData
          .where((proker) => proker['tahunAnggaran'] == currentYear)
          .toList();

      if (!mounted) return;
      setState(() {
        totalAnggaran = currentYearData.fold<num>(
            0, (sum, proker) => sum + proker['jumlahAnggaran']);
        totalRealisasi = currentYearData.fold<num>(
            0, (sum, proker) => sum + proker['jumlahRealisasi']);
      });
    } else {
      throw Exception('Failed to load data');
    }
  } catch (error) {
    print('Error fetching data: $error');
  }
}


  // untuk akun pengguna
  Future<void> fetchUserData() async {
    try {
      final response = await http
          .get(Uri.parse('https://kegiatanpendarungan.id/api/v1/users'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (!mounted) return;
        setState(() {
          userData = List<Map<String, dynamic>>.from(data['data']);
        });
        bool isPejabatDesa =
            userData.any((user) => user['roleuser'] == 'pejabatdesa') ?? false;
        String userName = isPejabatDesa
            ? userData.firstWhere(
                (user) => user['roleuser'] == 'pejabatdesa')['fullname']
            : (userData.isNotEmpty ? userData[0]['fullname'] : '');
        if (isPejabatDesa) {
          print('User has role pejabatdesa');
          print('Selamat pagi, @$userName!');
        } else {
          print('User role is not pejabatdesa');
        }
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

// pengguna role user
  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('https://kegiatanpendarungan.id/api/v1/users'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (!mounted) return;
        setState(() {
          userData = List<Map<String, dynamic>>.from(data['data']);
        });
        bool isPejabatDesa =
            userData.any((user) => user['roleuser'] == 'pejabatdesa') ?? false;
        String userName = isPejabatDesa
            ? userData.firstWhere(
                (user) => user['roleuser'] == 'pejabatdesa')['fullname']
            : (userData.isNotEmpty ? userData[0]['fullname'] : '');
        if (isPejabatDesa) {
          print('User has role pejabatdesa');
          print('Selamat pagi, @$userName!');
        } else {
          print('User role is not pejabatdesa');
        }
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tittle(), // Navbar atas

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 0,
                        top: 5,
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
                      padding: const EdgeInsets.only(top: 15, bottom: 10),
                      child: Text(
                        '| Dashboard',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      'Dana Desa Pendarungan $currentYear',
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: Container(
                                  height: 70,
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
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'lib/assets/jumlah.svg',
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Jumlah Dana',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              Text(
                                            'Rp ${(totalAnggaran - totalRealisasi).toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: Container(
                                  height: 70,
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
                                    padding: const EdgeInsets.only(left: 11),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'lib/assets/realisasi.svg',
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Realisasi Dana',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              Text(
                                               'Rp ${(totalAnggaran - totalRealisasi).toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: Container(
                                  height: 70,
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
                                    padding: const EdgeInsets.only(left: 22),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'lib/assets/sumber.svg',
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Sisa Dana',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              Text(
                                              'Rp ${(totalAnggaran - totalRealisasi).toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 40, right: 30),
                                child: Container(
                                  height: 350,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white10),
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
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Statistik Desa',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          'Program Kerja',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(height: 13),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 45),
                                          child: LinearPercentIndicator(
                                            leading: Text(
                                              programData.length.toString(),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            lineHeight: 15,
                                            percent: 0,
                                            progressColor: Colors.blue,
                                            backgroundColor: Color.fromARGB(
                                                64, 158, 158, 158),
                                            barRadius: Radius.circular(10),
                                          ),
                                        ),
                                        SizedBox(height: 13),
                                        Text(
                                          'Progress Program Kerja',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(height: 13),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 45),
                                          child: LinearPercentIndicator(
                                            leading: Text(
                                              calculateProgress('Progress')
                                                          .toString() ==
                                                      '0.0'
                                                  ? '0'
                                                  : calculateProgress(
                                                          'Progress')
                                                      .toStringAsFixed(1),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            lineHeight: 15,
                                            percent:
                                                calculateProgress('Progress'),
                                            progressColor: Colors.orange,
                                            backgroundColor: Color.fromARGB(
                                                64, 158, 158, 158),
                                            barRadius: Radius.circular(10),
                                          ),
                                        ),
                                        SizedBox(height: 13),
                                        Text(
                                          'Program Kerja Selesai',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(height: 13),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 45),
                                          child: LinearPercentIndicator(
                                            leading: Text(
                                              calculateProgress('Selesai')
                                                          .toString() ==
                                                      '0.0'
                                                  ? '0'
                                                  : calculateProgress('Selesai')
                                                      .toStringAsFixed(1),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            lineHeight: 15,
                                            percent:
                                                calculateProgress('Selesai'),
                                            progressColor: Colors.orange,
                                            backgroundColor: Color.fromARGB(
                                                64, 158, 158, 158),
                                            barRadius: Radius.circular(10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 0, right: 0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: List.generate(userData.length,
                                            (index) {
                                          final user = userData[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                top: 30, right: 30, bottom: 30),
                                            child: Container(
                                              height: 170,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white10),
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                                                padding: const EdgeInsets.only(
                                                    top: 20, left: 20),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Accounts',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 23,
                                                    ),
                                                    Row(
                                                      children: [
                                                        ClipOval(
                                                          child: Container(
                                                            width: 60,
                                                            height: 60,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: Image.asset(
                                                              'lib/assets/images/profile.jpeg',
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 20),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                user[
                                                                    'fullname'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                              Text(
                                                                user[
                                                                    'roleuser'],
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, right: 30, bottom: 20),
                              child: Container(
                                height: 515,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white10),
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
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 20,
                                                bottom: 0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.asset(
                                                'lib/assets/images/gambarpendarungan.jpeg',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 20,
                                                bottom: 0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.asset(
                                                'lib/assets/images/gambarpendarungan.jpeg',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 20,
                                                bottom: 0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.asset(
                                                'lib/assets/images/gambarpendarungan.jpeg',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        ),
                      ],
                    )
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