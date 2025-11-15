import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mahlak_nem/presentation/pages/home_page.dart';
import 'package:mahlak_nem/presentation/pages/login_page.dart';
import 'package:mahlak_nem/presentation/pages/register_page.dart';
import 'package:mahlak_nem/presentation/pages/forgot_password_page.dart';
import 'package:mahlak_nem/presentation/pages/store_page.dart';
import 'package:mahlak_nem/presentation/pages/product_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

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
          return StorePage(store: store);
        },
        '/product': (context) {
          final product = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return ProductPage(product: product);
        },
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
