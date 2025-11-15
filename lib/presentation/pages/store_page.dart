import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahlak_nem/presentation/pages/app_colors.dart';

class StorePage extends StatelessWidget {
  final Map<String, dynamic> store;

  const StorePage({super.key, required this.store});

  // Dummy data for products in this store
  static final List<Map<String, dynamic>> storeProducts = [
    {
      'name': 'ذرة بلدي طازج',
      'rating': 4.9,
      'reviews': 342,
      'price': '25 ج.م',
      'image': 'assets/images/product1.jpg'
    },
    {
      'name': 'حليب طازج عضوي',
      'rating': 4.8,
      'reviews': 156,
      'price': '25 ج.م',
      'image': 'assets/images/product1.jpg'
    },
    {
      'name': 'منتج آخر',
      'rating': 4.5,
      'reviews': 98,
      'price': '50 ج.م',
      'image': 'assets/images/product2.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(store['name'],
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.text,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store Header Image
            Image.asset(
              store['image'],
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Store Name and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          store['name'],
                          style: GoogleFonts.cairo(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          SizedBox(width: 4),
                          Text(
                            '${store['rating']} (${store['reviews']} تقييم)',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Map Placeholder
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.divider,
                      image: DecorationImage(
                        image: AssetImage('assets/images/map_placeholder.png'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withValues(alpha: 0.4), BlendMode.darken),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map, color: Colors.white, size: 40),
                          SizedBox(height: 8),
                          Text(
                            'عرض الخريطة',
                            style: GoogleFonts.cairo(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // WhatsApp Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.chat_bubble_outline, size: 20),
                      label: Text('تواصل مع المتجر عبر واتساب'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF25D366), // WhatsApp Green
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        textStyle: GoogleFonts.cairo(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Products Section
                  Text(
                    'منتجات المتجر',
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: storeProducts.length,
                    itemBuilder: (context, index) {
                      final product = storeProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/product',
                              arguments: product);
                        },
                        child: Card(
                          elevation: 2,
                          shadowColor: Colors.black.withValues(alpha: 0.1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12)),
                                  child: Image.asset(product['image'],
                                      width: double.infinity,
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product['name'],
                                  style: GoogleFonts.cairo(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  product['price'],
                                  style: GoogleFonts.cairo(
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
