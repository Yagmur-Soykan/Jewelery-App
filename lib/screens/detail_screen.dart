import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/product.dart';
import '../widgets/brand_logo.dart';

class ProductDetailArgs {
  final Product product;
  final bool initialIsFavorite;
  final ValueChanged<bool> onFavoriteToggle;
  final VoidCallback onAddToCart;

  const ProductDetailArgs({
    required this.product,
    required this.initialIsFavorite,
    required this.onFavoriteToggle,
    required this.onAddToCart,
  });
}

class ProductDetailScreen extends StatefulWidget {
  static const String routeName = '/detail';

  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int currentImageIndex = 0;
  bool isFavorite = false;
  ProductDetailArgs? args;
  final GlobalKey _reviewsKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  bool _didReadArgs = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didReadArgs) return;
    final Object? routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (routeArgs is ProductDetailArgs) {
      args = routeArgs;
      isFavorite = routeArgs.initialIsFavorite;
    }
    _didReadArgs = true;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollToReviews() async {
    final BuildContext? context = _reviewsKey.currentContext;
    if (context == null) return;
    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  List<Map<String, dynamic>> _buildMockReviews(
    String productTitle,
    double baseRating,
  ) {
    final double r1 = (baseRating + 0.1).clamp(0.0, 5.0).toDouble();
    final double r2 = baseRating;
    final double r3 = (baseRating - 0.1).clamp(0.0, 5.0).toDouble();
    List<Map<String, String>> seeds;
    switch (productTitle) {
      case 'The Solo Glow':
        seeds = [
          {
            'name': 'Olivia M.',
            'comment':
                'Very refined in person. It works with both casual and formal outfits.',
          },
          {'name': 'Noah K.', 'comment': ''},
          {
            'name': 'Harper D.',
            'comment':
                'Lightweight, elegant, and the shine is subtle in a good way.',
          },
        ];
        break;
      case 'Ocean Whisper':
        seeds = [
          {
            'name': 'Sophia T.',
            'comment': 'The blue stone tone is stunning and looks premium.',
          },
          {'name': 'Ethan W.', 'comment': ''},
          {
            'name': 'Chloe R.',
            'comment':
                'Great finish quality. The clasp feels secure and comfortable.',
          },
        ];
        break;
      case 'Secret Keepsake':
        seeds = [
          {
            'name': 'Ava L.',
            'comment': 'Classic design, exactly what I was looking for.',
          },
          {'name': 'James P.', 'comment': ''},
          {
            'name': 'Grace N.',
            'comment':
                'Looks more expensive than expected. Very happy with the purchase.',
          },
        ];
        break;
      case 'Rainbow Palette':
        seeds = [
          {
            'name': 'Mila C.',
            'comment':
                'Color details are lovely and vibrant without being too loud.',
          },
          {'name': 'Lucas H.', 'comment': ''},
          {
            'name': 'Zoe B.',
            'comment': 'Beautiful craftsmanship and a very unique style.',
          },
        ];
        break;
      case 'Soft Hues':
        seeds = [
          {
            'name': 'Ella G.',
            'comment': 'Soft, minimal, and easy to pair with everyday outfits.',
          },
          {'name': 'Liam S.', 'comment': ''},
          {
            'name': 'Nora F.',
            'comment':
                'The rose tone is elegant and the quality feels really solid.',
          },
        ];
        break;
      default:
        seeds = [
          {
            'name': 'Isla J.',
            'comment': 'Warm color palette and nice finishing details.',
          },
          {'name': 'Mason V.', 'comment': ''},
          {
            'name': 'Ruby A.',
            'comment':
                'A strong price/quality balance. Would definitely recommend.',
          },
        ];
    }

    return [
      {'name': seeds[0]['name'], 'rating': r1, 'comment': seeds[0]['comment']},
      {'name': seeds[1]['name'], 'rating': r2, 'comment': seeds[1]['comment']},
      {'name': seeds[2]['name'], 'rating': r3, 'comment': seeds[2]['comment']},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ProductDetailArgs? currentArgs = args;
    if (currentArgs == null) {
      return const Scaffold(
        body: Center(
          child: Text('Route argument missing for product detail'),
        ),
      );
    }
    final Product product = currentArgs.product;
    final List<String> productImages = [product.image, product.image2];
    final List<Map<String, dynamic>> reviews = _buildMockReviews(
      product.title,
      product.rating,
    );
    final double avgReview =
        reviews
            .map((e) => (e['rating'] as double))
            .fold(0.0, (sum, value) => sum + value) /
        reviews.length;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 76,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const BrandLogo(),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: productImages.length,
                    onPageChanged: (index) {
                      setState(() => currentImageIndex = index);
                    },
                    itemBuilder: (context, index) {
                      final EdgeInsets imagePadding = index == 1
                          ? const EdgeInsets.symmetric(horizontal: 20)
                          : const EdgeInsets.all(20);
                      return Padding(
                        padding: imagePadding,
                        child: Image.asset(
                          productImages[index],
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          setState(() => isFavorite = !isFavorite);
                          currentArgs.onFavoriteToggle(isFavorite);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.pink : Colors.black54,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                productImages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentImageIndex == index ? 18 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentImageIndex == index
                        ? const Color(0xFF0A1931)
                        : Colors.black26,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              product.title,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 34,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0A1931),
                height: 1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              product.description,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                height: 1.45,
                color: const Color(0xFF30343C),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(
                  Icons.diamond_outlined,
                  size: 17,
                  color: Color(0xFFD4AF37),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.25,
                        color: const Color(0xFF1E2530),
                      ),
                      children: [
                        const TextSpan(
                          text: 'Material: ',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: product.material),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome_outlined,
                  size: 17,
                  color: Color(0xFFD4AF37),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.25,
                        color: const Color(0xFF1E2530),
                      ),
                      children: [
                        const TextSpan(
                          text: 'Stone: ',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: product.stoneType),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 6),
                const Text(
                  'Ratings',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  product.rating.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _scrollToReviews,
                  child: const Text(
                    'See reviews',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF0A1931),
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5CF9C), width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        color: const Color(0xFFFCF6E8),
                        alignment: Alignment.center,
                        child: Text(
                          product.price,
                          style: GoogleFonts.montserrat(
                            fontSize: 23,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0A1931),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Material(
                        color: const Color(0xFF0A1931),
                        child: InkWell(
                          onTap: () {
                            currentArgs.onAddToCart();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Added to cart')),
                            );
                          },
                          child: const Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 15,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Add to Cart',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            Container(
              key: _reviewsKey,
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'User Reviews',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0A1931),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        avgReview.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ...reviews.map((review) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review['name'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0A1931),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 15,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              (review['rating'] as double).toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if ((review['comment'] as String).isNotEmpty)
                      Text(
                        review['comment'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                          height: 1.35,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
