import 'package:flutter/material.dart';
import 'package:flutter_pertemuan7/ui/login_screen.dart';
import 'package:flutter_pertemuan7/ui/register_screen.dart';
import 'package:flutter_pertemuan7/ui/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) =>  LoginScreen(),
        '/register': (context) =>  RegisterScreen(),
        '/home': (context) =>  HomeScreen(),
      },
    );
  }
}
