class ProductModel {
  ProductModel(
      {required this.name,
      required this.price,
      required this.image,
      required this.category});


  final String name;
  final String price;
  final String image;
  final String category;

    Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'image': image,
      'category': category,
    };
  }
}
