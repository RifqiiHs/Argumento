import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/components/ui/dashboard_shell.dart';
import 'package:mobile/providers/userProvider.dart';
import 'package:mobile/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late Future<Map<String, dynamic>?> _shopFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _shopFuture = _fetchShop();
  }

  Future<Map<String, dynamic>?> _fetchShop() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final response = await http.get(
        Uri.parse('http://localhost:3000/api/shops'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['shop'];
      }

      throw Exception('Failed to fetch shop');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> _buyItem(Map<String, dynamic> item, String type) async {
    final userProvider = context.read<UserProvider>();
    final user = userProvider.user;

    if (user == null) return;

    if (user.totalCoins < (item['price'] as int)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Insufficient coins')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final response = await http.put(
        Uri.parse('http://localhost:3000/api/shops'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },

        body: jsonEncode({'type': type, 'itemId': item['id']}),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Purchased ${item['name']}')));
          await userProvider.updateUser();
          setState(() {
            _shopFuture = _fetchShop();
          });
        }
      } else {
        throw Exception('Failed to purchase item');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ignore: unused_element
  Future<void> _equipTheme(Map<String, dynamic> item) async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final response = await http.put(
        Uri.parse('http://localhost:3000/api/users/theme'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'itemId': item['id']}),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Equipped ${item['name']}')));
          final userProvider = context.read<UserProvider>();
          await userProvider.updateUser();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;

    return DashboardShell(
      title: 'Shop',
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _shopFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (user == null || !user.isVerified) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Restricted Area',
                      style: GoogleFonts.firaCode(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Verify your email to access the shop',
                      style: GoogleFonts.firaCode(color: Colors.grey[400]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading shop',
                style: GoogleFonts.firaCode(color: Colors.red),
              ),
            );
          }

          final shopData = snapshot.data;
          final themes = (shopData?['themes'] as List?) ?? [];

          if (themes.isEmpty) {
            return Center(
              child: Text(
                'No items available',
                style: GoogleFonts.firaCode(color: Colors.grey[400]),
              ),
            );
          }

          return Column(
            children: [
              // Coins Display
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber[700]!, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Available Coins',
                        style: GoogleFonts.firaCode(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[400],
                        ),
                      ),
                      Text(
                        user.totalCoins.toString(),
                        style: GoogleFonts.firaCode(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[400],
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Themes Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: themes.length,
                  itemBuilder: (context, index) {
                    final theme = themes[index] as Map<String, dynamic>;
                    final themeId = theme['id']?.toString() ?? '';
                    final isAffordable =
                        user.totalCoins >= (theme['price'] as int);
                    final isOwned = user.inventory.themes.contains(themeId);
                    final isEquipped = user.activeTheme == themeId;

                    final String ctaLabel;
                    final Color ctaColor;
                    final bool isDisabled;

                    if (isEquipped) {
                      ctaLabel = 'Equipped';
                      ctaColor = Colors.grey[700]!;
                      isDisabled = true;
                    } else if (isOwned) {
                      ctaLabel = 'Equip';
                      ctaColor = AppColors.demoModeBlue;
                      isDisabled = false;
                    } else {
                      ctaLabel = 'Buy';
                      ctaColor = isAffordable
                          ? AppColors.neon
                          : Colors.grey[700]!;
                      isDisabled = !isAffordable;
                    }

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Color(
                            int.parse(
                              '0xff${theme['hex'].toString().replaceFirst('#', '')}',
                            ),
                          ),
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Color Preview
                            Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Color(
                                  int.parse(
                                    '0xff${theme['hex'].toString().replaceFirst('#', '')}',
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Theme Name
                            Text(
                              theme['name'] ?? 'Unknown',
                              style: GoogleFonts.firaCode(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              theme['description'] ?? 'Unknown',
                              style: GoogleFonts.firaCode(color: Colors.white),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            // Price
                            Text(
                              '${theme['price']} coins',
                              style: GoogleFonts.firaCode(
                                color: isAffordable
                                    ? Colors.amber[400]
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            // Buy/Equip Button
                            SizedBox(
                              width: double.infinity,
                              height: 32,
                              child: ElevatedButton(
                                onPressed: _isLoading || isDisabled
                                    ? null
                                    : () {
                                        if (isOwned) {
                                          _equipTheme(theme);
                                        } else {
                                          _buyItem(theme, 'themes');
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ctaColor,
                                  disabledBackgroundColor: Colors.grey[700],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: Text(
                                  _isLoading ? 'Loading...' : ctaLabel,
                                  style: GoogleFonts.firaCode(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
