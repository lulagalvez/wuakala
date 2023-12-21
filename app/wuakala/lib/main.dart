import 'package:wuakala/screens/list_wuakalas.dart';
import 'package:flutter/material.dart';
import 'package:wuakala/screens/login_screen.dart';
import 'package:wuakala/screens/sing_up_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const MyFormLogin(),
        '/signup': (context) => const MyFormSingUp(),
        '/loginSuccess': (context) => const listWuakalas(),
      },
    );
  }
}
