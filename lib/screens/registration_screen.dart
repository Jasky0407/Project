import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  Future<void> _register() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _emailController.text);
    await prefs.setString('password', _passwordController.text);
    await prefs.setBool('isRegistered', true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration successful!')),
    );
    Navigator.pushReplacementNamed(context, '/login');
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.blueAccent),
        hintText: 'Enter your $label',
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white.withOpacity(0.95),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
        prefixIcon: Icon(icon, color: Colors.blueAccent),
      ),
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Please enter your $label' : null,
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          _register();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Register',
        style: TextStyle(
            fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                          const SizedBox(height: 20),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _buildTextField(
                                    _emailController, 'Email', Icons.email),
                                const SizedBox(height: 15),
                                _buildTextField(
                                    _passwordController, 'Password', Icons.lock,
                                    obscureText: true),
                                const SizedBox(height: 20),
                                _isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.blueAccent)
                                    : _buildRegisterButton(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () => Navigator.pushReplacementNamed(
                                context, '/login'),
                            child: const Text('Already have an account? Login',
                                style: TextStyle(color: Colors.blueAccent)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
