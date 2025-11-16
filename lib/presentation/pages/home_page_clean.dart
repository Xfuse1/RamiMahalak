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
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title:
          Text('محلك', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
      backgroundColor: AppColors.primary,
      centerTitle: true,
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSearchBar(),
          _buildCategories(),
          _buildFeaturedStores(),
          _buildRecommendedProducts(),
          _buildWelcomeSection(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(16),
      color: AppColors.primary,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'ابحث عن منتج',
          hintStyle: GoogleFonts.cairo(fontSize: 14),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none),
          prefixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
        style: GoogleFonts.cairo(),
      ),
    );
  }

  Widget _buildCategories() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('الفئات',
              style:
                  GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: ['بقالة', 'صحة', 'ملابس', 'إلكترونيات']
                    .map((cat) => Padding(
                        padding: EdgeInsets.only(right: 8),
                        child:
                            Chip(label: Text(cat, style: GoogleFonts.cairo()))))
                    .toList()),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedStores() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('متاجر مميزة',
              style:
                  GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
              child: Column(children: [
                Icon(Icons.store, size: 32, color: AppColors.primary),
                SizedBox(height: 8),
                Text('متجر مميز',
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                Text('منتجات متنوعة',
                    style: GoogleFonts.cairo(
                        fontSize: 12, color: AppColors.textLight))
              ])),
        ],
      ),
    );
  }

  Widget _buildRecommendedProducts() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('منتجات موصى بها',
              style:
                  GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
              child: Column(children: [
                Icon(Icons.star, size: 32, color: Colors.amber),
                SizedBox(height: 8),
                Text('منتج مميز',
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                Text('سعر رائع',
                    style: GoogleFonts.cairo(
                        fontSize: 12, color: AppColors.textLight))
              ])),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient:
            LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.celebration, color: Colors.white, size: 48),
          SizedBox(height: 12),
          Text('أهلاً وسهلاً',
              style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center),
          SizedBox(height: 8),
          Text('نحن هنا لخدمتك',
              style: GoogleFonts.cairo(fontSize: 14, color: Colors.white70),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      color: Color(0xFF0F1724),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text('محلك © 2025',
              style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12)),
          SizedBox(height: 8),
          Text('جميع الحقوق محفوظة',
              style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  BottomNavigationBar _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedBottomNav,
      onTap: (i) => setState(() => _selectedBottomNav = i),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'البحث'),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart), label: 'السلة'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
      ],
    );
  }
}
