class Product {
  final String id;
  final String name;
  final double price;
  final String image;
  double rating; // <--- new mutable field

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.rating = 0.0, // default rating
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'rating': rating, // including rating
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      image: map['image'],
      rating: map['rating'] ?? 0.0, // fallback to 0 if missing
    );
  }
}
