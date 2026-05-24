import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/app_state.dart';
import '../../../../core/utils/models.dart';
import '../../../../core/utils/widgets.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? _profileUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final user = await ApiService().getUserById(widget.userId);
      setState(() { _profileUser = user; _isLoading = false; });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserCubit>().state.user;
    final accentColor = AppTheme.getAccentColor(currentUser?.activeTheme ?? 'theme_green');
    final profileAccent = AppTheme.getAccentColor(_profileUser?.activeTheme ?? 'theme_green');
    final isOwnProfile = _profileUser?.id == currentUser?.id;

    return Scaffold(
      backgroundColor: AppColors.zinc950,
      appBar: AppBar(
        backgroundColor: AppColors.zinc950,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.zinc400), onPressed: () => Navigator.of(context).pop()),
        title: const Text('PROFILE', style: TextStyle(fontFamily: 'Courier New', fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppColors.zinc800)),
      ),
      body: _isLoading
          ? LoadingOverlay(accentColor: accentColor)
          : _profileUser == null
              ? const EmptyState(title: 'User not found')
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile header
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: profileAccent, width: 2),
                          color: profileAccent.withOpacity(0.05),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(border: Border.all(color: profileAccent.withOpacity(0.5)), color: profileAccent.withOpacity(0.1)),
                                      child: Text('OPERATOR', style: TextStyle(fontFamily: 'Courier New', fontSize: 9, fontWeight: FontWeight.bold, color: profileAccent, letterSpacing: 1.5)),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _profileUser!.username.toUpperCase(),
                                      style: const TextStyle(fontFamily: 'Courier New', fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(color: profileAccent, shape: BoxShape.rectangle),
                                  child: Center(
                                    child: Text(
                                      _profileUser!.username.substring(0, 1).toUpperCase(),
                                      style: const TextStyle(fontFamily: 'Courier New', fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, color: profileAccent, size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  'Since ${_profileUser!.createdAt != null ? DateFormat('MMM yyyy').format(_profileUser!.createdAt!) : 'Unknown'}',
                                  style: TextStyle(fontFamily: 'Courier New', fontSize: 12, color: profileAccent),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Stats grid
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.5,
                        children: [
                          StatCard(label: 'Total EXP', value: '${_profileUser!.totalExp}', accentColor: profileAccent, icon: Icon(Icons.bar_chart, color: profileAccent, size: 18)),
                          StatCard(label: 'Best Streak', value: '${_profileUser!.bestStreak}', subValue: 'days', accentColor: profileAccent, icon: Icon(Icons.local_fire_department, color: profileAccent, size: 18)),
                          StatCard(label: 'Posts Reviewed', value: '${_profileUser!.postsHistory.length}', accentColor: profileAccent, icon: Icon(Icons.description, color: profileAccent, size: 18)),
                          StatCard(
                            label: 'Accuracy',
                            value: _profileUser!.postsHistory.isNotEmpty
                                ? '${((_profileUser!.postsCorrect / _profileUser!.postsHistory.length) * 100).toStringAsFixed(1)}%'
                                : 'N/A',
                            accentColor: profileAccent,
                            icon: Icon(Icons.track_changes, color: profileAccent, size: 18),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Campaign progress
                      if (_profileUser!.campaignProgress.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(border: Border.all(color: AppColors.zinc800)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('CAMPAIGN PROGRESS', style: TextStyle(fontFamily: 'Courier New', fontSize: 10, color: AppColors.zinc500, letterSpacing: 2, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              ..._profileUser!.campaignProgress.map((cp) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Icon(cp.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked, color: cp.isCompleted ? profileAccent : AppColors.zinc600, size: 18),
                                    const SizedBox(width: 10),
                                    Text(cp.campaignId.replaceAll('_', ' ').toUpperCase(), style: TextStyle(fontFamily: 'Courier New', fontSize: 12, color: cp.isCompleted ? profileAccent : AppColors.zinc500, fontWeight: FontWeight.bold)),
                                    const Spacer(),
                                    Text('${cp.levelsCompleted.length} levels', style: const TextStyle(fontFamily: 'Courier New', fontSize: 11, color: AppColors.zinc500)),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Skills
                      if (_profileUser!.stats.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(border: Border.all(color: AppColors.zinc800)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('SKILL RATINGS', style: TextStyle(fontFamily: 'Courier New', fontSize: 10, color: AppColors.zinc500, letterSpacing: 2, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              ..._profileUser!.stats.map((s) {
                                final pct = s.total > 0 ? s.correct / s.total : 0.0;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(s.name.toUpperCase(), style: const TextStyle(fontFamily: 'Courier New', fontSize: 10, color: AppColors.zinc400, letterSpacing: 1)),
                                          Text('${(pct * 100).toStringAsFixed(0)}%', style: TextStyle(fontFamily: 'Courier New', fontSize: 11, color: profileAccent, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      LinearProgressIndicator(value: pct, backgroundColor: AppColors.zinc800, valueColor: AlwaysStoppedAnimation<Color>(profileAccent), minHeight: 4),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),

                      if (isOwnProfile)
                        AccentButton(
                          label: 'Edit Settings',
                          accentColor: profileAccent,
                          onPressed: () => context.go('/settings'),
                        ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
    );
  }
}
