import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/screen/login.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmationPasswordController = TextEditingController();
  
  bool _isLoading = false;
  String _errorMessage = '';

  final url = Uri.parse('https://argumento-api.vercel.app/api/auth/register');
  Future<void> _login() async {
    _isLoading = true;
    try {
      if (_passwordController.text != _confirmationPasswordController.text)
      {
        setState(() {
          _errorMessage = 'Password and Confirmation Password do not match';
        });
        return;
      }
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200)
      {
        final data = jsonDecode(response.body);
        
        final prefs = await SharedPreferences.getInstance();

        if (data['token'] != null) {
          await prefs.setString('token', data['token']);
        }
        if (mounted)
        {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
        }
      } else {
        setState(() {
          _errorMessage = 'Invalid email or password';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Connection lost. Server down?';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
                'Register',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            const SizedBox(height: 16),
            TextField(
                controller: _usernameController,
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: const TextStyle(color: Colors.greenAccent),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[800]!)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent)),
                ),
              ),

            const SizedBox(height: 16),
            TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.greenAccent),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[800]!)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent)),
                ),
            ),

            const SizedBox(height: 16),
            TextField(
                controller: _passwordController,
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.greenAccent),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[800]!)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmationPasswordController,
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Confirmation Password',
                  labelStyle: const TextStyle(color: Colors.greenAccent),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[800]!)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent)),
                ),
              ),
              const SizedBox(height: 16),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text(
                  'Dont have an account?',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    decoration: TextDecoration.underline, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),              
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _login, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(),
                ),
                child: _isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                    : const Text('Login', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              )
          ],
        ),
      )
    )
   );
  }
}