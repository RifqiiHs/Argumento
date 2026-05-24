import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/app_state.dart';
import '../../../../core/utils/models.dart';
import '../../../../core/utils/widgets.dart';
import '../../../shared/bottom_nav.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<ShopThemeModel> _themes = [];
  bool _isLoading = true;
  String? _processingId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final themes = await ApiService().getShopThemes();
      setState(() { _themes = themes; _isLoading = false; });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _buy(ShopThemeModel theme) async {
    setState(() => _processingId = theme.id);
    try {
      await ApiService().buyShopItem('themes', theme.id);
      await context.read<UserCubit>().invalidateUser();
      if (mounted) ArgumentoSnackBar.show(context, '${theme.name} purchased!');
    } catch (e) {
      if (mounted) ArgumentoSnackBar.show(context, 'Purchase failed. Insufficient coins?', isError: true);
    } finally {
      if (mounted) setState(() => _processingId = null);
    }
  }

  Future<void> _equip(ShopThemeModel theme) async {
    setState(() => _processingId = theme.id);
    try {
      await ApiService().equipTheme(theme.id);
      await context.read<UserCubit>().invalidateUser();
      // Update theme cubit immediately
      if (mounted) {
        context.read<ThemeCubit>().setTheme(theme.id);
        ArgumentoSnackBar.show(context, '${theme.name} equipped!');
      }
    } catch (e) {
      if (mounted) ArgumentoSnackBar.show(context, 'Failed to equip theme.', isError: true);
    } finally {
      if (mounted) setState(() => _processingId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state.user;
    final accentColor = AppTheme.getAccentColor(user?.activeTheme ?? 'theme_green');

    return Scaffold(
      backgroundColor: AppColors.zinc950,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.zinc950,
            border: Border(bottom: BorderSide(color: AppColors.zinc800)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ITEM SHOP',
                    style: TextStyle(fontFamily: 'Courier New', fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.zinc900,
                      border: Border.all(color: accentColor.withOpacity(0.6)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.monetization_on, color: accentColor, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          '${user?.totalCoins ?? 0}',
                          style: TextStyle(fontFamily: 'Courier New', fontSize: 16, fontWeight: FontWeight.w900, color: accentColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: _isLoading
          ? LoadingOverlay(accentColor: accentColor)
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section header
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('THEMES', style: TextStyle(fontFamily: 'Courier New', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.zinc500, letterSpacing: 2)),
                        SizedBox(height: 4),
                        Text('Change the accent color of the interface.', style: TextStyle(fontFamily: 'Courier New', fontSize: 12, color: AppColors.zinc600)),
                      ],
                    ),
                  ),

                  // Themes grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                    children: _themes.map((theme) {
                      final themeColor = Color(int.parse('0xFF${theme.hex.replaceAll('#', '')}'));
                      final isOwned = user?.inventory.themes.contains(theme.id) ?? false;
                      final isEquipped = user?.activeTheme == theme.id;
                      final isProcessing = _processingId == theme.id;

                      return _ThemeCard(
                        theme: theme,
                        themeColor: themeColor,
                        isOwned: isOwned,
                        isEquipped: isEquipped,
                        isProcessing: isProcessing,
                        userCoins: user?.totalCoins ?? 0,
                        onBuy: () => _buy(theme),
                        onEquip: () => _equip(theme),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),
                  // Earn coins hint
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.zinc900.withOpacity(0.3),
                      border: Border.all(color: AppColors.zinc800),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('HOW TO EARN COINS', style: TextStyle(fontFamily: 'Courier New', fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.zinc500, letterSpacing: 2)),
                        const SizedBox(height: 10),
                        _CoinTip(icon: Icons.check_circle_outline, label: 'Correct answer', value: '100 coins', color: AppColors.green500),
                        const SizedBox(height: 6),
                        _CoinTip(icon: Icons.cancel_outlined, label: 'Incorrect answer', value: '50 coins', color: Colors.red),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final ShopThemeModel theme;
  final Color themeColor;
  final bool isOwned;
  final bool isEquipped;
  final bool isProcessing;
  final int userCoins;
  final VoidCallback onBuy;
  final VoidCallback onEquip;

  const _ThemeCard({
    required this.theme,
    required this.themeColor,
    required this.isOwned,
    required this.isEquipped,
    required this.isProcessing,
    required this.userCoins,
    required this.onBuy,
    required this.onEquip,
  });

  @override
  Widget build(BuildContext context) {
    final canAfford = userCoins >= theme.price;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.zinc950,
        border: Border.all(color: isEquipped ? themeColor : AppColors.zinc700, width: isEquipped ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Color preview
          Container(
            height: 72,
            color: themeColor.withOpacity(0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 40, height: 40, decoration: BoxDecoration(color: themeColor, shape: BoxShape.circle)),
                const SizedBox(height: 6),
                if (isEquipped)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: themeColor.withOpacity(0.2), border: Border.all(color: themeColor.withOpacity(0.6))),
                    child: Text('EQUIPPED', style: TextStyle(fontFamily: 'Courier New', fontSize: 8, fontWeight: FontWeight.bold, color: themeColor, letterSpacing: 1)),
                  ),
              ],
            ),
          ),

          // Info
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(theme.name.toUpperCase(), style: const TextStyle(fontFamily: 'Courier New', fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                const SizedBox(height: 2),
                Text(theme.description, style: const TextStyle(fontFamily: 'Courier New', fontSize: 10, color: AppColors.zinc500)),
                const SizedBox(height: 10),
                if (isOwned) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isEquipped || isProcessing ? null : onEquip,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isEquipped ? AppColors.zinc800 : themeColor,
                        foregroundColor: isEquipped ? AppColors.zinc500 : Colors.black,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        disabledBackgroundColor: AppColors.zinc800,
                      ),
                      child: Text(
                        isEquipped ? 'ACTIVE' : (isProcessing ? '...' : 'EQUIP'),
                        style: const TextStyle(fontFamily: 'Courier New', fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                    ),
                  ),
                ] else ...[
                  Row(
                    children: [
                      Icon(Icons.monetization_on, color: canAfford ? themeColor : AppColors.zinc600, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        '${theme.price}',
                        style: TextStyle(fontFamily: 'Courier New', fontSize: 12, fontWeight: FontWeight.bold, color: canAfford ? themeColor : AppColors.zinc600),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (canAfford && !isProcessing) ? onBuy : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: canAfford ? themeColor : AppColors.zinc800,
                            foregroundColor: Colors.black,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            disabledBackgroundColor: AppColors.zinc800,
                          ),
                          child: Text(
                            isProcessing ? '...' : 'BUY',
                            style: TextStyle(fontFamily: 'Courier New', fontSize: 10, fontWeight: FontWeight.bold, color: canAfford ? Colors.black : AppColors.zinc600, letterSpacing: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CoinTip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _CoinTip({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontFamily: 'Courier New', fontSize: 12, color: AppColors.zinc400)),
        const Spacer(),
        Text(value, style: TextStyle(fontFamily: 'Courier New', fontSize: 12, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
