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
      ),
      // Start the app on the Home page for quick preview
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/store': (context) {
          final store = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return const StorePage();
        },
        '/product': (context) {
          final product = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return const ProductPage();
        },
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
