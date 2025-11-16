import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'محلك - الصفحة الرئيسية',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF2A5BD9),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Text(
                '🎉 أهلاً وسهلاً بك في محلك',
                style: GoogleFonts.cairo(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'تطبيقك الموثوق للتسوق الإلكتروني',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(Icons.shopping_bag,
                        size: 48, color: Color(0xFF2A5BD9)),
                    SizedBox(height: 16),
                    Text(
                      'الفئات المتاحة',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Chip(
                          avatar: Icon(Icons.shopping_basket, size: 18),
                          label: Text('بقالة', style: GoogleFonts.cairo()),
                          backgroundColor: Color(0xFFE3F2FD),
                        ),
                        SizedBox(width: 8),
                        Chip(
                          avatar: Icon(Icons.health_and_safety, size: 18),
                          label: Text('صحة', style: GoogleFonts.cairo()),
                          backgroundColor: Color(0xFFE3F2FD),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Chip(
                          avatar: Icon(Icons.checkroom, size: 18),
                          label: Text('ملابس', style: GoogleFonts.cairo()),
                          backgroundColor: Color(0xFFE3F2FD),
                        ),
                        SizedBox(width: 8),
                        Chip(
                          avatar: Icon(Icons.devices, size: 18),
                          label: Text('إلكترونيات', style: GoogleFonts.cairo()),
                          backgroundColor: Color(0xFFE3F2FD),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                icon: Icon(Icons.logout),
                label: Text('الذهاب لصفحة الدخول'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2A5BD9),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
