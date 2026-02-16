import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../models/product.dart';
import '../widgets/brand_logo.dart';
import '../widgets/product_card.dart';
import 'detail_screen.dart';

class ProductGridScreen extends StatefulWidget {
  const ProductGridScreen({super.key});

  @override
  State<ProductGridScreen> createState() => _ProductGridScreenState();
}

class _ProductGridScreenState extends State<ProductGridScreen> {
  String searchQuery = '';
  int selectedTabIndex = 0;
  final Set<String> favoriteTitles = <String>{};
  final Map<String, Product> cartProducts = {};
  final Map<String, int> cartQuantities = {};

  double _parsePrice(String priceText) {
    final String numeric = priceText.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(numeric) ?? 0;
  }

  String _formatPrice(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final String query = searchQuery.trim().toLowerCase();
    final bool shouldFilterBySearch = query.length >= 3;
    final List<Product> filteredProducts = dummyProducts.where((product) {
      final String title = product.title.toLowerCase();
      final bool matchesSearch = shouldFilterBySearch
          ? title.contains(query)
          : true;
      final bool matchesTab = switch (selectedTabIndex) {
        0 => true,
        1 => favoriteTitles.contains(product.title),
        _ => false,
      };
      return matchesSearch && matchesTab;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const BrandLogo(),
        toolbarHeight: 76,
        bottom: selectedTabIndex == 2
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: TextField(
                      onChanged: (value) => setState(() => searchQuery = value),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Search products',
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.search, color: Colors.white70),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 11),
                      ),
                    ),
                  ),
                ),
              ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: selectedTabIndex == 2
            ? _buildCartView()
            : filteredProducts.isEmpty
                ? const Center(
                    child: Text(
                      'No products found',
                      style: TextStyle(color: Colors.black54),
                    ),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.64,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final Product product = filteredProducts[index];
                      return ProductCard(
                        title: product.title,
                        price: product.price,
                        imageUrl: product.image,
                        rating: product.rating,
                        onTap: () {
                          final String productTitle = product.title;
                          Navigator.of(context).pushNamed(
                            ProductDetailScreen.routeName,
                            arguments: ProductDetailArgs(
                              product: product,
                              initialIsFavorite: favoriteTitles.contains(
                                productTitle,
                              ),
                              onFavoriteToggle: (isFavorite) {
                                setState(() {
                                  if (isFavorite) {
                                    favoriteTitles.add(productTitle);
                                  } else {
                                    favoriteTitles.remove(productTitle);
                                  }
                                });
                              },
                              onAddToCart: () {
                                setState(() {
                                  cartProducts[productTitle] = product;
                                  cartQuantities[productTitle] =
                                      (cartQuantities[productTitle] ?? 0) + 1;
                                  selectedTabIndex = 0;
                                });
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedTabIndex,
        onTap: (index) => setState(() => selectedTabIndex = index),
        backgroundColor: const Color(0xFF0A1931),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Fav',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
        ],
      ),
    );
  }

  Widget _buildCartView() {
    final List<String> cartTitles = cartQuantities.keys.toList();
    final double subtotal = cartTitles.fold(0, (sum, title) {
      final Product? product = cartProducts[title];
      final int quantity = cartQuantities[title] ?? 0;
      final double unitPrice = _parsePrice(product?.price ?? '\$0');
      return sum + (unitPrice * quantity);
    });
    const double shippingCost = 20;
    final double total = subtotal + shippingCost;

    if (cartTitles.isEmpty) {
      return const Center(
        child: Text(
          'Your cart is empty',
          style: TextStyle(color: Colors.black54),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cartTitles.length,
            itemBuilder: (context, index) {
              final String title = cartTitles[index];
              final Product product = cartProducts[title]!;
              final int quantity = cartQuantities[title] ?? 1;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 56,
                        height: 56,
                        color: Colors.white,
                        padding: const EdgeInsets.all(4),
                        child: Image.asset(product.image, fit: BoxFit.contain),
                      ),
                    ),
                    title: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _qtyButton(
                            icon: Icons.remove,
                            onTap: () {
                              setState(() {
                                final int current = cartQuantities[title] ?? 1;
                                if (current <= 1) {
                                  cartQuantities.remove(title);
                                  cartProducts.remove(title);
                                } else {
                                  cartQuantities[title] = current - 1;
                                }
                              });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              '$quantity',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          _qtyButton(
                            icon: Icons.add,
                            onTap: () {
                              setState(() {
                                cartQuantities[title] = quantity + 1;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    trailing: Text(
                      product.price,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A1931),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF0A1931),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Subtotal',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    _formatPrice(subtotal),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Shipping',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    _formatPrice(shippingCost),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(color: Colors.white24, height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    _formatPrice(total),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0A1931),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Payment flow coming soon')),
                    );
                  },
                  child: const Text(
                    'Pay',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _qtyButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: const Color(0xFF0A1931).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, size: 16, color: const Color(0xFF0A1931)),
      ),
    );
  }
}
