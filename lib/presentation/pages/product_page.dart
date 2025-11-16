import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class SimilarProduct {
  final String name;
  final String imageUrl;
  final double price;

  SimilarProduct({
    required this.name,
    required this.imageUrl,
    required this.price,
  });
}

class ProductPage extends StatefulWidget {
  // ألوان موحّدة مع هوية التطبيق
  static const Color primaryColor = Color(0xFF8B5CF6); // بنفسجي
  static const Color accentColor = Color(0xFFFF6B3D); // أورانج
  static const Color backgroundColor = Color(0xFFF6F7FB);

  final String productName;
  final String storeName;
  final List<String> images;
  final double price;
  final String unit;
  final double rating;
  final int ratingCount;
  final String description;
  final String storeWhatsappNumber; // 201xxxxxxxxx
  final List<SimilarProduct> similarProducts;

  const ProductPage({
    super.key,
    required this.productName,
    required this.storeName,
    required this.images,
    required this.price,
    required this.unit,
    required this.rating,
    required this.ratingCount,
    required this.description,
    required this.storeWhatsappNumber,
    required this.similarProducts,
  });

  /// صفحة منتج جاهزة للتجربة
  factory ProductPage.sample() {
    return ProductPage(
      productName: 'زيت ذرة 1 لتر',
      storeName: 'سوبر ماركت المحلة',
      images: const [
        'https://images.pexels.com/photos/5632371/pexels-photo-5632371.jpeg',
        'https://images.pexels.com/photos/7509521/pexels-photo-7509521.jpeg',
        'https://images.pexels.com/photos/4109942/pexels-photo-4109942.jpeg',
      ],
      price: 85,
      unit: 'زجاجة',
      rating: 4.6,
      ratingCount: 128,
      description:
          'زيت ذرة نقي 100٪، مناسب للطبخ والقلي، بخاصية امتصاص أقل للدهون، معتمد صحياً ومناسب للاستخدام اليومي.',
      storeWhatsappNumber: '201234567890',
      similarProducts: [
        SimilarProduct(
          name: 'زيت دوار الشمس 1 لتر',
          imageUrl:
              'https://images.pexels.com/photos/7509521/pexels-photo-7509521.jpeg',
          price: 90,
        ),
        SimilarProduct(
          name: 'زيت خليط 1.5 لتر',
          imageUrl:
              'https://images.pexels.com/photos/4109951/pexels-photo-4109951.jpeg',
          price: 120,
        ),
        SimilarProduct(
          name: 'زيت زيتون 500 مل',
          imageUrl:
              'https://images.pexels.com/photos/143133/pexels-photo-143133.jpeg',
          price: 180,
        ),
      ],
    );
  }

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantity = 1;
  int currentImageIndex = 0;

  final List<String> deliveryOptions = const [
    'دليفري عادي (خلال 60 دقيقة)',
    'دليفري سريع (خلال 30 دقيقة)',
    'استلام من المتجر',
  ];

  late String selectedDelivery;

