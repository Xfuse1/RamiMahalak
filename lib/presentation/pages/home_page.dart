import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mahlak_nem/presentation/widgets/product_card.dart';
import 'package:mahlak_nem/presentation/pages/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _currentSliderIndex = 0;
  int _selectedBottomNav = 0;
  late PageController _pageController;
  late AnimationController _animationController;

  final List<String> sliderImages = [
    'assets/images/slider1.jpg',
    'assets/images/slider2.jpg',
    'assets/images/slider3.jpg',
  ];

  final List<Map<String, dynamic>> categories = [
    {
      'icon': Icons.shopping_basket,
      'label': 'بقالة',
      'color': Color(0xFFFFB74D)
    },
    {
      'icon': Icons.health_and_safety,
      'label': 'صحة',
      'color': Color(0xFFEF5350)
    },
    {'icon': Icons.checkroom, 'label': 'ملابس', 'color': Color(0xFFEC407A)},
    {'icon': Icons.devices, 'label': 'إلكترونيات', 'color': Color(0xFF7E57C2)},
    {'icon': Icons.local_dining, 'label': 'أغذية', 'color': Color(0xFFFF9800)},
    {'icon': Icons.chair, 'label': 'أثاث', 'color': Color(0xFF795548)},
    {'icon': Icons.more_horiz, 'label': 'أخرى', 'color': Color(0xFF90A4AE)},
  ];

  final List<Map<String, dynamic>> featuredStores = [
    {
      'name': 'متجر النور',
      'rating': 4.7,
      'reviews': 189,
      'image': 'assets/images/store1.jpg'
    },
    {
      'name': 'الفرن الذهبي',
      'rating': 4.9,
      'reviews': 456,
      'image': 'assets/images/store2.jpg'
    },
    {
      'name': 'متجر الألبان',
      'rating': 4.8,
      'reviews': 234,
      'image': 'assets/images/store3.jpg'
    },
  ];

  final List<Map<String, dynamic>> recommendedProducts = [
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
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 5000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: isTablet ? _buildTabletLayout() : _buildMobileLayout(),
      bottomNavigationBar: !isTablet ? _buildBottomNav() : null,
    );
  }

  // ===== App Bar =====
  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(75),
      child: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  icon: Icon(Icons.login, size: 16),
                  label: Text('تسجيل الدخول'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on,
                            color: AppColors.primary, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'محلك',
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Icon(Icons.shopping_cart, color: AppColors.primary, size: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===== Layout للجوال =====
  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            _buildSlider(),
            _buildSearchBar(),
            _buildCategoriesSection(),
            _buildPromoBanner(),
            _buildFeaturedStoresSection(),
            _buildRecommendedProductsSection(),
            _buildWelcomeSection(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ===== Layout للتابلت =====
  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            _buildSlider(),
            _buildSearchBar(),
            _buildCategoriesSection(),
            _buildPromoBanner(),
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildFeaturedStoresSection(),
                  SizedBox(height: 32),
                  _buildRecommendedProductsSection(),
                  SizedBox(height: 32),
                  _buildWelcomeSection(),
                ],
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ===== السلايدر =====
  Widget _buildSlider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25), // ~0.1 opacity
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentSliderIndex = index;
                    });
                  },
                  itemCount: sliderImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(sliderImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.5),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'اكتشف أفضل العروض والمنتجات',
                                style: GoogleFonts.cairo(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black,
                                      blurRadius: 4,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/register');
                                },
                                child: Text('اكتشف المزيد'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondary,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 28, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // أزرار التنقل
                Positioned(
                  left: 12,
                  top: 50,
                  child: _buildNavButton(Icons.chevron_left, () {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }),
                ),
                Positioned(
                  right: 12,
                  top: 50,
                  child: _buildNavButton(Icons.chevron_right, () {
                    _pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // نقاط المؤشرات
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              sliderImages.length,
              (index) => GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: _currentSliderIndex == index ? 32 : 8,
                  height: 8,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentSliderIndex == index
                        ? AppColors.primary
                        : AppColors.divider,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.95),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(51), // ~0.2 opacity
              blurRadius: 8,
            )
          ],
        ),
        child: Icon(icon, color: AppColors.primary, size: 24),
      ),
    );
  }

  // ===== شريط البحث =====
  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'ابحث عن منتج أو متجر...',
            hintStyle: GoogleFonts.cairo(
              color: AppColors.textLight,
              fontSize: 14,
            ),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(Icons.search, color: AppColors.primary, size: 20),
            suffixIcon: Icon(Icons.mic, color: AppColors.primary, size: 20),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          style: GoogleFonts.cairo(),
        ),
      ),
    );
  }

  // ===== قسم الفئات =====
  Widget _buildCategoriesSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تصفح الفئات',
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.text,
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              padding: EdgeInsets.symmetric(horizontal: 4),
              separatorBuilder: (_, __) => SizedBox(width: 12),
              itemBuilder: (context, index) {
                final card = _buildCategoryCard(categories[index]);
                return card
                    .animate()
                    .fadeIn(duration: 420.ms)
                    .moveY(begin: 16.0, duration: 420.ms);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 110,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10), // ~0.04 opacity
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: (category['color'] as Color)
                          .withAlpha(46), // ~0.18 opacity
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          category['color'],
                          (category['color'] as Color).withValues(alpha: 0.85)
                        ],
                      ),
                    ),
                    child:
                        Icon(category['icon'], color: Colors.white, size: 26),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                category['label'],
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== بنر العروض الترويجي =====
  Widget _buildPromoBanner() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildPromoCard(
              'جميع المنتجات',
              'ملايين المنتجات',
              Icons.inventory_2,
              AppColors.primary,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildPromoCard(
              'جميع المتاجر',
              'متاجر موثوقة',
              Icons.store,
              AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCard(
      String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.8)],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(51), // ~0.2 opacity
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 36),
          SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.cairo(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ===== قسم المتاجر المتميزة =====
  Widget _buildFeaturedStoresSection() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المتاجر المتميزة',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.text,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'عرض الكل',
                  style: GoogleFonts.cairo(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(featuredStores.length, (i) {
                final store = featuredStores[i];
                return Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: _buildStoreCard(store)
                      .animate()
                      .fadeIn(duration: 450.ms)
                      .moveX(begin: 12.0, duration: 450.ms),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreCard(Map<String, dynamic> store) {
    return GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/store', arguments: store),
        child: Container(
          width: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20), // ~0.08 opacity
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Container(
                  height: 140,
                  color: AppColors.background,
                  child: Image.asset(store['image'], fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            store['name'],
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.text,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            SizedBox(width: 4),
                            Text(
                              store['rating'].toString(),
                              style: GoogleFonts.cairo(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${store['reviews']} تقييم',
                      style: GoogleFonts.cairo(
                        fontSize: 11,
                        color: AppColors.textLight,
                      ),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/store',
                              arguments: store);
                        },
                        child: Text('زيارة المتجر'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  // ===== قسم المنتجات المقترحة =====
  Widget _buildRecommendedProductsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'منتجات قد تعجبك',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.text,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'عرض الكل',
                  style: GoogleFonts.cairo(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(recommendedProducts.length, (i) {
                final product = recommendedProducts[i];
                return Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/product',
                              arguments: product),
                          child: ProductCard(product: product))
                      .animate()
                      .fadeIn(duration: 420.ms)
                      .moveY(begin: 12.0, duration: 420.ms),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ===== قسم الترحيب =====
  Widget _buildWelcomeSection() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(77), // ~0.3 opacity
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.celebration, color: Colors.white, size: 56),
            SizedBox(height: 16),
            Text(
              'أهلاً وسهلاً بك في متجرنا',
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              'نحن هنا لنوفر لك كل ما تحتاجه بتوصيل سريع وموثوق، وبأسعار منافسة.',
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: Colors.white70,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text('ابدأ التسوق الآن'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== الفوتر =====
  Widget _buildFooter() {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 800;

    return Container(
      color: Color(0xFF0F1724),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // About
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: AppColors.secondary),
                          SizedBox(width: 8),
                          Text(
                            'محلك',
                            style: GoogleFonts.cairo(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        'منصة تسوق محلية تربط بينك وبين أفضل المتاجر في منطقتك مع توصيل سريع وخدمة موثوقة.',
                        style: GoogleFonts.cairo(
                          color: Colors.grey[300],
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          _socialIcon('assets/icons/facebook.png'),
                          SizedBox(width: 12),
                          _socialIcon('assets/icons/instagram.png'),
                          SizedBox(width: 12),
                          _socialIcon('assets/icons/twitter.png'),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 24),

                // Quick Links
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('روابط سريعة',
                          style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      SizedBox(height: 12),
                      _footerLink('الرئيسية', () {}),
                      _footerLink('المتاجر', () {}),
                      _footerLink('العروض', () {}),
                      _footerLink('من نحن', () {}),
                    ],
                  ),
                ),

                SizedBox(width: 24),

                // Contact
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('تواصل معنا',
                          style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      SizedBox(height: 12),
                      Text('support@mahlak.com',
                          style: GoogleFonts.cairo(color: Colors.grey[300])),
                      SizedBox(height: 8),
                      Text('+966 50 123 4567',
                          style: GoogleFonts.cairo(color: Colors.grey[300])),
                      SizedBox(height: 8),
                      Text('ساعات العمل: 9 صباحاً - 10 مساءً',
                          style: GoogleFonts.cairo(
                              color: Colors.grey[400], fontSize: 12)),
                    ],
                  ),
                ),

                SizedBox(width: 24),

                // Newsletter
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('النشرة الإخبارية',
                          style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      SizedBox(height: 12),
                      Text(
                          'اشترك للحصول على أحدث العروض والخصومات مباشرةً في بريدك.',
                          style: GoogleFonts.cairo(
                              color: Colors.grey[300], fontSize: 13)),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'بريدك الإلكتروني',
                                  border: InputBorder.none,
                                ),
                                style: GoogleFonts.cairo(fontSize: 13),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('اشترك'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'محلك',
                  style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  'منصة تسوق محلية تربط بينك وبين أفضل المتاجر في منطقتك مع توصيل سريع وخدمة موثوقة.',
                  style:
                      GoogleFonts.cairo(color: Colors.grey[300], fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialIcon('assets/icons/facebook.png'),
                    SizedBox(width: 12),
                    _socialIcon('assets/icons/instagram.png'),
                    SizedBox(width: 12),
                    _socialIcon('assets/icons/twitter.png'),
                  ],
                ),
                SizedBox(height: 16),
                _footerLink('سياسة الخصوصية', () {}),
                _footerLink('شروط الاستخدام', () {}),
                SizedBox(height: 8),
                Text('الدعم: support@mahlak.com',
                    style: GoogleFonts.cairo(color: Colors.grey[300])),
              ],
            ),
          SizedBox(height: 20),
          Divider(color: Colors.white12),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('© ${DateTime.now().year} محلك - جميع الحقوق محفوظة',
                  style:
                      GoogleFonts.cairo(color: Colors.grey[500], fontSize: 12)),
              Text('متاح على جميع الأجهزة',
                  style:
                      GoogleFonts.cairo(color: Colors.grey[500], fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _socialIcon(String assetPath) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: EdgeInsets.all(6),
          child: Image.asset(assetPath),
        ),
      ),
    );
  }

  Widget _footerLink(String label, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(label, style: GoogleFonts.cairo(color: Colors.grey[300])),
      ),
    );
  }

  // ===== Bottom Navigation =====
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedBottomNav,
      onTap: (index) {
        setState(() {
          _selectedBottomNav = index;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'البحث'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'المفضلة'),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart), label: 'السلة'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
      ],
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textLight,
      selectedLabelStyle: GoogleFonts.cairo(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      unselectedLabelStyle: GoogleFonts.cairo(fontSize: 12),
    );
  }
}
