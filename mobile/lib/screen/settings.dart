import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/providers/userProvider.dart';
import 'package:mobile/screen/login.dart';
import 'package:mobile/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isThemeDark = true;
  bool _isNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.firaCode(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Section
              Text(
                'Account',
                style: GoogleFonts.firaCode(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[800]!),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        userProvider.user?.username ?? 'Unknown',
                        style: GoogleFonts.firaCode(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        userProvider.user?.email ?? 'Unknown',
                        style: GoogleFonts.firaCode(color: Colors.grey[400]),
                      ),
                      trailing: const Icon(
                        Icons.account_circle,
                        color: AppColors.neon,
                      ),
                    ),
                    Divider(color: Colors.grey[800]!),
                    ListTile(
                      title: Text(
                        'Verification Status',
                        style: GoogleFonts.firaCode(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        userProvider.user?.isVerified == true
                            ? '✓ Verified'
                            : '⚠ Not Verified',
                        style: GoogleFonts.firaCode(
                          color: userProvider.user?.isVerified == true
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      trailing: Icon(
                        userProvider.user?.isVerified == true
                            ? Icons.check_circle
                            : Icons.warning,
                        color: userProvider.user?.isVerified == true
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Danger Zone
              Text(
                'Danger Zone',
                style: GoogleFonts.firaCode(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Logout',
                        style: GoogleFonts.firaCode(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      trailing: const Icon(Icons.logout, color: Colors.red),
                      onTap: _handleLogout,
                    ),
                    Divider(color: Colors.red.withOpacity(0.3)),
                    ListTile(
                      title: Text(
                        'Delete Account',
                        style: GoogleFonts.firaCode(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      subtitle: Text(
                        'This action cannot be undone',
                        style: GoogleFonts.firaCode(
                          color: Colors.red.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                      trailing: const Icon(Icons.delete, color: Colors.red),
                      onTap: _handleDeleteAccount,
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

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.firaCode(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: GoogleFonts.firaCode()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Logout',
              style: GoogleFonts.firaCode(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (mounted) {
        final userProvider = context.read<UserProvider>();
        await userProvider.logOut();
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      }
    }
  }

  Future<void> _handleDeleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Account',
          style: GoogleFonts.firaCode(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: Text(
          'This will permanently delete your account and all associated data. This action cannot be undone.',
          style: GoogleFonts.firaCode(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: GoogleFonts.firaCode()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Delete',
              style: GoogleFonts.firaCode(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString("token");

        final response = await http.delete(
          Uri.parse('http://localhost:3000/api/auth'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          if (mounted) {
            final userProvider = context.read<UserProvider>();
            await userProvider.logOut();
            if (mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            }
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }
}
