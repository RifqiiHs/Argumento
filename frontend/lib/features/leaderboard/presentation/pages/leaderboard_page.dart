import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/app_state.dart';
import '../../../../core/utils/models.dart';
import '../../../../core/utils/widgets.dart';
import '../../../shared/bottom_nav.dart';

const _tabs = [
  {'key': 'totalExp',       'label': 'EXP',     'icon': Icons.bolt_rounded},
  {'key': 'bestStreak',     'label': 'Streak',   'icon': Icons.local_fire_department_rounded},
  {'key': 'postsProcessed', 'label': 'Posts',    'icon': Icons.article_rounded},
  {'key': 'postsCorrect',   'label': 'Correct',  'icon': Icons.gps_fixed_rounded},
];

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});
  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  String _activeTab = 'totalExp';
  List<LeaderboardEntryModel> _entries = [];
  bool _isLoading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final data = await ApiService().getLeaderboard(_activeTab);
      setState(() { _entries = data; _isLoading = false; });
    } catch (_) { setState(() => _isLoading = false); }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state.user;
    final accent = AppTheme.getAccentColor(user?.activeTheme ?? 'theme_green');
    final myRank = user != null ? _entries.indexWhere((e) => e.id == user.id) : -1;

    return Scaffold(
      backgroundColor: AppColors.bg900,
      appBar: ArgumentoAppBar(title: 'Leaderboard'),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      body: Column(
        children: [
          // Tab bar
          Container(
            padding: const EdgeInsets.all(12),
            color: AppColors.bg800,
            child: Row(
              children: _tabs.map((t) {
                final isActive = t['key'] == _activeTab;
                return Expanded(
                  child: GestureDetector(
                    onTap: () { setState(() => _activeTab = t['key'] as String); _load(); },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isActive ? accent.withValues(alpha: 0.12) : AppColors.bg700,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isActive ? accent.withValues(alpha: 0.4) : AppColors.border),
                      ),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(t['icon'] as IconData, size: 16, color: isActive ? accent : AppColors.textMuted),
                        const SizedBox(height: 3),
                        Text(t['label'] as String,
                            style: GoogleFonts.inter(fontSize: 10, fontWeight: isActive ? FontWeight.w700 : FontWeight.w400, color: isActive ? accent : AppColors.textMuted),
                            overflow: TextOverflow.ellipsis),
                      ]),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // My rank banner
          if (myRank >= 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(color: accent.withValues(alpha: 0.06), border: Border(bottom: BorderSide(color: accent.withValues(alpha: 0.2)))),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: accent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                    child: Text('You', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: accent)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('Rank #${myRank + 1}',
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        overflow: TextOverflow.ellipsis),
                  ),
                  Text('${_entries[myRank].getValueByField(_activeTab)}${_activeTab == 'totalExp' ? ' XP' : ''}',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: accent)),
                ],
              ),
            ),

          // List
          Expanded(
            child: _isLoading
                ? LoadingOverlay(accentColor: accent)
                : _entries.isEmpty
                    ? EmptyState(
                        title: 'No data yet',
                        subtitle: 'Be the first on the leaderboard!',
                        icon: const Icon(Icons.emoji_events_rounded, size: 40, color: AppColors.textMuted))
                    : ListView.builder(
                        itemCount: _entries.length,
                        itemBuilder: (ctx, i) {
                          final entry = _entries[i];
                          final isMe = entry.id == user?.id;
                          return GestureDetector(
                            onTap: () => context.go('/profile/${entry.id}'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: isMe ? accent.withValues(alpha: 0.04) : Colors.transparent,
                                border: Border(
                                  bottom: const BorderSide(color: AppColors.border),
                                  left: isMe ? BorderSide(color: accent, width: 3) : BorderSide.none,
                                ),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 36,
                                    child: i < 3
                                        ? Text(['🥇','🥈','🥉'][i], style: const TextStyle(fontSize: 20), textAlign: TextAlign.center)
                                        : Text('#${i+1}',
                                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMuted),
                                            textAlign: TextAlign.center),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    width: 36, height: 36,
                                    decoration: BoxDecoration(
                                      color: isMe ? accent.withValues(alpha: 0.15) : AppColors.bg700,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(child: Text(
                                      entry.username.isNotEmpty ? entry.username.substring(0, 1).toUpperCase() : '?',
                                      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: isMe ? accent : AppColors.textSecondary),
                                    )),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(entry.username,
                                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: isMe ? accent : AppColors.textPrimary),
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                    Text('${entry.getValueByField(_activeTab)}',
                                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: isMe ? accent : AppColors.textPrimary)),
                                    Text(_activeTab.replaceAll('_', ' '),
                                        style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted)),
                                  ]),
                                ],
                              ),
                            ).animate().fadeIn(delay: Duration(milliseconds: i < 10 ? i * 30 : 0)),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
