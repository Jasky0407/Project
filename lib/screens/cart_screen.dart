import 'package:flutter/material.dart';
import 'package:book_rental_platform/screens/payment_page.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, String>> cart;

  const CartScreen({super.key, required this.cart});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  double _calculateTotal() {
    double total = 0.0;
    for (var product in widget.cart) {
      total += double.parse(product['price']!);
    }
    return total;
  }

  void _removeItem(int index) {
    setState(() {
      widget.cart.removeAt(index);
    });
  }

  Future<void> _checkout() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaymentPage()),
    );
    if (result == true) {
      setState(() {
        widget.cart.clear();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double total = _calculateTotal();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Shopping Cart",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: widget.cart.isEmpty
              ? const Center(
                  child: Text(
                    "Your cart is empty.",
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.cart.length,
                        itemBuilder: (context, index) {
                          var product = widget.cart[index];
                          // If bookType is missing, default to "E-Book"
                          String bookTypeValue = product['bookType'] ?? "ebook";
                          String bookType =
                              bookTypeValue.toLowerCase() == "ebook"
                                  ? "E-Book"
                                  : "Physical Book";
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: ListTile(
                              leading: const Icon(Icons.shopping_bag,
                                  color: Colors.blueAccent),
                              title: Text(
                                product['name']!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "\$${product['price']}",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text("Type: $bookType"),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.remove_circle,
                                    color: Colors.redAccent),
                                onPressed: () => _removeItem(index),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(color: Colors.white70),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total: \$${total.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          ElevatedButton(
                            onPressed: _checkout,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: const Text("Checkout",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.blueAccent)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
