import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final user = await ApiService().getUserById(widget.userId);
      setState(() { _profileUser = user; _isLoading = false; });
    } catch (_) { setState(() => _isLoading = false); }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserCubit>().state.user;
    final accent = AppTheme.getAccentColor(currentUser?.activeTheme ?? 'theme_green');
    final profileAccent = AppTheme.getAccentColor(_profileUser?.activeTheme ?? 'theme_green');
    final isOwnProfile = _profileUser?.id == currentUser?.id;

    return Scaffold(
      backgroundColor: AppColors.bg900,
      appBar: AppBar(
        backgroundColor: AppColors.bg900,
        elevation: 0,
        leading: IconButton(
          icon: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.bg700, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: AppColors.textSecondary)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Profile', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppColors.border)),
      ),
      body: _isLoading
          ? LoadingOverlay(accentColor: accent)
          : _profileUser == null
              ? const EmptyState(title: 'User not found')
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Profile hero
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [profileAccent.withValues(alpha: 0.1), AppColors.bg800], begin: Alignment.topLeft, end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: profileAccent.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 64, height: 64,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [profileAccent, profileAccent.withValues(alpha: 0.6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [BoxShadow(color: profileAccent.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
                              ),
                              child: Center(child: Text(_profileUser!.username.substring(0, 1).toUpperCase(),
                                  style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.black))),
                            ),
                            const SizedBox(width: 16),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(_profileUser!.username, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis, maxLines: 1),
                              const SizedBox(height: 4),
                              Text(
                                'Member since ${_profileUser!.createdAt != null ? DateFormat('MMM yyyy').format(_profileUser!.createdAt!) : 'Unknown'}',
                                style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                              ),
                              const SizedBox(height: 8),
                              StatusBadge(label: '${_profileUser!.totalExp} XP', color: profileAccent),
                            ])),
                          ],
                        ),
                      ).animate().fadeIn(),
                      const SizedBox(height: 16),

                      // Stats grid
                      GridView.count(
                        crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.5,
                        children: [
                          StatCard(label: 'Best Streak', value: '${_profileUser!.bestStreak}', subValue: 'days', accentColor: profileAccent, icon: Icon(Icons.local_fire_department_rounded, color: profileAccent, size: 16)),
                          StatCard(label: 'Posts Reviewed', value: '${_profileUser!.postsHistory.length}', accentColor: profileAccent, icon: Icon(Icons.article_rounded, color: profileAccent, size: 16)),
                          StatCard(label: 'Correct', value: '${_profileUser!.postsCorrect}', accentColor: profileAccent, icon: Icon(Icons.check_circle_rounded, color: profileAccent, size: 16)),
                          StatCard(
                            label: 'Accuracy',
                            value: _profileUser!.postsHistory.isNotEmpty ? '${((_profileUser!.postsCorrect / _profileUser!.postsHistory.length) * 100).toStringAsFixed(1)}%' : 'N/A',
                            accentColor: profileAccent,
                            icon: Icon(Icons.gps_fixed_rounded, color: profileAccent, size: 16),
                          ),
                        ],
                      ).animate().fadeIn(delay: 100.ms),
                      const SizedBox(height: 16),

                      // Campaign progress
                      if (_profileUser!.campaignProgress.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: AppColors.bg800, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Campaign Progress', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2),
                              const SizedBox(height: 12),
                              ..._profileUser!.campaignProgress.map((cp) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(children: [
                                  Icon(cp.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                      color: cp.isCompleted ? profileAccent : AppColors.textMuted, size: 18),
                                  const SizedBox(width: 10),
                                  Expanded(child: Text(cp.campaignId.replaceAll('_', ' '), style: GoogleFonts.inter(fontSize: 13, color: cp.isCompleted ? profileAccent : AppColors.textSecondary, fontWeight: FontWeight.w500))),
                                  Text('${cp.levelsCompleted.length} levels', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2),
                                ]),
                              )),
                            ],
                          ),
                        ).animate().fadeIn(delay: 200.ms),
                        const SizedBox(height: 12),
                      ],

                      // Skills
                      if (_profileUser!.stats.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: AppColors.bg800, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Skill Ratings', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2),
                              const SizedBox(height: 12),
                              ..._profileUser!.stats.map((s) {
                                final pct = s.total > 0 ? s.correct / s.total : 0.0;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Text(s.name, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2),
                                      Text('${(pct * 100).toStringAsFixed(0)}%', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: profileAccent),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2),
                                    ]),
                                    const SizedBox(height: 4),
                                    ClipRRect(borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(value: pct, backgroundColor: AppColors.bg600, valueColor: AlwaysStoppedAnimation<Color>(profileAccent), minHeight: 5)),
                                  ]),
                                );
                              }),
                            ],
                          ),
                        ).animate().fadeIn(delay: 250.ms),
                        const SizedBox(height: 16),
                      ],

                      if (isOwnProfile) ...[
                        AccentButton(label: 'Edit Settings', accentColor: profileAccent, onPressed: () => context.go('/settings')),
                        const SizedBox(height: 40),
                      ],
                    ],
                  ),
                ),
    );
  }
}
