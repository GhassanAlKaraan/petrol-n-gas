class Order {
  final String userId; // User's ID
  final List<OrderItem> items; // List of items in the order
  final DateTime orderTime; // Date and time of order //current timestamp(now)
  final double totalAmount; // Total order amount

  Order({
    required this.userId,
    required this.items,
    required this.orderTime,
    required this.totalAmount,
  });
}

class OrderItem {
//* accept a product object instead? no the quantity of order is different from the quantity of product stock

  final String name; // Name of the product
  final int quantity; // Quantity of the product in the order
  final double price; // Price of the product

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}
