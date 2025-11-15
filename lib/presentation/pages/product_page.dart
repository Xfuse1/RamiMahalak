import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahlak_nem/presentation/pages/app_colors.dart';

class ProductPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductPage({super.key, required this.product});

  // Dummy data for similar products
  static final List<Map<String, dynamic>> similarProducts = [
    {
      'name': 'منتج مشابه 1',
      'price': '30 ج.م',
      'image': 'assets/images/product2.jpg'
    },
    {
      'name': 'منتج مشابه 2',
      'price': '45 ج.م',
      'image': 'assets/images/store1.jpg'
    },
    {
      'name': 'منتج مشابه 3',
      'price': '15 ج.م',
      'image': 'assets/images/store2.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(product['name'],
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.text,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Image.asset(
              product['image'],
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product['name'],
                    style: GoogleFonts.cairo(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Product Price
                  Text(
                    product['price'],
                    style: GoogleFonts.cairo(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Rating
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(width: 4),
                      Text(
                        '${product['rating']} (${product['reviews']} تقييم)',
                        style: GoogleFonts.cairo(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Divider(height: 32, thickness: 1),

                  // Delivery Info Suggestion
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.delivery_dining,
                            color: AppColors.primary, size: 28),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'خدمة التوصيل السريع متاحة لهذا المنتج!',
                            style: GoogleFonts.cairo(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 32, thickness: 1),

                  // Product Details
                  Text(
                    'التفاصيل',
                    style: GoogleFonts.cairo(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى.',
                    style: GoogleFonts.cairo(
                        fontSize: 14, color: AppColors.textLight, height: 1.6),
                  ),
                  SizedBox(height: 24),

                  // Similar Products
                  Text(
                    'منتجات مشابهة',
                    style: GoogleFonts.cairo(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: similarProducts.length,
                      itemBuilder: (context, index) {
                        final similar = similarProducts[index];
                        return SizedBox(
                          width: 140,
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                Expanded(
                                    child: Image.asset(similar['image'],
                                        fit: BoxFit.cover,
                                        width: double.infinity)),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(similar['name'],
                                      maxLines: 1,
                                      style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Action Bar
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: Offset(0, -2))
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.add_shopping_cart),
                label: Text('أضف إلى السلة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  textStyle: GoogleFonts.cairo(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(width: 12),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.chat_bubble_outline, color: Color(0xFF25D366)),
              iconSize: 28,
            ),
          ],
        ),
      ),
    );
  }
}
