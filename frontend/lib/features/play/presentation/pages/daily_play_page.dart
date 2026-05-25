import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/app_state.dart';
import '../../../../core/utils/models.dart';
import '../../../../core/utils/widgets.dart';
import '../widgets/game_setup_widget.dart';
import '../widgets/game_state_widget.dart';

class DailyPlayPage extends StatefulWidget {
  const DailyPlayPage({super.key});

  @override
  State<DailyPlayPage> createState() => _DailyPlayPageState();
}

class _DailyPlayPageState extends State<DailyPlayPage> {
  static const _storageKey = 'shift_data';

  List<PostModel> _posts = [];
  List<PostLogModel> _logs = [];
  int _index = 0;
  bool _isSetupDone = false;
  bool _isLoadingStorage = true;
  bool _isSubmitting = false;
  bool _isSaving = false;
  bool _isResult = false;
  bool _isAnalyzing = false;
  PostVerdictModel? _verdict;

  Map<String, List<String>> _selectedTopics = {
    'logical_fallacies': [],
    'cognitive_biases': [],
    'media_manipulations': [],
    'ai_hallucinations': [],
  };
  int _postAmount = 3;

  @override
  void initState() {
    super.initState();
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);
    if (data != null) {
      try {
        final parsed = jsonDecode(data);
        final posts = (parsed['currPosts'] as List).map((p) => PostModel.fromJson(p)).toList();
        final logs = (parsed['log'] as List).map((l) => PostLogModel(postId: l['post_id'], isCorrect: l['is_correct'])).toList();
        setState(() {
          _posts = posts;
          _logs = logs;
          _index = logs.length;
          _isSetupDone = true;
        });
      } catch (_) {}
    }
    setState(() => _isLoadingStorage = false);
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'currPosts': _posts.map((p) => p.toJson()).toList(),
      'log': _logs.map((l) => l.toJson()).toList(),
    };
    await prefs.setString(_storageKey, jsonEncode(data));
  }

  Future<void> _clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  Future<void> _generateShift() async {
    setState(() => _isSubmitting = true);
    try {
      final user = context.read<UserCubit>().state.user;
      final isCompleted = user?.campaignProgress.any(
            (cp) => cp.campaignId == 'campaign_1' && cp.isCompleted,
          ) ??
          false;
      if (!isCompleted) {
        if (mounted) ArgumentoSnackBar.show(context, 'Complete Campaign 1 first!', isError: true);
        return;
      }

      final posts = await ApiService().generateDailyShift(_postAmount, _selectedTopics);
      final prefs = await SharedPreferences.getInstance();
      final data = {'currPosts': posts.map((p) => p.toJson()).toList(), 'log': []};
      await prefs.setString(_storageKey, jsonEncode(data));

      setState(() {
        _posts = posts;
        _logs = [];
        _index = 0;
        _isSetupDone = true;
        _isResult = false;
        _verdict = null;
      });
    } catch (e) {
      if (mounted) ArgumentoSnackBar.show(context, 'Failed to generate shift. Try again.', isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _handleApprove() {
    final post = _posts[_index];
    final isSafe = post.type == 'safe';
    setState(() {
      _verdict = PostVerdictModel(
        isCorrect: isSafe,
        message: isSafe ? 'Correct! This post had valid reasoning.' : 'Incorrect! Hidden threat detected.',
      );
      _isResult = true;
    });
  }

  Future<void> _handleReject(String reason) async {
    final post = _posts[_index];
    setState(() => _isAnalyzing = true);
    try {
      final verdict = await ApiService().judge(
        post.headline,
        post.content,
        post.reasons.isEmpty ? [post.slopReason ?? ''] : post.reasons,
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
      final newLog = PostLogModel(postId: _posts[_index].id, isCorrect: _verdict!.isCorrect);
      setState(() {
        _logs = [..._logs, newLog];
        _index++;
        _isResult = false;
        _verdict = null;
      });
      _saveToStorage();
    }
  }

  Future<void> _handleEndShift() async {
    setState(() => _isSaving = true);
    try {
      await ApiService().completeShift(_logs);
      await context.read<UserCubit>().invalidateUser();
      await _clearStorage();
      if (mounted) {
        ArgumentoSnackBar.show(context, 'Shift Complete!');
        context.go('/dashboard');
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

    if (_isLoadingStorage) {
      return Scaffold(
        backgroundColor: AppColors.bg900,
        body: LoadingOverlay(accentColor: accentColor),
      );
    }

    if (!_isSetupDone) {
      return GameSetupWidget(
        user: user,
        selectedTopics: _selectedTopics,
        onTopicsChanged: (t) => setState(() => _selectedTopics = t),
        postAmount: _postAmount,
        onPostAmountChanged: (n) => setState(() => _postAmount = n),
        onStart: _generateShift,
        isSubmitting: _isSubmitting,
        mode: 'daily',
        accentColor: accentColor,
      );
    }

    // All posts done
    if (_index >= _posts.length) {
      return Scaffold(
        backgroundColor: AppColors.bg900,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SHIFT COMPLETE',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: accentColor,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: AccentButton(
                  label: _isSaving ? 'Saving...' : 'Clock Out',
                  onPressed: _isSaving ? null : _handleEndShift,
                  isLoading: _isSaving,
                  accentColor: accentColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg900,
      appBar: AppBar(
        backgroundColor: AppColors.bg900,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary),
          onPressed: () => context.go('/dashboard'),
        ),
        title: Text(
          'DAILY SHIFT',
          style: TextStyle(fontWeight: FontWeight.bold, color: accentColor, letterSpacing: 2),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.bg700),
        ),
      ),
      body: GameStateWidget(
        currentPost: _posts[_index],
        currentIndex: _index,
        verdict: _verdict,
        isResult: _isResult,
        isAnalyzing: _isAnalyzing,
        onApprove: _handleApprove,
        onReject: _handleReject,
        onNext: _handleNext,
        accentColor: accentColor,
      ),
    );
  }
}