  @override
  void initState() {
    super.initState();
    selectedDelivery = deliveryOptions.first;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ProductPage.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildImagesHeader(context),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitleAndStore(),
                            const SizedBox(height: 12),
                            _buildRatingRow(),
                            const SizedBox(height: 16),
                            _buildPriceAndQuantity(),
                            const SizedBox(height: 20),
                            _buildDeliverySelector(),
                            const SizedBox(height: 20),
                            _buildDescription(),
                            const SizedBox(height: 24),
                            _buildSimilarProducts(),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(context),
            ],
          ),
        ),
      ),
    );
  }

  // ================== الهيدر + سلايدر الصور ==================

  Widget _buildImagesHeader(BuildContext context) {
    final images = widget.images.isEmpty
        ? ['https://images.pexels.com/photos/5632371/pexels-photo-5632371.jpeg']
        : widget.images;

    return Stack(
      children: [
        SizedBox(
          height: 280,
          width: double.infinity,
          child: PageView.builder(
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() => currentImageIndex = index);
            },
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                child: CachedNetworkImage(
                  imageUrl: images[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: const Color(0xFFE0E0E0),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: const Color(0xFFE0E0E0),
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00000000),
                    Color(0x99000000),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 12,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _circleIconButton(
                icon: Icons.arrow_back_rounded,
                onTap: () => Navigator.of(context).pop(),
              ),
              Row(
                children: [
                  _circleIconButton(
                    icon: Icons.share_rounded,
                    onTap: () {},
                  ),
                  const SizedBox(width: 8),
                  _circleIconButton(
                    icon: Icons.favorite_border_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (index) {
              final isActive = index == currentImageIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 18 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : const Color(0x88FFFFFF),
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0x66000000),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }

  // ================== العنوان + المتجر + التقييم ==================

  Widget _buildTitleAndStore() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.productName,
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.storefront_rounded,
              size: 18,
              color: Colors.grey[700],
            ),
            const SizedBox(width: 4),
            Text(
              widget.storeName,
              style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: ProductPage.primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        const Icon(
          Icons.star_rounded,
          size: 20,
          color: Color(0xFFFFD54F),
        ),
        const SizedBox(width: 4),
        Text(
          widget.rating.toStringAsFixed(1),
          style: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          '  (${widget.ratingCount} تقييم)',
          style: GoogleFonts.cairo(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  // ================== السعر + الكمية ==================

  Widget _buildPriceAndQuantity() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.price.toStringAsFixed(0)} ج.م',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: ProductPage.accentColor,
                ),
              ),
              Text(
                'لكل ${widget.unit}',
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0x108B5CF6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                _qtyButton(
                  icon: Icons.remove_rounded,
                  onTap: () {
                    if (quantity > 1) {
                      setState(() => quantity--);
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '$quantity',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _qtyButton(
                  icon: Icons.add_rounded,
                  onTap: () {
                    setState(() => quantity++);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 18,
          color: ProductPage.primaryColor,
        ),
      ),
    );
  }

  // ================== اختيار خدمة التوصيل ==================

  Widget _buildDeliverySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'خدمة التوصيل',
          style: GoogleFonts.cairo(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedDelivery,
              isExpanded: true,
              items: deliveryOptions.map((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(
                    option,
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() => selectedDelivery = value);
              },
            ),
          ),
        ),
      ],
    );
  }

  // ================== وصف المنتج ==================

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'وصف المنتج',
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.description,
          style: GoogleFonts.cairo(
            fontSize: 13,
            height: 1.5,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  // ================== منتجات مشابهة ==================

  Widget _buildSimilarProducts() {
    if (widget.similarProducts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'منتجات مشابهة',
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.similarProducts.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = widget.similarProducts[index];
              return _buildSimilarProductCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSimilarProductCard(SimilarProduct product) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
            child: SizedBox(
              height: 90,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: const Color(0xFFE0E0E0),
                ),
                errorWidget: (context, url, error) => Container(
                  color: const Color(0xFFE0E0E0),
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Text(
              '${product.price.toStringAsFixed(0)} ج.م',
              style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: ProductPage.accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================== الشريط السفلي: واتساب + طلب الآن ==================

  Widget _buildBottomBar(BuildContext context) {
    final double total = widget.price * quantity;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الإجمالي',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '${total.toStringAsFixed(0)} ج.م',
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: ProductPage.accentColor,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Expanded(
              flex: 4,
              child: ElevatedButton.icon(
                onPressed: () => _openWhatsApp(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 1,
                ),
                icon: const Icon(Icons.chat_rounded, size: 20),
                label: Text(
                  'واتساب المتجر',
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 5,
              child: ElevatedButton.icon(
                onPressed: () => _goToCart(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ProductPage.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(
                  Icons.shopping_cart_checkout_rounded,
                  size: 20,
                ),
                label: Text(
                  'طلب الآن',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToCart(BuildContext context) {
    // TODO: استبدليه لاحقًا بـ Navigator.pushNamed(context, '/cart');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'هندخلك على صفحة السلة في الخطوة الجاية 😉',
          style: GoogleFonts.cairo(),
        ),
      ),
    );
  }

  Future<void> _openWhatsApp(BuildContext context) async {
    final message = Uri.encodeComponent(
        'مرحبًا، أريد الاستفسار عن ${widget.productName} من تطبيق محلك.');
    final url = Uri.parse(
      'https://wa.me/${widget.storeWhatsappNumber}?text=$message',
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تعذّر فتح واتساب، تأكدي من تثبيته على الجهاز',
              style: GoogleFonts.cairo(),
            ),
          ),
        );
      }
    }
  }
}
