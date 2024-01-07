import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/logo.png', width: 200),
          const Text('About Money Manager', style: TextStyle(fontSize: 24)),
          const Text('Money Manager'),
          const Text('Version 1.0.0'),
          const SizedBox(height: 20),
          const Text('Developed by:'),
          const Text('Siti Aisyah'),
          const Text('Desi Anggita Fitriyani'),
          const Text('Laela Efendi'),
          const Text('Ajeng Helmania'),
        ],
      ),
    );
  }
}
