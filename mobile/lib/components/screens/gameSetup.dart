import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/components/button.dart';
import 'package:mobile/utils/content_types.dart';
import 'package:mobile/theme/app_colors.dart';
import 'package:mobile/providers/userProvider.dart';
import 'package:mobile/screen/game.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GameSetup extends StatefulWidget {
  final String mode;

  const GameSetup({super.key, this.mode = 'custom'});

  @override
  State<GameSetup> createState() => _GameSetupState();
}

class _GameSetupState extends State<GameSetup> {
  late TextEditingController _postAmountController;
  late Map<String, List<String>> _selectedTopics;
  bool _isSubmitting = false;
  @override
  void initState() {
    super.initState();
    _postAmountController = TextEditingController(text: '3');
    _selectedTopics = {
      for (final category in contentTypes)
        category['name'] as String: <String>[],
    };
  }

  @override
  void dispose() {
    _postAmountController.dispose();
    super.dispose();
  }

  void _toggleTopic(String category, String topic) {
    setState(() {
      final current = _selectedTopics[category] ?? <String>[];
      if (current.contains(topic)) {
        current.remove(topic);
      } else {
        current.add(topic);
      }
      _selectedTopics[category] = List<String>.from(current);
    });
  }

  Future<void> _handleGenerate() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final user = context.read<UserProvider>().user;

      if (widget.mode == 'daily') {
        final isCompleted =
            user?.campaignProgress.any(
              (item) => item.campaignId == 'campaign_1' && item.isCompleted,
            ) ??
            false;

        if (!isCompleted) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Complete campaign_1 first!')),
          );
          return;
        }
      }

      final response = await http.post(
        Uri.parse('http://localhost:3000/api/shifts/generate'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'postLength': int.tryParse(_postAmountController.text) ?? 3,
          'types': _selectedTopics,
        }),
      );

      if (response.statusCode != 200) {
        final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(
          errorBody['message']?.toString() ?? 'Failed to generate shift',
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final posts =
          (data['posts'] as List<dynamic>? ??
          data['data'] as List<dynamic>? ??
          []);
      final newGame = {'currPosts': posts, 'log': <dynamic>[]};

      await prefs.setString('shift_data', jsonEncode(newGame));

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GameScreen()),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const neon = AppColors.neon;
    const deepBlack = Color(0xff03050a);
    const muted = Color(0xff7a7f88);
    const textWhite = Color(0xffdfe2e6);
    final user = context.watch<UserProvider>().user;
    final isPractice = widget.mode == 'practice';
    final isDaily = widget.mode == 'daily';
    final headerTitle = isPractice ? 'PRACTICE MODE' : 'CUSTOM SIMULATION';

    return Scaffold(
      backgroundColor: deepBlack,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headerTitle,
                      style: const TextStyle(
                        color: textWhite,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isPractice
                          ? 'Perfect your detection skills with no pressure.\nYour progress will not be recorded.'
                          : 'Select specific protocols to test your detection\nability.',
                      style: const TextStyle(color: muted, height: 1.4),
                    ),
                    const SizedBox(height: 24),
                    Container(height: 1, color: muted),
                  ],
                ),
              ),
              ...contentTypes.map((category) {
                final categoryName = category['name'] as String;
                final description = category['description'] as String;
                final requirements = category['requirements'] as String?;
                final types = category['types'] as List<dynamic>;
                final isCompleted = isDaily && requirements != null
                    ? user?.campaignProgress.any(
                            (item) =>
                                item.campaignId == requirements &&
                                item.isCompleted,
                          ) ??
                          false
                    : true;

                if (isDaily && requirements != null && !isCompleted) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 28),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: deepBlack,
                        border: Border.all(
                          color: muted.withOpacity(0.25),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                              border: Border.all(color: muted.withOpacity(0.3)),
                            ),
                            child: Icon(
                              Icons.lock_outline,
                              color: muted,
                              size: 34,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            categoryName.toUpperCase(),
                            style: TextStyle(
                              color: muted,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              border: Border.all(
                                color: muted.withOpacity(0.15),
                              ),
                            ),
                            child: Text(
                              'LOCKED: Complete $requirements',
                              style: TextStyle(
                                color: muted,
                                fontFamily: 'monospace',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 28),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: deepBlack,
                      border: Border.all(color: neon, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                categoryName.toUpperCase(),
                                style: const TextStyle(
                                  color: neon,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            if (requirements != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.35),
                                  border: Border.all(
                                    color: muted.withOpacity(0.25),
                                  ),
                                ),
                                child: Text(
                                  requirements,
                                  style: TextStyle(
                                    color: muted.withOpacity(0.9),
                                    fontSize: 11,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          description,
                          style: TextStyle(
                            color: muted.withOpacity(0.95),
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(height: 1, color: muted.withOpacity(0.8)),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: types.map((type) {
                            final topic = type['name'] as String;
                            final isSelected =
                                _selectedTopics[categoryName]?.contains(
                                  topic,
                                ) ??
                                false;

                            return InkWell(
                              onTap: () => _toggleTopic(categoryName, topic),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? neon.withOpacity(0.16)
                                      : Colors.black,
                                  border: Border.all(
                                    color: isSelected
                                        ? neon
                                        : muted.withOpacity(0.5),
                                    width: 1.2,
                                  ),
                                ),
                                child: Text(
                                  '${isSelected ? '[X]' : '[ ]'} $topic',
                                  style: TextStyle(
                                    color: isSelected ? neon : textWhite,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    if (isPractice)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Text(
                          'NO STATS TRACKED',
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.warning_outlined, color: neon, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'AI JUDGE AND POST GENERATION COULD BE WRONG.',
                          style: TextStyle(
                            color: neon,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: 220,
                      decoration: BoxDecoration(
                        color: deepBlack,
                        border: Border.all(color: neon, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              'POST AMOUNT:',
                              style: TextStyle(
                                color: neon,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _postAmountController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: textWhite,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    NeonButton(
                      label: _isSubmitting ? 'GENERATING...' : 'GENERATE',
                      icon: Icons.play_arrow,
                      backgroundColor: neon,
                      onPressed: _isSubmitting ? null : _handleGenerate,
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
