import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/app_state.dart';
import '../../../../core/utils/models.dart';
import '../../../../core/utils/widgets.dart';

enum _CampaignPhase { briefing, playing, done }

class CampaignLevelPage extends StatefulWidget {
  final String level;
  final String id;

  const CampaignLevelPage({super.key, required this.level, required this.id});

  @override
  State<CampaignLevelPage> createState() => _CampaignLevelPageState();
}

class _CampaignLevelPageState extends State<CampaignLevelPage> {
  CampaignLevelModel? _levelData;
  bool _isLoading = true;
  _CampaignPhase _phase = _CampaignPhase.briefing;
  int _index = 0;
  bool _isResult = false;
  bool _isAnalyzing = false;
  bool _isRejecting = false;
  bool _isSaving = false;
  PostVerdictModel? _verdict;
  final _reasonCtrl = TextEditingController();
  List<bool> _results = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _reasonCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final data = await ApiService().getLevel(widget.level, widget.id);
      setState(() { _levelData = data; _isLoading = false; });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  void _handleApprove() {
    final post = _levelData!.posts[_index];
    final isSafe = post.type == 'safe';
    setState(() {
      _verdict = PostVerdictModel(
        isCorrect: isSafe,
        message: isSafe ? 'Correct! This post had valid reasoning.' : 'Incorrect! This post contained hidden violations.',
      );
      _isResult = true;
    });
  }

  Future<void> _handleReject(String reason) async {
    final post = _levelData!.posts[_index];
    setState(() => _isAnalyzing = true);
    try {
      final verdict = await ApiService().judge(
        post.headline,
        post.content,
        post.slopReasons,
        reason,
      );
      setState(() { _verdict = verdict; _isResult = true; });
    } catch (_) {
      setState(() {
        _verdict = PostVerdictModel(isCorrect: true, message: 'AI Offline. Points awarded automatically.');
        _isResult = true;
      });
    } finally {
      if (mounted) setState(() => _isAnalyzing = false);
    }
  }

  void _handleNext() {
    if (_verdict != null) {
      final newResults = [..._results, _verdict!.isCorrect];
      setState(() {
        _results = newResults;
        _index++;
        _isResult = false;
        _isRejecting = false;
        _verdict = null;
        _reasonCtrl.clear();
      });
    }
  }

