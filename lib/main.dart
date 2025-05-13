import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/Ex_pages/userlogin.dart';
import 'package:untitled1/Int_pages/home.dart';
import 'package:untitled1/Int_pages/profile.dart';
import 'package:untitled1/Int_pages/contact.dart';
import 'package:untitled1/Int_pages/about.dart';
import 'package:untitled1/Ex_pages/policelogin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const LoginPageApp());
}

class LoginPageApp extends StatelessWidget {
  const LoginPageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/contact': (context) => const ContactScreen(),
        '/about': (context) => const AboutScreen(),
        '/policelogin': (context) => const PoliceLoginApp(),
      },
    );
  }
}
