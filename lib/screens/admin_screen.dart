import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:book_rental_platform/models/order_manager.dart';
import 'package:book_rental_platform/screens/login_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  String selectedOrderFilter =
      "All"; // Options: "All", "Delivery Awaited", "Completed"

  // Animation controller for a fade-in effect.
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    _animationController.forward();
  }

  // Stub: Simulate loading registered users (replace with your actual logic)
  Future<List<Map<String, String>>> _loadRegisteredUsers() async {
    await Future.delayed(const Duration(seconds: 1));
    // Example data; replace with actual retrieval logic.
    return [
      {'name': '', 'email': 'jaskaran0407@gmail.com'},
    ];
  }

  // Filter orders according to the selected filter.
  List<Order> get filteredOrders {
    List<Order> orders = OrderManager.orders;
    if (selectedOrderFilter == "All") {
      return orders;
    } else {
      return orders
          .where((order) => order.status == selectedOrderFilter)
          .toList();
    }
  }

  // Logout: Clears admin session data.
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isAdmin');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Enhanced UI for AdminScreen with fade animation and refined styling.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel",
            style: TextStyle(fontWeight: FontWeight.bold)),
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
            colors: [Colors.lightBlueAccent, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: FutureBuilder<List<Map<String, String>>>(
            future: _loadRegisteredUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final registeredUsers = snapshot.data ?? [];
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Registered Users Section
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Registered Users",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    registeredUsers.isEmpty
                        ? const Center(
                            child: Text("No registered users found.",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white70)),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: registeredUsers.length,
                            itemBuilder: (context, index) {
                              final user = registeredUsers[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 16),
                                elevation: 4,
                                child: ListTile(
                                  leading: const Icon(Icons.person,
                                      color: Colors.blueAccent),
                                  title: Text(user['name'] ?? 'Unknown'),
                                  subtitle: Text(user['email'] ?? 'No Email'),
                                ),
                              );
                            },
                          ),
                    const Divider(color: Colors.white70, thickness: 1),
                    // Orders Section with filtering dropdown
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Text(
                            "Orders",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const Spacer(),
                          DropdownButton<String>(
                            value: selectedOrderFilter,
                            dropdownColor: Colors.blueAccent,
                            items: <String>[
                              "All",
                              "Delivery Awaited",
                              "Completed"
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedOrderFilter = newValue;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = filteredOrders[index];
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Address: ${order.address}"),
                                Text(
                                    "Order Time: ${order.orderTime.toLocal().toString().substring(0, 16)}"),
                                Text("Status: ${order.status}"),
                              ],
                            ),
                            trailing: order.status == "Delivery Awaited"
                                ? ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        order.status = "Completed";
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text("Mark Completed"),
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
