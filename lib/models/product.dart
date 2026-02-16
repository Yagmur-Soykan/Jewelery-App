class Product {
  final String title;
  final String price;
  final String image;
  final String image2;
  final double rating;
  final String description;
  final String material;
  final String stoneType;

  const Product({
    required this.title,
    required this.price,
    required this.image,
    required this.image2,
    required this.rating,
    required this.description,
    required this.material,
    required this.stoneType,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: (json['title'] ?? 'Untitled').toString(),
      price: (json['price'] ?? '\$0').toString(),
      image: (json['image'] ?? 'assets/images/img1.jpg').toString(),
      image2: (json['image2'] ?? (json['image'] ?? 'assets/images/img1.jpg'))
          .toString(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      description: (json['description'] ?? 'No description available.')
          .toString(),
      material: (json['material'] ?? 'Unknown').toString(),
      stoneType: (json['stoneType'] ?? 'Unknown').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'image': image,
      'image2': image2,
      'rating': rating,
      'description': description,
      'material': material,
      'stoneType': stoneType,
    };
  }
}
