import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/providers/userProvider.dart';
import 'package:mobile/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignGameComponent extends StatefulWidget {
  final String campaignId;
  final String levelId;
  final String badgeText;
  final String title;
  final String briefing;
  final List<Map<String, dynamic>> posts;

  const CampaignGameComponent({
    super.key,
    required this.campaignId,
    required this.levelId,
    required this.badgeText,
    required this.title,
    required this.briefing,
    required this.posts,
  });

  @override
  State<CampaignGameComponent> createState() => _CampaignGameComponentState();
}

class _CampaignGameComponentState extends State<CampaignGameComponent> {
  int _currIndex = 0;
  bool _isResult = false;
  bool _isAnalyzing = false;
  bool _isSaving = false;
  Map<String, dynamic>? _verdict;

  Map<String, dynamic>? get _currentPost {
    if (_currIndex < 0 || _currIndex >= widget.posts.length) {
      return null;
    }
    return widget.posts[_currIndex];
  }

  void _handleApprove() {
    final currentPost = _currentPost;
    if (currentPost == null || _isAnalyzing) return;

    setState(() {
      _isAnalyzing = true;
      _verdict = {
        'is_correct': currentPost['type']?.toString() == 'safe',
        'message': currentPost['type']?.toString() == 'safe'
            ? 'Correct!'
            : 'Incorrect! Hidden threat detected.',
      };
      _isResult = true;
      _isAnalyzing = false;
    });
  }

  void _handleReject() {
    final currentPost = _currentPost;
    if (currentPost == null || _isAnalyzing) return;

    final slopReasons = currentPost['slop_reasons'];
    final reasonText = slopReasons is List
        ? slopReasons.map((item) => item.toString()).join(', ')
        : slopReasons?.toString() ?? '';

    setState(() {
      _isAnalyzing = true;
      _verdict = {
        'is_correct': currentPost['type']?.toString() == 'slop',
        'message': currentPost['type']?.toString() == 'slop'
            ? 'Correct! You spotted the manipulation.'
            : 'Incorrect. This content is actually verified safe.',
      };
      _isResult = true;
      _isAnalyzing = false;
    });

    if (reasonText.isNotEmpty) {}
  }

  void _handleNext() {
    setState(() {
      _isResult = false;
      _verdict = null;
      _currIndex += 1;
    });
  }

  Future<void> _completeLevel() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse(
          'http://localhost:3000/api/campaign/complete/${widget.campaignId}/${widget.levelId}',
        ),
        headers: {
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to save progress');
      }

      await context.read<UserProvider>().invalidateUser();

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/campaign', (route) => false);
    } catch (_) {
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
                'MISSION COMPLETE',
                style: TextStyle(
                  color: neon,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'All campaign posts have been reviewed.',
                style: TextStyle(color: muted.withOpacity(0.95)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isSaving ? null : _completeLevel,
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

    final slopReason =
        currentPost['slop_reason'] ?? currentPost['slop_reasons'];
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
                        const Text(
                          'POST',
                          style: TextStyle(
                            color: neon,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'CAMPAIGN ${widget.campaignId.replaceAll('_', ' ').toUpperCase()}',
                          style: TextStyle(
                            color: muted.withOpacity(0.8),
                            fontSize: 12,
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
                  const SizedBox(width: 20),
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
                          : _handleApprove,
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
                          : _handleReject,
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
                    onPressed: _handleNext,
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
