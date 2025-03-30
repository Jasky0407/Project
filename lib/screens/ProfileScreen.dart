import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:book_rental_platform/models/order_manager.dart';
import 'package:book_rental_platform/models/user.dart';

import 'package:book_rental_platform/screens/login_screen.dart';
import 'package:book_rental_platform/screens/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  User? _user;
  List<Order> userOrders = [];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _filterOrders();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    if (email != null && password != null) {
      setState(() {
        _user = User(
          id: '1',
          name: 'User', // Replace with full name if available.
          email: email,
          password: password,
        );
      });
      _filterOrders();
    }
  }

  void _filterOrders() {
    if (_user != null) {
      setState(() {
        userOrders = OrderManager.orders
            .where((order) => order.userEmail == _user!.email)
            .toList();
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  String _maskPassword(String? password) {
    if (password == null || password.isEmpty) return '***';
    return '*' * password.length;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        title: const Text("Profile",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: _logout,
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          AssetImage('assets/profile_placeholder.png'),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _user?.email ?? 'No email found',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Password: ${_maskPassword(_user?.password)}',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text("Logout"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Divider(thickness: 1, color: Colors.white70),
                    const SizedBox(height: 10),
                    const Text("My Orders",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    userOrders.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text("No orders placed yet.",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white70)),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: userOrders.length,
                            itemBuilder: (context, index) {
                              final order = userOrders[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 16),
                                elevation: 4,
                                child: ListTile(
                                  title: Text("Order ID: ${order.id}"),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Address: ${order.address}"),
                                      Text(
                                          "Order Time: ${order.orderTime.toLocal().toString().substring(0, 16)}"),
                                      Text("Status: ${order.status}"),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
