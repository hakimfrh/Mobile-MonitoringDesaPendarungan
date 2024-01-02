import 'package:flutter/material.dart';
import 'package:KegiatanPendarungan/Widgets/AppHeader.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class account extends StatefulWidget {
  const account({Key? key}) : super(key: key);

  @override
  State<account> createState() => _account();
}

class _account extends State<account> {
  late List<Map<String, dynamic>> userData;

  @override
  void initState() {
    super.initState();
    userData = [];
    fetchData();
  }

//akun
  Future<void> fetchData() async {
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
              '| Manajemen Akun',
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
                      children: List.generate(userData.length, (index) {
                        final user = userData[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 30, right: 30, bottom: 30),
                          child: Container(
                            height: 170,
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
                              padding: const EdgeInsets.only(top: 20, left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Accounts',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
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
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.asset(
                                            'lib/assets/images/profile.jpeg',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user['fullname'],
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              user['roleuser'],
                                              style:
                                                  TextStyle(color: Colors.grey),
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
    );
  }
}
