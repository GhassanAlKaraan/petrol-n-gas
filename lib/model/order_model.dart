import 'package:petrol_n_gas/model/product_model.dart';

class OrderModel{ // the document id must be the user email.

  OrderModel({required this.totalAmount});


  final List<ProductModel> products = [];
  final int totalAmount;


  //toMap
  Map<String, dynamic> toMap() {
    return {
      'products': products.map((e) => e.toMap()).toList(),
      'totalAmount': totalAmount,
    };
  }
  
}