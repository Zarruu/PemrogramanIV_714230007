import 'package:flutter/material.dart';
import 'detail_screen.dart';
import 'main_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tempat Wisata Bandung',
      theme: ThemeData(
        useMaterial3: false
      ),
      home: const MainScreen(),
    );
  }
}

