import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monitoringdesa_app/Widgets/BottomNavigationBar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _loginButtonPressed() async {
    // Mengambil data dari controller
    String userEmail = _emailController.text;
    String userPassword = _passwordController.text;

    try {
      // Melakukan pemanggilan API untuk operasi login
      final response = await http
          .get(Uri.parse('https://kegiatanpendarungan.id/api/v1/users/'));

      // Memeriksa respons dari API
      if (response.statusCode == 200) {
        bool isLogin = false;
        Map<String, dynamic> responseData = json.decode(response.body);
        responseData['data'].forEach((user) => {
              if (user['email'] == userEmail &&
                  BCrypt.checkpw(userPassword, user['password']))
                {isLogin = true}
            });

        if (isLogin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainLayout()),
          );
        } else {
          // Jika login gagal, tampilkan pesan kesalahan
          _showErrorDialog(
            'Login Gagal',
            'Email atau password salah. Silakan coba lagi.',
          );
        }
      } else {
        // Jika respons API tidak berhasil, tampilkan pesan kesalahan dan status code
        print('Error Status Code: ${response.statusCode}');
        print('Error Response: ${response.body}');
        _showErrorDialog('Error', 'Terjadi kesalahan. Silakan coba lagi.');
      }
    } catch (e) {
      // Tangkap error jika terjadi kesalahan dalam pemanggilan API
      print('Error: $e');
      _showErrorDialog('Error', 'Terjadi kesalahan. Silakan coba lagi.');
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 38,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      'Selamat Datang!',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontFamily: 'Poppies',
                        fontSize: 27,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      'Silahkan Masuk dengan Akun Anda...',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                // Form Email
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Email',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            " *",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan email anda...',
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black), // Warna outline hitam
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),// Warna outline hitam
                            borderRadius: BorderRadius.circular(12),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                // Form Password
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Password',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            " *",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Masukkan password anda..',
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black), // Warna outline hitam
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black), // Warna outline hitam
                            borderRadius: BorderRadius.circular(12),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          suffixIcon: InkWell(
                            onTap: _togglePasswordVisibility,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SvgPicture.asset(
                                _isPasswordVisible
                                    ? 'lib/assets/open.svg' // Ganti dengan path file SVG mata terbuka
                                    : 'lib/assets/closed.svg', // Ganti dengan path file SVG mata tertutup
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                // Tombol Login
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: ElevatedButton(
                    onPressed: _loginButtonPressed,
                    style: ElevatedButton.styleFrom(
                      primary: Colors
                          .black, // Mengubah warna background tombol menjadi hitam
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Container(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'Masuk Sekarang',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}