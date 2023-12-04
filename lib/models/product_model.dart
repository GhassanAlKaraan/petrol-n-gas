class ProductModel {
  ProductModel({
    required this.imageFlag,
    required this.name,
    required this.price,
    required this.quantity,
    required this.category,
  });

  final String name;
  final double price;
  final int quantity;
  final String category;
  final String imageFlag; //p1, p2, g1, g2, a1, a2, a3

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'category': category,
      'imageFlag': imageFlag,
    };
  }

  // @override
  // String toString() {
  //   return 'ProductModel{name: $name, price: $price, quantity: $quantity, category: $category, imageFlag: $imageFlag}';
  // }
}
