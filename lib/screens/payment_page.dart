import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_manager.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();
  final addressController = TextEditingController();

  bool processing = false;

  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  final MaskTextInputFormatter cardMask = MaskTextInputFormatter(
      mask: "#### #### #### ####", filter: {"#": RegExp(r'\d')});
  final MaskTextInputFormatter expiryMask =
      MaskTextInputFormatter(mask: "##/##", filter: {"#": RegExp(r'\d')});

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _offsetAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  Future<void> _processPayment() async {
    if (_formKey.currentState!.validate()) {
      setState(() => processing = true);

      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('email') ?? 'unknown@example.com';

      final newOrder = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        orderTime: DateTime.now(),
        status: "Processing",
        address: addressController.text,
        userEmail: userEmail,
      );

      OrderManager.orders.add(newOrder);

      Future.delayed(const Duration(seconds: 4), () {
        setState(() {
          newOrder.status = "Delivery Awaited";
          processing = false;
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Order Confirmed"),
            content: const Text(
              "Your payment was successful and your order is being processed!",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true); // Clear cart
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Secure Payment"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: processing
            ? const Center(child: CircularProgressIndicator())
            : SlideTransition(
                position: _offsetAnimation,
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          const Text(
                            "Enter Your Card Details",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          _buildField(
                              controller: cardNumberController,
                              label: "Card Number",
                              hint: "1234 5678 9012 3456",
                              icon: Icons.credit_card,
                              formatter: cardMask),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildField(
                                    controller: expiryController,
                                    label: "Expiry",
                                    hint: "MM/YY",
                                    icon: Icons.calendar_month,
                                    formatter: expiryMask),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildField(
                                  controller: cvvController,
                                  label: "CVV",
                                  hint: "123",
                                  icon: Icons.lock,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildField(
                            controller: addressController,
                            label: "Shipping Address",
                            icon: Icons.location_on,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _processPayment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 30),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              textStyle: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            icon: const Icon(Icons.payment),
                            label: const Text("Pay Now"),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    MaskTextInputFormatter? formatter,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: formatter != null ? [formatter] : null,
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Enter $label' : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
