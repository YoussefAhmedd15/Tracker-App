import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:tracker/modules/login_page.dart';
import 'package:tracker/modules/motivation.dart';
=======
>>>>>>> a2641305b9b8c01caec731f0e68e7f4725cd39e0
import 'package:tracker/modules/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tracker App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.black,
        fontFamily: 'SF Pro Display',
        useMaterial3: true,
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
