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

class PracticePlayPage extends StatefulWidget {
  const PracticePlayPage({super.key});

  @override
  State<PracticePlayPage> createState() => _PracticePlayPageState();
}

class _PracticePlayPageState extends State<PracticePlayPage> {
  static const _storageKey = 'practice_shift_data';

  List<PostModel> _posts = [];
  int _index = 0;
  bool _isSetupDone = false;
  bool _isLoadingStorage = true;
  bool _isSubmitting = false;
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
        final savedIndex = parsed['index'] as int? ?? 0;
        setState(() {
          _posts = posts;
          _index = savedIndex;
          _isSetupDone = true;
        });
      } catch (_) {}
    }
    setState(() => _isLoadingStorage = false);
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {'currPosts': _posts.map((p) => p.toJson()).toList(), 'index': _index};
    await prefs.setString(_storageKey, jsonEncode(data));
  }

  Future<void> _clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  Future<void> _generateShift() async {
    setState(() => _isSubmitting = true);
    try {
      final posts = await ApiService().generatePracticeShift(_postAmount, _selectedTopics);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, jsonEncode({'currPosts': posts.map((p) => p.toJson()).toList(), 'index': 0}));
      setState(() {
        _posts = posts;
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
        post.headline, post.content,
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
    setState(() {
      _index++;
      _isResult = false;
      _verdict = null;
    });
    _saveToStorage();
  }

  Future<void> _endPractice() async {
    await _clearStorage();
    if (mounted) context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state.user;
    final accentColor = const Color(0xFF3B82F6); // blue for practice mode

    if (_isLoadingStorage) {
      return Scaffold(backgroundColor: AppColors.zinc950, body: LoadingOverlay(accentColor: accentColor));
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
        mode: 'practice',
        accentColor: accentColor,
      );
    }

    if (_index >= _posts.length) {
      return Scaffold(
        backgroundColor: AppColors.zinc950,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('DEMO COMPLETE', style: TextStyle(fontFamily: 'Courier New', fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF3B82F6), letterSpacing: 2)),
              const SizedBox(height: 8),
              const Text('No stats tracked in demo mode.', style: TextStyle(fontFamily: 'Courier New', color: AppColors.zinc500)),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: AccentButton(label: 'Back to Dashboard', accentColor: accentColor, onPressed: _endPractice),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.zinc950,
      appBar: AppBar(
        backgroundColor: AppColors.zinc950,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.zinc400),
          onPressed: () => context.go('/dashboard'),
        ),
        title: Row(
          children: [
            const Text('DEMO MODE', style: TextStyle(fontFamily: 'Courier New', fontWeight: FontWeight.bold, color: Color(0xFF3B82F6), letterSpacing: 2, fontSize: 16)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(border: Border.all(color: Colors.blue.withOpacity(0.5)), color: Colors.blue.withOpacity(0.1)),
              child: const Text('NO STATS', style: TextStyle(fontFamily: 'Courier New', fontSize: 9, color: Colors.blue, letterSpacing: 1)),
            ),
          ],
        ),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppColors.zinc800)),
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
