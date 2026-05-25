import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final themes = await ApiService().getShopThemes();
      setState(() { _themes = themes; _isLoading = false; });
    } catch (_) { setState(() => _isLoading = false); }
  }

  Future<void> _buy(ShopThemeModel theme) async {
    setState(() => _processingId = theme.id);
    try {
      await ApiService().buyShopItem('themes', theme.id);
      await context.read<UserCubit>().invalidateUser();
      if (mounted) ArgumentoSnackBar.show(context, '${theme.name} purchased!');
    } catch (_) {
      if (mounted) ArgumentoSnackBar.show(context, 'Purchase failed — insufficient coins?', isError: true);
    } finally {
      if (mounted) setState(() => _processingId = null);
    }
  }

  Future<void> _equip(ShopThemeModel theme) async {
    setState(() => _processingId = theme.id);
    try {
      await ApiService().equipTheme(theme.id);
      await context.read<UserCubit>().invalidateUser();
      if (mounted) {
        context.read<ThemeCubit>().setTheme(theme.id);
        ArgumentoSnackBar.show(context, '${theme.name} equipped!');
      }
    } catch (_) {
      if (mounted) ArgumentoSnackBar.show(context, 'Failed to equip theme.', isError: true);
    } finally {
      if (mounted) setState(() => _processingId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state.user;
    final accent = AppTheme.getAccentColor(user?.activeTheme ?? 'theme_green');

    return Scaffold(
      backgroundColor: AppColors.bg900,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: Container(
          decoration: const BoxDecoration(color: AppColors.bg900, border: Border(bottom: BorderSide(color: AppColors.border))),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Item Shop', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(color: accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10), border: Border.all(color: accent.withValues(alpha: 0.3))),
                    child: Row(children: [
                      Icon(Icons.toll_rounded, color: accent, size: 16),
                      const SizedBox(width: 6),
                      Text('${user?.totalCoins ?? 0}', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: accent)),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: _isLoading
          ? LoadingOverlay(accentColor: accent)
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionLabel(text: 'Interface Themes'),
                  const SizedBox(height: 4),
                  Text('Customize the accent color of the entire interface', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted)),
                  const SizedBox(height: 16),
                  // Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.82,
                    children: _themes.asMap().entries.map((e) {
                      final idx = e.key;
                      final theme = e.value;
                      final themeColor = Color(int.parse('0xFF${theme.hex.replaceAll('#', '')}'));
                      final isOwned = user?.inventory.themes.contains(theme.id) ?? false;
                      final isEquipped = user?.activeTheme == theme.id;
                      return _ThemeCard(
                        theme: theme,
                        themeColor: themeColor,
                        isOwned: isOwned,
                        isEquipped: isEquipped,
                        isProcessing: _processingId == theme.id,
                        userCoins: user?.totalCoins ?? 0,
                        onBuy: () => _buy(theme),
                        onEquip: () => _equip(theme),
                      ).animate().fadeIn(delay: Duration(milliseconds: idx * 60)).scale(begin: const Offset(0.95, 0.95));
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  // Earn coins info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.bg800, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('How to Earn Coins', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        const SizedBox(height: 12),
                        _CoinInfo(icon: Icons.check_circle_rounded, color: AppColors.success, label: 'Correct answer', value: '+100 coins'),
                        const SizedBox(height: 8),
                        _CoinInfo(icon: Icons.cancel_rounded, color: AppColors.error, label: 'Incorrect answer', value: '+50 coins'),
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
  const _ThemeCard({required this.theme, required this.themeColor, required this.isOwned, required this.isEquipped, required this.isProcessing, required this.userCoins, required this.onBuy, required this.onEquip});

  @override
  Widget build(BuildContext context) {
    final canAfford = userCoins >= theme.price;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg800,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isEquipped ? themeColor.withValues(alpha: 0.6) : AppColors.border, width: isEquipped ? 1.5 : 1),
        boxShadow: isEquipped ? [BoxShadow(color: themeColor.withValues(alpha: 0.12), blurRadius: 16, offset: const Offset(0, 4))] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Color preview
          Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [themeColor.withValues(alpha: 0.2), AppColors.bg700], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(width: 36, height: 36, decoration: BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: themeColor.withValues(alpha: 0.4), blurRadius: 10, offset: const Offset(0, 3))])),
              if (isEquipped) ...[
                const SizedBox(height: 6),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: themeColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                    child: Text('Active', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: themeColor))),
              ],
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(theme.name, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Text(theme.description, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
              const SizedBox(height: 10),
              if (isOwned)
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: (isEquipped || isProcessing) ? null : onEquip,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEquipped ? AppColors.bg600 : themeColor,
                      foregroundColor: isEquipped ? AppColors.textMuted : Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: EdgeInsets.zero,
                      disabledBackgroundColor: AppColors.bg600,
                    ),
                    child: Text(isEquipped ? 'Equipped' : (isProcessing ? '...' : 'Equip'),
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                )
              else
                Row(children: [
                  Icon(Icons.toll_rounded, size: 14, color: canAfford ? themeColor : AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text('${theme.price}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: canAfford ? themeColor : AppColors.textMuted)),
                  const Spacer(),
                  SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      onPressed: (canAfford && !isProcessing) ? onBuy : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canAfford ? themeColor : AppColors.bg600,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        disabledBackgroundColor: AppColors.bg600,
                      ),
                      child: Text(isProcessing ? '...' : 'Buy',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: canAfford ? Colors.black : AppColors.textMuted)),
                    ),
                  ),
                ]),
            ]),
          ),
        ],
      ),
    );
  }
}

class _CoinInfo extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  const _CoinInfo({required this.icon, required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, color: color, size: 16),
      const SizedBox(width: 10),
      Text(label, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
      const Spacer(),
      Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
    ]);
  }
}
