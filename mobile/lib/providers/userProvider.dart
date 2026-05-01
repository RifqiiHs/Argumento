import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/models/User.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  bool _isAuthLoading = false;
  String _errorMessage = '';

  User? get user => _user;
  bool get authLoading => _isAuthLoading;
  String get errorMessage => _errorMessage;

  Future<void> getUser() async {
    if (_user != null) {
      return;
    }
    _isAuthLoading = true;
    notifyListeners();

    try {
      final getMeUri = Uri.parse('http://localhost:3000/api/auth');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final getMeResponse = await http.get(
        getMeUri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      final data = jsonDecode(getMeResponse.body);
      _user = User.fromJson(data['user']);
    } catch (error) {
      _isAuthLoading = false;
    } finally {
      _isAuthLoading = false;
      notifyListeners();
    }
  }

  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    _user = null;
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    _isAuthLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username.trim(), 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final prefs = await SharedPreferences.getInstance();

        if (data['token'] != null) {
          await prefs.setString('token', data['token']);
          await getUser();
        }
      } else {
        _errorMessage = 'Invalid email or password';
      }
    } catch (e) {
      _errorMessage = 'Connection lost. Server down?';
    } finally {
      _isAuthLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(
    String username,
    String email,
    String password,
    String confirmPassword,
  ) async {
    _isAuthLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      if (password != confirmPassword) {
        _errorMessage = 'Password and Confirmation Password do not match';
        _isAuthLoading = false;
        notifyListeners();
        return;
      }

      final response = await http.post(
        Uri.parse('http://localhost:3000/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username.trim(),
          'email': email.trim(),
          'password': password,
        }),
      );
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final prefs = await SharedPreferences.getInstance();

        if (data['token'] != null) {
          await prefs.setString('token', data['token']);
          await getUser();
        }
      } else {
        _errorMessage = 'Registration failed';
      }
    } catch (e) {
      _errorMessage = 'Connection lost. Server down?';
    } finally {
      _isAuthLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUser() async {
    _isAuthLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final response = await http.get(
        Uri.parse('http://localhost:3000/api/auth'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _user = User.fromJson(data['user']);
      } else {
        _errorMessage = 'Failed to update user';
      }
    } catch (e) {
      _errorMessage = 'Connection error while updating';
    } finally {
      _isAuthLoading = false;
      notifyListeners();
    }
  }
}
