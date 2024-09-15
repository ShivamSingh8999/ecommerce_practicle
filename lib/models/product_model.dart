class Product {
  final int id;
  final String title;
  final String image;
  final double price;
  int quantity;

  Product({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    this.quantity = 1,
  });

  factory Product.fromMap(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      image: json['thumbnail'],
      price: json['price'].toDouble(),
    );
  }
}
