import 'package:flutter/material.dart';
import 'package:money_manager/widgets/pemasukan.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Money Manager')),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: const Text('Tambah Pemasukan'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PemasukanScreen()));
                },
              ),
            ],
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: const [
            Text("Data Keuangan Hari ini", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Card(
              child: ListTile(
                title: Text('Pemasukan'),
                subtitle: Text('Rp. 0'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Pengeluaran'),
                subtitle: Text('Rp. 0'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Total'),
                subtitle: Text('Rp. 0'),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
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
              icon: Icon(Icons.note),
              label: 'Tentang Aplikasi',
            ),
          ],
        ));
  }
}
