import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF2A5BD9);
  static const Color primaryDark = Color(0xFF1F4BA3);
  static const Color secondary = Color(0xFFFF6B35);
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Colors.white;
  static const Color text = Color(0xFF1F2937);
  static const Color textLight = Color(0xFF6B7280);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedBottomNav = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'محلك',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // شريط البحث
            Container(
              padding: EdgeInsets.all(16),
              color: AppColors.primary,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'ابحث عن منتج...',
                  hintStyle: GoogleFonts.cairo(fontSize: 14),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(height: 24),

            // الفئات
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الفئات',
                    style: GoogleFonts.cairo(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryCard('🛒 بقالة'),
                        SizedBox(width: 12),
                        _buildCategoryCard('💊 صحة'),
                        SizedBox(width: 12),
                        _buildCategoryCard('👕 ملابس'),
                        SizedBox(width: 12),
                        _buildCategoryCard('📱 إلكترونيات'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // المتاجر المميزة
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'متاجر مميزة',
                    style: GoogleFonts.cairo(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4)
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.store, size: 32, color: AppColors.primary),
                        SizedBox(height: 8),
                        Text('متجر 1',
                            style:
                                GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                        Text('منتجات متنوعة',
                            style: GoogleFonts.cairo(
                                fontSize: 12, color: AppColors.textLight)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // منتجات موصى بها
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'منتجات موصى بها',
                    style: GoogleFonts.cairo(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4)
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.star, size: 32, color: Colors.amber),
                        SizedBox(height: 8),
                        Text('منتج مميز',
                            style:
                                GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                        Text('سعر رائع',
                            style: GoogleFonts.cairo(
                                fontSize: 12, color: AppColors.textLight)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomNav,
        onTap: (index) {
          setState(() => _selectedBottomNav = index);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'البحث'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'السلة'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Text(label,
          style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }
}
