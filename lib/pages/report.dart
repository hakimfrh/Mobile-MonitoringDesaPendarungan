import 'package:flutter/material.dart';
import 'package:monitoringdesa_app/Widgets/AppHeader.dart';
// import 'package:monitoringdesa_app/pages/login_page.dart';
// import 'package:monitoringdesa_app/widgets/BottomNavigationBar.dart';

class report extends StatefulWidget {
  const report({Key? key}) : super(key: key);

  @override
  State<report> createState() => _reportState();
}

class _reportState extends State<report> {
  // int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(),
            child:
                tittle(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20,),
            child: Text(
              'selamat pagi, @admin!',
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
          
        ],
      ),
      // bottomNavigationBar: BottomNavigationBarWidget(
      //   currentIndex: _currentIndex,
      //   onTabTapped: (index) {
      //     setState(() {
      //       _currentIndex = index;
      //       if (index == 6) {
      //         _logout();
      //       }
      //     });
      //   },
      // ),
    );
  }

  // void _logout() {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => LoginPage()),
  //   );
  // }
}