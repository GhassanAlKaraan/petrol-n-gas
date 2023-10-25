class ProductModel {
  ProductModel(
      {required this.name,
      required this.price,
      required this.quantity,
      required this.category});


  final String name;
  final int price;
  final int quantity;
  final String category;

    Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'category': category,
    };
  }
}
