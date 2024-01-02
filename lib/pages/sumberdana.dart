import 'package:flutter/material.dart';
import 'package:KegiatanPendarungan/Widgets/AppHeader.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class sumberdana extends StatefulWidget {
  const sumberdana({Key? key}) : super(key: key);

  @override
  State<sumberdana> createState() => _sumberdana();
}

class _sumberdana extends State<sumberdana> {
  List<Map<String, dynamic>> _data = [];
  late List<Map<String, dynamic>> userData;

  @override
  void initState() {
    super.initState();
    fetchData();
    userData = [];
    fetchDataUser();
  }

  Future<void> fetchData() async {
    final response = await http
        .get(Uri.parse('https://kegiatanpendarungan.id/api/v1/funds'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _data = List<Map<String, dynamic>>.from(data['data']);
        _data.sort((a, b) => a['id'].compareTo(b['id']));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  //akun
  Future<void> fetchDataUser() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 12,
            ),
            child: tittle(),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              top: 13,
            ),
            child: Builder(
              builder: (context) {
                print('userData: $userData');
                if (userData.isNotEmpty) {
                  print('User data is not empty');
                  print(
                      'UserData Roles: ${userData.map((user) => user['roleuser'])}');

                  bool isPejabatDesa = userData
                          .any((user) => user['roleuser'] == 'pejabatdesa') ??
                      false;
                  String userName = isPejabatDesa
                      ? userData.firstWhere((user) =>
                          user['roleuser'] == 'pejabatdesa')['fullname']
                      : (userData.isNotEmpty ? userData[0]['fullname'] : '');

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
              '| Master Data Pendanaan Desa',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 28, right: 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        for (var item in _data)
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30, right: 30, bottom: 30),
                                  child: Container(
                                    height: 130,
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
                                      padding: const EdgeInsets.only(
                                          top: 20, left: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Sumber Dana',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 23,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '${item['id']}.',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                '${item['nama']}',
                                                style: TextStyle(
                                                  fontSize: 20,
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
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                      ],
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
