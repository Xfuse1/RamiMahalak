import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title:
            Text('محلك', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF2A5BD9),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag, size: 64, color: Color(0xFF2A5BD9)),
            SizedBox(height: 24),
            Text(
              'أهلاً بك في محلك',
              style:
                  GoogleFonts.cairo(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'تطبيقك للتسوق الإلكتروني',
              style: GoogleFonts.cairo(fontSize: 16, color: Color(0xFF6B7280)),
            ),
            SizedBox(height: 40),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: Text('الذهاب للدخول', style: GoogleFonts.cairo()),
            ),
          ],
        ),
      ),
    );
  }
}
