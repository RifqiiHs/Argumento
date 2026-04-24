import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String _selectedType = 'totalExp';
  late Future<Map<String, dynamic>> _leaderboardFuture;

  final List<Map<String, String>> _sortFields = [
    {'key': 'totalExp', 'label': 'Total EXP'},
    {'key': 'bestStreak', 'label': 'Best Streak'},
    {'key': 'currentStreak', 'label': 'Current Streak'},
    {'key': 'postsProcessed', 'label': 'Posts Processed'},
    {'key': 'postsCorrect', 'label': 'Accuracy'},
  ];

  @override
  void initState() {
    super.initState();
    _leaderboardFuture = _fetchLeaderboard(_selectedType);
  }

  Future<Map<String, dynamic>> _fetchLeaderboard(String type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/leaderboard/$type'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'data': data['data'], 'type': data['type']};
      }
      throw Exception('Failed to fetch leaderboard');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  void _changeType(String type) {
    setState(() {
      _selectedType = type;
      _leaderboardFuture = _fetchLeaderboard(type);
    });
  }

  IconData _getRankIcon(int index) {
    if (index == 0) return Icons.emoji_events;
    if (index == 1) return Icons.looks_two;
    if (index == 2) return Icons.looks_3;
    return Icons.numbers;
  }

  Color _getRankColor(int index) {
    if (index == 0) return Colors.amber[400]!;
    if (index == 1) return Colors.grey[400]!;
    if (index == 2) return Colors.orange[700]!;
    return Colors.grey[600]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Leaderboard',
          style: GoogleFonts.firaCode(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Sort Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: _sortFields
                  .map((field) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(
                            field['label']!,
                            style: GoogleFonts.firaCode(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          selected: _selectedType == field['key'],
                          onSelected: (_) => _changeType(field['key']!),
                          backgroundColor: Colors.grey[900],
                          selectedColor: AppColors.neon.withOpacity(0.3),
                          side: BorderSide(
                            color: _selectedType == field['key']
                                ? AppColors.neon
                                : Colors.grey[700]!,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          // Leaderboard List
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _leaderboardFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading leaderboard',
                      style: GoogleFonts.firaCode(
                        color: Colors.red,
                      ),
                    ),
                  );
                }

                final data = snapshot.data?['data'] as List? ?? [];

                if (data.isEmpty) {
                  return Center(
                    child: Text(
                      'No leaderboard data',
                      style: GoogleFonts.firaCode(
                        color: Colors.grey[400],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final entry = data[index] as Map<String, dynamic>;
                    final rank = index + 1;

                    return DefaultTextStyle(
                      style: const TextStyle(color: Colors.white),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(8),
                          border: Border(
                            left: BorderSide(
                              color: _getRankColor(index),
                              width: 3,
                            ),
                            top: BorderSide(
                              color: Colors.grey[800]!,
                              width: 1,
                            ),
                            right: BorderSide(
                              color: Colors.grey[800]!,
                              width: 1,
                            ),
                            bottom: BorderSide(
                              color: Colors.grey[800]!,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                        children: [
                          // Rank Icon
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _getRankColor(index).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: index < 3
                                  ? Icon(
                                      _getRankIcon(index),
                                      color: _getRankColor(index),
                                      size: 20,
                                    )
                                  : Text(
                                      '$rank',
                                      style: GoogleFonts.firaCode(
                                        fontWeight: FontWeight.bold,
                                        color: _getRankColor(index),
                                        fontSize: 12,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Username
                          Expanded(
                            child: Text(
                              entry['username'] ?? 'Unknown',
                              style: GoogleFonts.firaCode(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Score
                          Text(
                            entry[_selectedType]?.toString() ?? '0',
                            style: GoogleFonts.firaCode(
                              fontWeight: FontWeight.bold,
                              color: AppColors.neon,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
