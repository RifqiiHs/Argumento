import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

// Ensure these imports match your actual project paths
import 'package:mobile/components/ui/dashboard_shell.dart';
import 'package:mobile/models/User.dart';
import 'package:mobile/providers/userProvider.dart';
import 'package:mobile/theme/app_colors.dart';

class CampaignScreen extends StatefulWidget {
  const CampaignScreen({super.key});

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  late Future<Map<String, dynamic>> _campaignsFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the future once to avoid infinite rebuilds
    _campaignsFuture = _fetchCampaigns();
  }

  Future<Map<String, dynamic>> _fetchCampaigns() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? '';

    final response = await http.get(
      Uri.parse('http://localhost:3000/api/campaign'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);

      // Unwrap the nested "campaign" object from your API response
      if (decoded.containsKey('campaign') && decoded['campaign'] is Map) {
        return Map<String, dynamic>.from(decoded['campaign']);
      } else if (decoded.containsKey('data') && decoded['data'] is Map) {
        return Map<String, dynamic>.from(decoded['data']);
      }

      // Fallback
      decoded.removeWhere((key, value) => value is! Map);
      return decoded;
    } else {
      throw Exception('Failed to load campaigns');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;

    return DashboardShell(
      title: 'Campaign',
      body: FutureBuilder<Map<String, dynamic>>(
        future: _campaignsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.neon),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(
                  color: Colors.red,
                  fontFamily: 'monospace',
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No campaigns found',
                style: TextStyle(color: Colors.grey, fontFamily: 'monospace'),
              ),
            );
          }

          final campaigns = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Responsive Grid Layout
                final isDesktop = constraints.maxWidth > 768;
                const spacing = 32.0;
                final itemWidth = isDesktop
                    ? (constraints.maxWidth - spacing) / 2
                    : constraints.maxWidth;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: campaigns.entries.map((entry) {
                    final campaignId = entry.key;
                    // Safely cast the nested campaign data
                    final campaign = Map<String, dynamic>.from(
                      entry.value as Map,
                    );

                    final campaignProgress = user?.campaignProgress
                        ?.where((cp) => cp.campaignId == campaignId)
                        .firstOrNull;

                    final requirement = campaign['requirement'] as String?;

                    final requiredCampaign = user?.campaignProgress
                        ?.where((cp) => cp.campaignId == requirement)
                        .firstOrNull;

                    // Unlocked if no requirement, or if the requirement is completed
                    final isUnlocked =
                        requirement == null ||
                        requirement.isEmpty ||
                        (requiredCampaign?.isCompleted ?? false);

                    Widget card = isUnlocked
                        ? _buildUnlockedCard(
                            context,
                            campaignId,
                            campaign,
                            campaignProgress,
                          )
                        : _buildLockedCard(requirement);

                    return SizedBox(width: itemWidth, child: card);
                  }).toList(),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLockedCard(String? requirement) {
    return Container(
      constraints: const BoxConstraints(minHeight: 300),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade800, width: 2),
        color: Colors.grey.shade900.withOpacity(0.2),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade800),
                color: Colors.black,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(Icons.lock, color: Colors.grey, size: 32),
            ),
            const SizedBox(height: 24),
            const Text(
              'LOCKED!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            if (requirement != null && requirement.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red.shade900.withOpacity(0.5),
                  ),
                  color: Colors.red.shade900.withOpacity(0.3),
                ),
                child: Text(
                  'REQUIRES: [${requirement.replaceAll('campaign_', 'CAMPAIGN ').toUpperCase()}]',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnlockedCard(
    BuildContext context,
    String campaignId,
    Map<String, dynamic> campaign,
    CampaignProgress? progress,
  ) {
    final title = campaign['title'] ?? 'Unknown';
    final description = campaign['description'] ?? '';
    final levels = (campaign['levels'] as Map<String, dynamic>?) ?? {};
    final isCompleted = progress?.isCompleted ?? false;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.neon, width: 2),
        color: Colors.black,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.neon.withOpacity(0.5)),
              ),
              color: AppColors.neon.withOpacity(0.1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      campaignId.replaceAll('_', ' ').toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        color: Colors.grey,
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                    if (isCompleted)
                      Container(
                        color: AppColors.neon,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: const Text(
                          'COMPLETED',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    color: Colors.grey,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // Levels
          Container(
            color: Colors.grey.shade900.withOpacity(0.2),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: levels.entries.map((levelEntry) {
                final levelId = levelEntry.key;
                final levelData = levelEntry.value as Map<String, dynamic>;
                final isLevelCompleted =
                    progress?.levelsCompleted.contains(levelId) ?? false;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // Navigation placeholder - update this with your actual router (e.g., go_router)
                        // context.go('/campaign/$campaignId/$levelId');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Navigating to $campaignId / $levelId',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isLevelCompleted
                                ? AppColors.neon.withOpacity(0.5)
                                : Colors.grey.shade800,
                          ),
                          color: isLevelCompleted
                              ? AppColors.neon.withOpacity(0.1)
                              : Colors.black,
                        ),
                        child: Row(
                          children: [
                            Text(
                              levelId.toUpperCase().replaceAll('LEVEL_', '0'),
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: isLevelCompleted
                                    ? Colors.grey
                                    : AppColors.neon,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                (levelData['title'] ?? '').toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  letterSpacing: 1,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Icon(
                              isLevelCompleted
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              size: 16,
                              color: isLevelCompleted
                                  ? AppColors.neon.withOpacity(0.5)
                                  : Colors.grey.shade700,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
