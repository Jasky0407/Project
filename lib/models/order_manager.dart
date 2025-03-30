// order_manager.dart
class Order {
  final String id;
  final DateTime orderTime;
  String status; // "Processing", "Delivery Awaited", "Completed"
  final String address;
  final String userEmail; // Added field to tie order to a specific user

  Order({
    required this.id,
    required this.orderTime,
    required this.status,
    required this.address,
    required this.userEmail,
  });
}

class OrderManager {
  static List<Order> orders = [];
}
