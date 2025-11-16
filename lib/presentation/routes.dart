import 'package:flutter/material.dart';
import 'package:mahlak_nem/presentation/pages/login_page.dart';
import 'package:mahlak_nem/presentation/pages/register_page.dart';

Map<String, WidgetBuilder> appRoutes = {
  '/login': (context) => const LoginPage(),
  '/register': (context) => const RegisterPage(),
};
