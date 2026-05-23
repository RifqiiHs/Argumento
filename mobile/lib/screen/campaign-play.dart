import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/components/screens/campaignBriefingComponent.dart';
import 'package:mobile/components/screens/campaignGameComponent.dart';
import 'package:mobile/components/ui/dashboard_shell.dart';
import 'package:mobile/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CampaignPlayScreen extends StatefulWidget {
  final String campaignId;
  final String levelId;

  const CampaignPlayScreen({
    super.key,
    required this.campaignId,
    required this.levelId,
  });

  @override
  State<CampaignPlayScreen> createState() => _CampaignPlayScreenState();
}

class _CampaignPlayScreenState extends State<CampaignPlayScreen> {
  int _currentIndex = 0;

  late final Future<Map<String, dynamic>> _levelFuture;

  @override
  void initState() {
    super.initState();
    _levelFuture = _fetchLevel();
  }

  Future<Map<String, dynamic>> _fetchLevel() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      final response = await http.get(
        Uri.parse(
          'http://localhost:3000/api/campaign/${widget.campaignId}/${widget.levelId}',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final part = decoded['part'];

        if (part is Map<String, dynamic>) {
          return part;
        }

        if (part is Map) {
          return Map<String, dynamic>.from(part);
        }

        return <String, dynamic>{};
      }

      throw Exception('Failed to load campaign level');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  String _formatCampaignBadge() {
    return '${widget.campaignId.replaceFirst('campaign_', 'C').toUpperCase()}-${widget.levelId.replaceFirst('level_', 'L').toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _levelFuture,
      builder: (context, snapshot) {
        Widget body;

        if (snapshot.connectionState == ConnectionState.waiting) {
          body = const Center(
            child: CircularProgressIndicator(color: AppColors.neon),
          );
        } else if (snapshot.hasError) {
          body = Center(
            child: Text(
              snapshot.error.toString(),
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          final levelData = snapshot.data ?? <String, dynamic>{};
          final posts = (levelData['posts'] as List<dynamic>? ?? const [])
              .whereType<Map>()
              .map((post) => Map<String, dynamic>.from(post))
              .toList();

          body = _currentIndex == 0
              ? CampaignGameComponent(
                  campaignId: widget.campaignId,
                  levelId: widget.levelId,
                  badgeText: _formatCampaignBadge(),
                  title: levelData['title']?.toString() ?? '',
                  briefing: levelData['briefing']?.toString() ?? '',
                  posts: posts,
                )
              : CampaignBriefingComponent(
                  campaignId: widget.campaignId,
                  levelId: widget.levelId,
                  badgeText: _formatCampaignBadge(),
                  title: levelData['title']?.toString() ?? '',
                  briefing: levelData['briefing']?.toString() ?? '',
                  description: levelData['description']?.toString() ?? '',
                );
        }

        return DashboardShell(
          title: 'Campaign',
          body: body,
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.black,
            selectedItemColor: AppColors.neon,
            unselectedItemColor: Colors.grey,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.computer),
                label: 'TERMINAL',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: 'BRIEFING',
              ),
            ],
          ),
        );
      },
    );
  }
}