  Future<void> _handleComplete() async {
    setState(() => _isSaving = true);
    try {
      await ApiService().completeCampaignLevel(widget.level, widget.id);
      await context.read<UserCubit>().invalidateUser();
      if (mounted) {
        ArgumentoSnackBar.show(context, 'Level Complete!');
        context.go('/campaign');
      }
    } catch (e) {
      if (mounted) ArgumentoSnackBar.show(context, 'Failed to save progress.', isError: true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state.user;
    final accentColor = AppTheme.getAccentColor(user?.activeTheme ?? 'theme_green');

    if (_isLoading) {
      return Scaffold(backgroundColor: AppColors.bg900, body: LoadingOverlay(accentColor: accentColor));
    }
    if (_levelData == null) {
      return Scaffold(
        backgroundColor: AppColors.bg900,
        body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('Level not found', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          AccentButton(label: 'Back', onPressed: () => context.go('/campaign'), accentColor: accentColor),
        ])),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg900,
      appBar: AppBar(
        backgroundColor: AppColors.bg900,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary),
          onPressed: () => context.go('/campaign'),
        ),
        title: Text(
          _levelData!.title.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold, color: accentColor, letterSpacing: 1),
        ),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppColors.bg700)),
      ),
      body: _phase == _CampaignPhase.briefing
          ? _buildBriefing(accentColor)
          : _phase == _CampaignPhase.done
              ? _buildDone(accentColor)
              : _buildGame(accentColor),
    );
  }

  Widget _buildBriefing(Color accentColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(border: Border.all(color: accentColor.withValues(alpha: 0.4))),
            child: const Text('MISSION BRIEFING', style: TextStyle(fontSize: 10, color: AppColors.textMuted, letterSpacing: 2)),
          ),
          const SizedBox(height: 20),
          Text(
            _levelData!.title.toUpperCase(),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bg800.withValues(alpha: 0.4),
              border: Border(left: BorderSide(color: accentColor, width: 4)),
            ),
            child: Text(
              _levelData!.briefing,
              style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.6),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5), border: Border.all(color: AppColors.bg700)),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.textMuted, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${_levelData!.posts.length} documents to review. Identify safe vs slop content.',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          AccentButton(
            label: 'Begin Mission →',
            accentColor: accentColor,
            onPressed: () => setState(() => _phase = _CampaignPhase.playing),
          ),
        ],
      ),
    );
  }

  Widget _buildGame(Color accentColor) {
    if (_index >= _levelData!.posts.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _phase = _CampaignPhase.done);
      });
      return const SizedBox.shrink();
    }

    final post = _levelData!.posts[_index];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('POST ${_index + 1} / ${_levelData!.posts.length}',
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted, letterSpacing: 1),
                  overflow: TextOverflow.ellipsis, maxLines: 2),
              LinearProgressIndicator(
                value: (_index + 1) / _levelData!.posts.length,
                backgroundColor: AppColors.bg700,
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                minHeight: 3,
              ).maybeExpand(),
            ],
          ),
          const SizedBox(height: 16),

          // Post card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(border: Border.all(color: accentColor, width: 2), color: AppColors.bg900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    border: Border(bottom: BorderSide(color: accentColor, width: 2)),
                  ),
                  child: Text(
                    'DOCUMENT #${_index + 1}',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: accentColor, letterSpacing: 1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 12),
                        decoration: BoxDecoration(border: Border(left: BorderSide(color: accentColor, width: 4))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('HEADLINE', style: TextStyle(fontSize: 9, color: accentColor, letterSpacing: 3, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(post.headline, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, height: 1.2)),
                            const SizedBox(height: 12),
                            const Text('CONTENT', style: TextStyle(fontSize: 9, color: AppColors.textMuted, letterSpacing: 3, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(post.content, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.6)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: _isResult ? _buildVerdictUI(accentColor) : _buildActionUI(accentColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerdictUI(Color accentColor) {
    final isCorrect = _verdict?.isCorrect ?? false;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
        border: Border.all(color: isCorrect ? Colors.green.withValues(alpha: 0.5) : Colors.red.withValues(alpha: 0.5), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isCorrect ? Icons.shield : Icons.warning_amber, color: isCorrect ? Colors.green : Colors.red, size: 20),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'CORRECT ASSESSMENT' : 'ASSESSMENT FAILED',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: isCorrect ? Colors.green : Colors.red, letterSpacing: 1),
                  overflow: TextOverflow.ellipsis, maxLines: 2),
            ],
          ),
          const SizedBox(height: 10),
          Text(_verdict?.message ?? '', style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.4)),
          const SizedBox(height: 14),
          AccentButton(label: 'Next →', onPressed: _handleNext, accentColor: accentColor),
        ],
      ),
    );
  }

  Widget _buildActionUI(Color accentColor) {
    if (_isRejecting) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.08),
          border: Border.all(color: Colors.red.withValues(alpha: 0.4), width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('VIOLATION REPORT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red, letterSpacing: 1.5)),
                GestureDetector(
                  onTap: () => setState(() => _isRejecting = false),
                  child: const Text('[Cancel]', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _reasonCtrl,
              maxLines: 3,
              // FIX: setState on every change so button enable/disable updates live
              onChanged: (_) => setState(() {}),
              style: GoogleFonts.inter(color: AppColors.error, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Describe the violation or manipulation tactic you detected...',
                hintStyle: GoogleFonts.inter(color: AppColors.errorBg.withValues(alpha: 0.6), fontSize: 12),
                filled: true,
                fillColor: AppColors.bg800,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.error.withValues(alpha: 0.5))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.error.withValues(alpha: 0.5))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.error, width: 1.5)),
                contentPadding: const EdgeInsets.all(14),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_isAnalyzing || _reasonCtrl.text.trim().isEmpty)
                    ? null
                    : () => _handleReject(_reasonCtrl.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.black,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  disabledBackgroundColor: Colors.red.withValues(alpha: 0.4),
                ),
                child: _isAnalyzing
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                    : const Text('SUBMIT REPORT', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _isAnalyzing ? null : _handleApprove,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.withValues(alpha: 0.1),
              foregroundColor: Colors.green,
              side: const BorderSide(color: Colors.green, width: 2),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('APPROVE', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: _isAnalyzing ? null : () => setState(() => _isRejecting = true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withValues(alpha: 0.1),
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red, width: 2),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('REJECT', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          ),
        ),
      ],
    );
  }

  Widget _buildDone(Color accentColor) {
    final correct = _results.where((r) => r).length;
    final total = _results.length;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('MISSION COMPLETE', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: accentColor, letterSpacing: 1), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              '$correct / $total Correct',
              style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AccentButton(
              label: _isSaving ? 'Saving...' : 'Mark as Complete',
              accentColor: accentColor,
              onPressed: _isSaving ? null : _handleComplete,
              isLoading: _isSaving,
            ),
            const SizedBox(height: 12),
            ArgumentoOutlinedButton(label: 'Back to Campaign', onPressed: () => context.go('/campaign')),
          ],
        ),
      ),
    );
  }
}

extension on Widget {
  Widget maybeExpand() => Expanded(child: this);
}
