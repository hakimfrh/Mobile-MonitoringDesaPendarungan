import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:KegiatanPendarungan/pages/login_page.dart';
import 'package:KegiatanPendarungan/pages/report.dart';
import 'package:KegiatanPendarungan/pages/sumberdana.dart';
import 'package:KegiatanPendarungan/pages/progress.dart';
import 'package:KegiatanPendarungan/pages/programkerja.dart';
import 'package:KegiatanPendarungan/pages/home_dashboard.dart';
import 'package:KegiatanPendarungan/pages/account.dart';

class MainLayout extends StatefulWidget {
  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor:
            Colors.black, // Atur warna latar belakang BottomNavigationBar
        primaryColor:
            Colors.white, // Atur warna ikon yang tidak terpilih menjadi putih
      ),
      child: Scaffold(
        bottomNavigationBar: CustomBottomNavigationBar(
          iconPaths: [
            'lib/assets/homewhite.svg',
            'lib/assets/taskwhite.svg',
            'lib/assets/progresswhite.svg',
            'lib/assets/reportwhite.svg',
            'lib/assets/moneywhite.svg',
            'lib/assets/personwhite.svg',
            'lib/assets/logoutwhite.svg',
          ],
          labels: [
            'Home',
            'Proker',
            'Progress',
            'Laporan',
            'Dana',
            'Akun',
            'Logout'
          ],
          currentIndex: currentPageIndex,
          onTap: (index) {
            if (index == 6) {
              _logout(); // Panggil fungsi _logout() jika Logout di-klik
            } else {
              setState(() {
                currentPageIndex = index;
              });
            }
          },
        ),
        body: <Widget>[
          const HomeDashboard(),
          Proker(),
          progress(),
          report(),
          const sumberdana(),
          const account(),
        ][currentPageIndex],
      ),
    );
  }

  void _logout() {
    // Implementasi fungsi logout di sini
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final List<String> iconPaths;
  final List<String> labels;
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    required this.iconPaths,
    required this.labels,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: List.generate(
        iconPaths.length,
        (index) => BottomNavigationBarItem(
          icon: SvgPicture.asset(
            iconPaths[index],
            width: 24,
            height: 24,
          ),
          label: labels[index],
        ),
      ),
      onTap: onTap,
    );
  }
}
