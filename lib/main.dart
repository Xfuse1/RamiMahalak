import 'package:flutter/material.dart';
import 'package:mahlak_nem/presentation/pages/home_page.dart';
import 'package:mahlak_nem/presentation/pages/login_page.dart';
import 'package:mahlak_nem/presentation/pages/register_page.dart';
import 'package:mahlak_nem/presentation/pages/forgot_password_page.dart';
import 'package:mahlak_nem/presentation/pages/store_page.dart';
import 'package:mahlak_nem/presentation/pages/product_page.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'محلك',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/store': (context) => StorePage.sample(),
        '/product': (context) => ProductPage.sample(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
