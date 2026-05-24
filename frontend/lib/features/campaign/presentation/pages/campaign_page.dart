import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/app_state.dart';
import '../../../../core/utils/models.dart';
import '../../../../core/utils/widgets.dart';
import '../../../shared/bottom_nav.dart';

class CampaignPage extends StatefulWidget {
  const CampaignPage({super.key});

  @override
  State<CampaignPage> createState() => _CampaignPageState();
}

class _CampaignPageState extends State<CampaignPage> {
  List<CampaignModel> _campaigns = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final campaigns = await ApiService().getCampaign();
      setState(() { _campaigns = campaigns; _isLoading = false; });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state.user;
    final accentColor = AppTheme.getAccentColor(user?.activeTheme ?? 'theme_green');

    return Scaffold(
      backgroundColor: AppColors.zinc950,
      appBar: ArgumentoAppBar(title: 'Campaign'),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: _isLoading
          ? LoadingOverlay(accentColor: accentColor)
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Intro text
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.zinc900.withOpacity(0.3),
                      border: Border.all(color: AppColors.zinc800),
                    ),
                    child: const Text(
                      'Complete structured scenarios to master specific reasoning skills. Each campaign focuses on a distinct category of logical and cognitive challenges.',
                      style: TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 13,
                        color: AppColors.zinc400,
                        height: 1.5,
                      ),
                    ),
                  ),

                  // Campaign list
                  ..._campaigns.map((campaign) {
                    final progress = user?.campaignProgress
                        .firstWhere((cp) => cp.campaignId == campaign.id, orElse: () => CampaignProgressModel(campaignId: campaign.id, isCompleted: false, levelsCompleted: []));
                    final isCompleted = progress?.isCompleted ?? false;
                    final levelsCompleted = progress?.levelsCompleted.length ?? 0;
                    final totalLevels = campaign.levels.length;

                    // Check if unlocked
                    final req = campaign.requirement;
                    final isUnlocked = req.isEmpty ||
                        (user?.campaignProgress.any((cp) => cp.campaignId == req && cp.isCompleted) ?? false);

                    return _CampaignCard(
                      campaign: campaign,
                      isUnlocked: isUnlocked,
                      isCompleted: isCompleted,
                      levelsCompleted: levelsCompleted,
                      totalLevels: totalLevels,
                      accentColor: accentColor,
                      user: user,
                      progress: progress,
                    );
                  }),
                ],
              ),
            ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  final CampaignModel campaign;
  final bool isUnlocked;
  final bool isCompleted;
  final int levelsCompleted;
  final int totalLevels;
  final Color accentColor;
  final UserModel? user;
  final CampaignProgressModel? progress;

  const _CampaignCard({
    required this.campaign,
    required this.isUnlocked,
    required this.isCompleted,
    required this.levelsCompleted,
    required this.totalLevels,
    required this.accentColor,
    required this.user,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isUnlocked ? AppColors.zinc950 : AppColors.zinc900.withOpacity(0.3),
        border: Border.all(
          color: isCompleted ? accentColor : (isUnlocked ? AppColors.zinc700 : AppColors.zinc800),
          width: isCompleted ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.zinc800)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isCompleted)
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.15),
                                border: Border.all(color: accentColor.withOpacity(0.5)),
                              ),
                              child: Text(
                                'COMPLETED',
                                style: TextStyle(fontFamily: 'Courier New', fontSize: 8, fontWeight: FontWeight.bold, color: accentColor, letterSpacing: 1.5),
                              ),
                            ),
                          if (!isUnlocked)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                border: Border.all(color: Colors.red.withOpacity(0.5)),
                              ),
                              child: const Text('LOCKED', style: TextStyle(fontFamily: 'Courier New', fontSize: 8, fontWeight: FontWeight.bold, color: Colors.red, letterSpacing: 1.5)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        campaign.title.toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'Courier New',
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: isUnlocked ? Colors.white : AppColors.zinc600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        campaign.description,
                        style: const TextStyle(fontFamily: 'Courier New', fontSize: 12, color: AppColors.zinc500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  isCompleted ? Icons.check_circle : (isUnlocked ? Icons.radio_button_unchecked : Icons.lock),
                  color: isCompleted ? accentColor : (isUnlocked ? AppColors.zinc600 : AppColors.zinc700),
                  size: 28,
                ),
              ],
            ),
          ),

          // Progress bar
          if (isUnlocked)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PROGRESS',
                        style: const TextStyle(fontFamily: 'Courier New', fontSize: 9, color: AppColors.zinc500, letterSpacing: 2),
                      ),
                      Text(
                        '$levelsCompleted / $totalLevels',
                        style: TextStyle(fontFamily: 'Courier New', fontSize: 12, fontWeight: FontWeight.bold, color: accentColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: totalLevels > 0 ? levelsCompleted / totalLevels : 0,
                    backgroundColor: AppColors.zinc800,
                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                    minHeight: 4,
                  ),
                ],
              ),
            ),

          // Level list
          if (isUnlocked)
            ...campaign.levels.entries.toList().asMap().entries.map((entry) {
              final idx = entry.key;
              final levelEntry = entry.value;
              final levelKey = levelEntry.key;
              final level = levelEntry.value;
              final isLevelDone = progress?.levelsCompleted.contains(levelKey) ?? false;

              return GestureDetector(
                onTap: () => context.go('/campaign/${campaign.id}/$levelKey'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: AppColors.zinc800)),
                    color: isLevelDone ? accentColor.withOpacity(0.05) : Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: isLevelDone ? accentColor : AppColors.zinc800,
                        ),
                        child: Center(
                          child: Text(
                            '${idx + 1}',
                            style: TextStyle(
                              fontFamily: 'Courier New',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isLevelDone ? Colors.black : AppColors.zinc400,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          level.title.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Courier New',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isLevelDone ? accentColor : AppColors.zinc300,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Icon(
                        isLevelDone ? Icons.check : Icons.chevron_right,
                        color: isLevelDone ? accentColor : AppColors.zinc600,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              );
            }),

          // Locked message
          if (!isUnlocked)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.lock_outline, color: AppColors.zinc600, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Complete ${campaign.requirement} to unlock',
                    style: const TextStyle(fontFamily: 'Courier New', fontSize: 12, color: AppColors.zinc500),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
