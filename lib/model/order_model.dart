import 'package:petrol_n_gas/model/product_model.dart';

class Order {
  final String email;
  final List<ProductModel> orderProducts; //* collection reference.
  final DateTime orderTime; // * or use Timestamp? Time of the order
  final double totalAmount;
  final bool approved;

  Order({
    required this.email,
    required this.orderProducts,
    required this.orderTime,
    required this.totalAmount,
    required this.approved
  });
}

//* OrderItem is ProductModel.