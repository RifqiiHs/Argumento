import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/components/screens/gameSetup.dart';
import 'package:mobile/screen/dashboard.dart';
import 'package:mobile/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameStateComponent extends StatefulWidget {
  const GameStateComponent({super.key});

  @override
  State<GameStateComponent> createState() => _GameStateComponentState();
}

class _GameStateComponentState extends State<GameStateComponent> {
  SharedPreferences? prefs;
  Map<String, dynamic> shiftData = {};
  int _currIndex = 0;
  bool _isLoading = true;
  bool _isResult = false;
  bool _isAnalyzing = false;
  bool _isSaving = false;
  bool _isRedirecting = false;
  Map<String, dynamic>? _verdict;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final storage = prefs?.getString('shift_data');

    if (!mounted) {
      return;
    }

    setState(() {
      shiftData = storage != null
          ? jsonDecode(storage) as Map<String, dynamic>
          : {};
      _currIndex = (shiftData['log'] as List<dynamic>?)?.length ?? 0;
      _isLoading = false;
    });

    if (shiftData.isEmpty && !_isRedirecting) {
      _isRedirecting = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GameSetup()),
        );
      });
    }
  }

  List<dynamic> get _currPosts {
    final posts = shiftData['currPosts'];
    if (posts is List<dynamic>) {
      return posts;
    }
    return const [];
  }

  Map<String, dynamic>? get _currentPost {
    final posts = _currPosts;
    if (_currIndex < 0 || _currIndex >= posts.length) {
      return null;
    }

    final post = posts[_currIndex];
    if (post is Map<String, dynamic>) {
      return post;
    }
    return Map<String, dynamic>.from(post as Map);
  }

  Future<void> _persistShiftData(List<dynamic> logs) async {
    final current = {...shiftData, 'log': logs};
    shiftData = current;
    await prefs?.setString('shift_data', jsonEncode(current));
  }

  Future<Map<String, dynamic>?> _callJudgeApi(String userReason) async {
    final currentPost = _currentPost;
    final token = prefs?.getString('token');

    if (currentPost == null) return null;

    final response = await http.post(
      Uri.parse('http://localhost:3000/api/judge'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'headline': currentPost['headline'] ?? '',
        'content': currentPost['content'] ?? '',
        'slop_reasons':
            currentPost['reasons'] ?? currentPost['slop_reason'] ?? [],
        'user_reason': userReason,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to validate rejection');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final result = decoded['response'];
    if (result is Map<String, dynamic>) {
      return result;
    }
    if (result is Map) {
      return Map<String, dynamic>.from(result);
    }
    return null;
  }

  Future<String?> _askRejectReason() async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.deepBlack,
          title: const Text('Why did you reject it?'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 3,
            decoration: const InputDecoration(hintText: 'Enter your reason'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, controller.text.trim()),
              child: const Text('SUBMIT'),
            ),
          ],
        );
      },
    );

    controller.dispose();
    return result;
  }

  Future<void> handleApprove() async {
    final currentPost = _currentPost;
    if (currentPost == null || _isAnalyzing) return;

    setState(() {
      _isAnalyzing = true;
      _verdict = {
        'is_correct': currentPost['type'] == 'safe',
        'message': currentPost['type'] == 'safe'
            ? 'Correct!'
            : 'Incorrect! Hidden threat detected.',
      };
      _isResult = true;
      _isAnalyzing = false;
    });
  }

  Future<void> handleReject() async {
    final currentPost = _currentPost;
    if (currentPost == null || _isAnalyzing) return;

    final reason = await _askRejectReason();
    if (reason == null || reason.isEmpty) {
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final apiResult = await _callJudgeApi(reason);
      final isCorrect = apiResult?['is_correct'] as bool? ?? false;
      final message = (apiResult?['feedback_message'] ?? 'No feedback')
          .toString();

      if (!mounted) return;
      setState(() {
        _verdict = {'is_correct': isCorrect, 'message': message};
        _isAnalyzing = false;
        _isResult = true;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _verdict = {
          'is_correct': true,
          'message': 'AI Offline. Points awarded automatically.',
        };
        _isAnalyzing = false;
        _isResult = true;
      });
    }
  }

  Future<void> handleNext() async {
    final currentPost = _currentPost;
    final verdict = _verdict;

    if (currentPost != null && verdict != null) {
      final logs = List<dynamic>.from(shiftData['log'] as List<dynamic>? ?? []);
      logs.add({
        'post_id': currentPost['_id'],
        'is_correct': verdict['is_correct'],
        'message': verdict['message'],
      });
      await _persistShiftData(logs);
    }

    if (!mounted) return;
    setState(() {
      _isResult = false;
      _verdict = null;
      _currIndex++;
    });
  }

  Future<void> handleEndShift() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final token = prefs?.getString('token');
      final history = List<dynamic>.from(
        shiftData['log'] as List<dynamic>? ?? [],
      );

      final response = await http.put(
        Uri.parse('http://localhost:3000/api/shifts/complete'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'history': history}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to save progress');
      }

      await prefs?.remove('shift_data');

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to save progress')));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const neon = AppColors.neon;
    const deepBlack = AppColors.deepBlack;
    const muted = AppColors.muted;
    const textWhite = AppColors.textWhite;
    final currentPost = _currentPost;

    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(color: neon),
        ),
      );
    }

    if (currentPost == null) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: deepBlack,
            border: Border.all(color: neon, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'SHIFT COMPLETE',
                style: TextStyle(
                  color: neon,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'All posts have been reviewed.',
                style: TextStyle(color: muted.withOpacity(0.95)),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isSaving ? null : handleEndShift,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: neon,
                    side: const BorderSide(color: neon, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(_isSaving ? 'SAVING...' : 'CLOCK OUT'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final slopReason = currentPost['slop_reason'];
    final slopReasons = slopReason is List
        ? slopReason.map((item) => item.toString()).toList()
        : <String>[if (slopReason != null) slopReason.toString()];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: deepBlack,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: neon, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.article_outlined, color: neon, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'POST #${_currIndex + 1}',
                          style: const TextStyle(
                            color: neon,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.badgeBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: neon),
                    ),
                    child: Text(
                      'REF: ${currentPost['_id'] ?? 'N/A'}',
                      style: const TextStyle(
                        color: neon,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 2, color: neon),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 26, 20, 28),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 4, color: neon),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'HEADLINE',
                          style: TextStyle(
                            color: neon,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          (currentPost['headline'] ?? '').toString(),
                          style: TextStyle(
                            color: textWhite,
                            fontWeight: FontWeight.w700,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 34),
                        const Text(
                          'CONTENT',
                          style: TextStyle(
                            color: muted,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          (currentPost['content'] ?? '').toString(),
                          style: TextStyle(
                            color: textWhite,
                            fontWeight: FontWeight.w500,
                            height: 1.42,
                          ),
                        ),
                        if (slopReasons.isNotEmpty) ...[
                          const SizedBox(height: 18),
                          const Text(
                            'SLOP REASON',
                            style: TextStyle(
                              color: muted,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            slopReasons.join('\n'),
                            style: TextStyle(
                              color: textWhite.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                              height: 1.42,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Text(
                  _isResult ? 'VERDICT' : 'CHOOSE ACTION',
                  style: const TextStyle(
                    color: muted,
                    letterSpacing: 4.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            if (_isResult && _verdict != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.verdictBg,
                    border: Border.all(
                      color: (_verdict?['is_correct'] as bool? ?? false)
                          ? neon
                          : AppColors.danger,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    (_verdict?['message'] ?? '').toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: (_verdict?['is_correct'] as bool? ?? false)
                          ? neon
                          : AppColors.danger,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isAnalyzing || _isResult
                          ? null
                          : handleApprove,
                      icon: const Icon(Icons.verified_user_outlined, size: 22),
                      label: const Text('APPROVE'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: neon,
                        side: const BorderSide(color: neon, width: 2),
                        backgroundColor: AppColors.successBg,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isAnalyzing || _isResult
                          ? null
                          : handleReject,
                      icon: const Icon(Icons.highlight_off, size: 22),
                      label: const Text('REJECT'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.danger,
                        side: const BorderSide(
                          color: AppColors.danger,
                          width: 2,
                        ),
                        backgroundColor: AppColors.dangerBg,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_isResult)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: handleNext,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: neon,
                      side: const BorderSide(color: neon, width: 2),
                      backgroundColor: AppColors.successBg,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.8,
                      ),
                    ),
                    child: const Text('NEXT'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
