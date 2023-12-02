import 'package:petrol_n_gas/models/product_model.dart';

class OrderModel {
  final String email;
  final List<ProductModel> orderProducts;
  final DateTime orderTime = DateTime.now();
  final bool approved = false;
  final double totalAmount;

  OrderModel({
    required this.email, // current user email.
    required this.orderProducts,
    required this.totalAmount,
  });
}