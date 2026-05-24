import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/app_state.dart';
import '../../../../core/utils/models.dart';
import '../../../../core/utils/widgets.dart';
import '../../../shared/bottom_nav.dart';

const _tabs = [
  {'key': 'totalExp', 'label': 'EXP'},
  {'key': 'bestStreak', 'label': 'STREAK'},
  {'key': 'postsProcessed', 'label': 'POSTS'},
  {'key': 'postsCorrect', 'label': 'CORRECT'},
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
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final data = await ApiService().getLeaderboard(_activeTab);
      setState(() { _entries = data; _isLoading = false; });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  void _switchTab(String tab) {
    setState(() => _activeTab = tab);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state.user;
    final accentColor = AppTheme.getAccentColor(user?.activeTheme ?? 'theme_green');
    final myRank = user != null
        ? _entries.indexWhere((e) => e.id == user.id)
        : -1;

    return Scaffold(
      backgroundColor: AppColors.zinc950,
      appBar: ArgumentoAppBar(title: 'Leaderboard'),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      body: Column(
        children: [
          // Tab selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.zinc800))),
            child: Row(
              children: _tabs.map((t) {
                final isActive = t['key'] == _activeTab;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _switchTab(t['key']!),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: isActive ? accentColor : AppColors.zinc900,
                        border: Border.all(color: isActive ? accentColor : AppColors.zinc700),
                      ),
                      child: Text(
                        t['label']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Courier New',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isActive ? Colors.black : AppColors.zinc400,
                          letterSpacing: 1,
                        ),
                      ),
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
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.08),
                border: Border(bottom: BorderSide(color: accentColor.withOpacity(0.4))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'YOUR RANK: #${myRank + 1}',
                    style: TextStyle(fontFamily: 'Courier New', fontSize: 12, fontWeight: FontWeight.bold, color: accentColor, letterSpacing: 1),
                  ),
                  Text(
                    '${_entries[myRank].getValueByField(_activeTab)} ${_activeTab == 'totalExp' ? 'XP' : ''}',
                    style: TextStyle(fontFamily: 'Courier New', fontSize: 12, color: accentColor),
                  ),
                ],
              ),
            ),

          // List
          Expanded(
            child: _isLoading
                ? LoadingOverlay(accentColor: accentColor)
                : _entries.isEmpty
                    ? const EmptyState(title: 'No data yet', subtitle: 'Be the first on the leaderboard!')
                    : ListView.builder(
                        itemCount: _entries.length,
                        itemBuilder: (ctx, i) {
                          final entry = _entries[i];
                          final isMe = entry.id == user?.id;
                          final isTop3 = i < 3;

                          return GestureDetector(
                            onTap: () => context.go('/profile/${entry.id}'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: isMe ? accentColor.withOpacity(0.05) : Colors.transparent,
                                border: Border(
                                  bottom: BorderSide(color: AppColors.zinc900),
                                  left: isMe ? BorderSide(color: accentColor, width: 3) : BorderSide.none,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Rank
                                  SizedBox(
                                    width: 36,
                                    child: Text(
                                      isTop3 ? ['🥇', '🥈', '🥉'][i] : '#${i + 1}',
                                      style: TextStyle(
                                        fontFamily: 'Courier New',
                                        fontSize: isTop3 ? 20 : 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.zinc500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Username
                                  Expanded(
                                    child: Text(
                                      entry.username,
                                      style: TextStyle(
                                        fontFamily: 'Courier New',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isMe ? accentColor : Colors.white,
                                      ),
                                    ),
                                  ),
                                  // Value
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${entry.getValueByField(_activeTab)}',
                                        style: TextStyle(
                                          fontFamily: 'Courier New',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          color: isMe ? accentColor : Colors.white,
                                        ),
                                      ),
                                      Text(
                                        _activeTab.toUpperCase().replaceAll('_', ' '),
                                        style: const TextStyle(fontFamily: 'Courier New', fontSize: 9, color: AppColors.zinc500, letterSpacing: 1),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
