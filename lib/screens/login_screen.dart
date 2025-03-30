import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
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
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    String? storedEmail = prefs.getString('email');
    String? storedPassword = prefs.getString('password');

    const String adminEmail = "admin@gmail.com";
    const String adminPassword = "admin123";

    if (_emailController.text == adminEmail &&
        _passwordController.text == adminPassword) {
      await prefs.setBool('isAdmin', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminScreen()),
      );
    } else if (storedPassword != null &&
        _emailController.text == storedEmail &&
        _passwordController.text == storedPassword) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid credentials')),
      );
    }
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
      TextEditingController controller, String hint, IconData icon,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Please enter $hint' : null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        prefixIcon: Icon(icon, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          _login();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(vertical: 14),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
      ),
      child: const Text(
        'Login',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent.shade200, Colors.lightBlue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 40),
                      _buildTextField(_emailController, 'Email', Icons.email),
                      const SizedBox(height: 20),
                      _buildTextField(
                          _passwordController, 'Password', Icons.lock,
                          isPassword: true),
                      const SizedBox(height: 30),
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : _buildLoginButton(),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                            context, '/register'),
                        child: const Text("Don't have an account? Register",
                            style: TextStyle(color: Colors.white70)),
                      ),
                    ],
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
