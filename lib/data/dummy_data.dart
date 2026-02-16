import '../models/product.dart';

final List<Map<String, dynamic>> productsJson = [
  {
    'title': 'The Solo Glow',
    'price': '\$230',
    'image': 'assets/images/img1.jpg',
    'image2': 'assets/images/model1.jpg',
    'rating': 4.7,
    'description': 'A minimal chain with a bright center gem for daily wear.',
    'material': '925 Sterling Silver',
    'stoneType': 'White Topaz',
  },
  {
    'title': 'Ocean Whisper',
    'price': '\$125',
    'image': 'assets/images/img2.png',
    'image2': 'assets/images/model2.jpg',
    'rating': 4.5,
    'description': 'Soft ocean tones designed for elegant evening combinations.',
    'material': 'Stainless Steel',
    'stoneType': 'Blue Zircon',
  },
  {
    'title': 'Secret Keepsake',
    'price': '\$105',
    'image': 'assets/images/img3.png',
    'image2': 'assets/images/model3.jpg',
    'rating': 4.3,
    'description': 'A classic pendant style with a subtle vintage character.',
    'material': '14K Gold Plated',
    'stoneType': 'Rose Quartz',
  },
  {
    'title': 'Rainbow Palette',
    'price': '\$110',
    'image': 'assets/images/img4.png',
    'image2': 'assets/images/model4.jpg',
    'rating': 4.2,
    'description': 'Colorful stone arrangement inspired by spring palettes.',
    'material': '925 Sterling Silver',
    'stoneType': 'Multi-color Crystal',
  },
  {
    'title': 'Soft Hues',
    'price': '\$125',
    'image': 'assets/images/img5.png',
    'image2': 'assets/images/model5.jpg',
    'rating': 4.1,
    'description': 'Pastel highlights for a calm, modern, and lightweight look.',
    'material': '14K Rose Gold Plated',
    'stoneType': 'Morganite',
  },
  {
    'title': 'Bloomy Sun',
    'price': '\$170',
    'image': 'assets/images/img6.png',
    'image2': 'assets/images/model6.jpg',
    'rating': 4.4,
    'description': 'Warm and radiant details with a floral-inspired finish.',
    'material': '925 Sterling Silver',
    'stoneType': 'Citrine',
  },
];

final List<Product> dummyProducts =
    productsJson.map((json) => Product.fromJson(json)).toList();
