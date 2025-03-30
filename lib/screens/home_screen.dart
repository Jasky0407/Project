import 'package:flutter/material.dart';
import 'package:book_rental_platform/models/product.dart';
import 'cart_screen.dart';
import 'profilescreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  // Static product list; no shuffling applied.
  final List<Product> allProducts = [
    Product(
        id: '1',
        name: "Jacket",
        price: 79.0,
        image: "jacket.jpeg",
        rating: 0.0),
    Product(
        id: '2', name: "Jeans", price: 40.0, image: "jean.jpeg", rating: 0.0),
    Product(
        id: '3', name: "T-Shirt", price: 39.0, image: "shirt.png", rating: 0.0),
    Product(
        id: '4',
        name: "T-Shirt",
        price: 29.0,
        image: "shirt2.jpeg",
        rating: 0.0),
    Product(
        id: '5',
        name: "Winter Jacket",
        price: 119.0,
        image: "jacket2.jpeg",
        rating: 0.0),
    Product(
        id: '6',
        name: "Jogger Pants",
        price: 99.0,
        image: "pants.jpeg",
        rating: 0.0),
    Product(
        id: '7',
        name: "Running Shoes",
        price: 129.0,
        image: "shoes.png",
        rating: 0.0),
    Product(
        id: '8',
        name: "Bluetooth Speaker",
        price: 59.0,
        image: "speaker.png",
        rating: 0.0),
    Product(
        id: '9',
        name: "Digital Camera",
        price: 499.0,
        image: "camera.png",
        rating: 0.0),
    Product(
        id: '10',
        name: "Desk Lamp",
        price: 29.0,
        image: "lamp.png",
        rating: 0.0),
    Product(
        id: '11',
        name: "Tablet",
        price: 399.0,
        image: "tablet.png",
        rating: 0.0),
    Product(
        id: '12',
        name: "Office Chair",
        price: 199.0,
        image: "chair.png",
        rating: 0.0),
    Product(
        id: '13',
        name: "Electric Kettle",
        price: 35.0,
        image: "kettle.png",
        rating: 0.0),
    Product(
        id: '14', name: "Smart TV", price: 899.0, image: "tv.png", rating: 0.0),
    Product(
        id: '15',
        name: "Wireless Mouse",
        price: 25.0,
        image: "mouse.png",
        rating: 0.0),
  ];

  late List<Product> products;
  List<Product> cart = [];

  @override
  void initState() {
    super.initState();
    // Directly assign the full product list
    products = allProducts;
  }

  void _addToCart(Product product) {
    setState(() {
      cart.add(product);
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Added to Cart"),
        content: Text("${product.name} has been added to your cart."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text("OK")),
        ],
      ),
    );
  }

  void _goToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(
          cart: cart
              .map((product) => {
                    'id': product.id,
                    'name': product.name,
                    'price': product.price.toString(),
                    'image': product.image,
                  })
              .toList(),
        ),
      ),
    );
  }

  void _goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  void _rateProduct(Product product) async {
    double selectedRating = product.rating > 0 ? product.rating : 3.0;
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Rate "${product.name}"'),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Select a rating from 1 to 5:"),
                  const SizedBox(height: 10),
                  Slider(
                    min: 1.0,
                    max: 5.0,
                    divisions: 4,
                    value: selectedRating,
                    label: selectedRating.toStringAsFixed(1),
                    onChanged: (value) {
                      setStateDialog(() {
                        selectedRating = value;
                      });
                    },
                  ),
                  Text("Rating: ${selectedRating.toStringAsFixed(1)}"),
                ],
              );
            },
          ),
          actions: [
            TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context)),
            ElevatedButton(
                child: const Text("Submit"),
                onPressed: () {
                  setState(() {
                    product.rating = selectedRating;
                  });
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }

  Widget _buildStarRating(double rating) {
    int roundedRating = rating.round();
    List<Icon> stars = [];
    for (int i = 1; i <= 5; i++) {
      stars.add(i <= roundedRating
          ? const Icon(Icons.star, color: Colors.amber, size: 20)
          : const Icon(Icons.star_border, color: Colors.grey, size: 20));
    }
    return Row(mainAxisSize: MainAxisSize.min, children: stars);
  }

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = products
        .where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF3E5F5), Color(0xFFD1C4E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Text("Cloth Shipping App",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        )),
                    const Spacer(),
                    IconButton(
                        icon: const Icon(Icons.person),
                        color: Colors.white,
                        onPressed: _goToProfile),
                    IconButton(
                        icon: const Icon(Icons.shopping_cart),
                        color: Colors.white,
                        onPressed: _goToCart),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search products...",
                      prefixIcon: const Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    var product = filteredProducts[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/${product.image}"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              product.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("\$${product.price}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.bold)),
                                _buildStarRating(product.rating),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () => _rateProduct(product),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 8),
                                  ),
                                  child: const Text('Rate',
                                      style: TextStyle(color: Colors.white)),
                                ),
                                ElevatedButton(
                                  onPressed: () => _addToCart(product),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 8),
                                  ),
                                  child: const Text('Cart',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
