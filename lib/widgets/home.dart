import 'package:flutter/material.dart';
import 'package:money_manager/widgets/about.dart';
import 'package:money_manager/widgets/laporan.dart';
import 'package:money_manager/widgets/pemasukan.dart';
import 'package:money_manager/widgets/pengeluaran.dart';
import 'package:money_manager/widgets/transactions.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int indexMenu = 0;

  final List<Widget> screens = [
    const ShowTransactions(),
    const LaporanScreen(),
    const AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Money Manager')),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Money Manager',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      'v1.0.0',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.add_circle_outline_outlined),
                title: const Text('Tambah Pemasukan'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PemasukanScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove_circle_outline_outlined),
                title: const Text('Tambah Pengeluaran'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PengeluaraanScreen()));
                },
              ),
            ],
          ),
        ),
        body: screens[indexMenu],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: indexMenu,
          onTap: (int index) {
            setState(() {
              indexMenu = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.note),
              label: 'Laporan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'Tentang Aplikasi',
            ),
          ],
        ));
  }
}
