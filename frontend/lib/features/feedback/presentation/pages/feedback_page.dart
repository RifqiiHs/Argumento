import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/app_state.dart';
import '../../../../core/utils/widgets.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});
  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _descCtrl = TextEditingController();
  final _favoriteCtrl = TextEditingController();
  final _frustratedCtrl = TextEditingController();
  final _improvementsCtrl = TextEditingController();
  final _elseCtrl = TextEditingController();

  String? _expectation;
  int? _clarity;
  int? _playAgain;
  String? _learned;
  String? _changesMedia;
  bool _isSubmitting = false;
  bool _submitted = false;

  @override
  void dispose() {
    _descCtrl.dispose(); _favoriteCtrl.dispose(); _frustratedCtrl.dispose();
    _improvementsCtrl.dispose(); _elseCtrl.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _descCtrl.text.trim().isNotEmpty && _expectation != null &&
      _favoriteCtrl.text.trim().isNotEmpty && _frustratedCtrl.text.trim().isNotEmpty &&
      _clarity != null && _playAgain != null && _improvementsCtrl.text.trim().isNotEmpty &&
      _learned != null && _changesMedia != null;

  Future<void> _submit() async {
    if (!_isValid) { ArgumentoSnackBar.show(context, 'Please fill all required fields.', isError: true); return; }
    setState(() => _isSubmitting = true);
    try {
      await ApiService().submitFeedback({
        'description': _descCtrl.text.trim(), 'expectation': _expectation,
        'favoritePart': _favoriteCtrl.text.trim(), 'frustrated': _frustratedCtrl.text.trim(),
        'clarity': _clarity, 'playAgainTomorrow': _playAgain, 'improvements': _improvementsCtrl.text.trim(),
        'learnedSomething': _learned, 'changesSocialMedia': _changesMedia, 'anythingElse': _elseCtrl.text.trim(),
      });
      setState(() => _submitted = true);
    } catch (_) {
      if (mounted) ArgumentoSnackBar.show(context, 'Failed to submit. Try again.', isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state.user;
    final accent = AppTheme.getAccentColor(user?.activeTheme ?? 'theme_green');

    return Scaffold(
      backgroundColor: AppColors.bg900,
      appBar: AppBar(
        backgroundColor: AppColors.bg900,
        elevation: 0,
        leading: IconButton(
          icon: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.bg700, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: AppColors.textSecondary)),
          onPressed: () => context.go('/dashboard'),
        ),
        title: Text('Feedback', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppColors.border)),
      ),
      body: _submitted ? _buildSuccess(accent) : _buildForm(accent),
    );
  }

  Widget _buildSuccess(Color accent) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 80, height: 80, margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(color: accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(24), border: Border.all(color: accent.withValues(alpha: 0.3))),
              child: Icon(Icons.mark_chat_read_rounded, color: accent, size: 40),
            ).animate().scale(begin: const Offset(0.8, 0.8)),
            Text('Thank You!', style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text('Your feedback helps us improve Argumento for everyone.', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textMuted, height: 1.5), textAlign: TextAlign.center),
            const SizedBox(height: 32),
            AccentButton(label: 'Back to Dashboard', accentColor: accent, onPressed: () => context.go('/dashboard')),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(Color accent) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Share your experience', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text('Your feedback helps us build a better app.', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted)),
          const SizedBox(height: 20),

          _FbField(label: 'How would you describe Argumento to a friend?', controller: _descCtrl, maxLines: 3, accent: accent),
          const SizedBox(height: 16),

          _FbRadio(label: 'Compared to your expectations, Argumento was...',
            value: _expectation, accent: accent,
            options: const [('better', 'Better than expected'), ('same', 'About the same'), ('worse', 'Worse than expected')],
            onChanged: (v) => setState(() => _expectation = v)),
          const SizedBox(height: 16),

          _FbField(label: 'What was your favorite part?', controller: _favoriteCtrl, maxLines: 2, accent: accent),
          const SizedBox(height: 16),

          _FbField(label: 'What frustrated you most?', controller: _frustratedCtrl, maxLines: 2, accent: accent),
          const SizedBox(height: 16),

          _FbScale(label: 'How clear were the game mechanics?', subLabel: '1 = Very unclear  •  4 = Very clear',
            value: _clarity, min: 1, max: 4, accent: accent, onChanged: (v) => setState(() => _clarity = v)),
          const SizedBox(height: 16),

          _FbScale(label: 'How likely are you to play again tomorrow?', subLabel: '1 = Not at all  •  5 = Definitely',
            value: _playAgain, min: 1, max: 5, accent: accent, onChanged: (v) => setState(() => _playAgain = v)),
          const SizedBox(height: 16),

          _FbField(label: 'What would make Argumento better?', controller: _improvementsCtrl, maxLines: 2, accent: accent),
          const SizedBox(height: 16),

          _FbRadio(label: 'Did you learn something new?',
            value: _learned, accent: accent,
            options: const [('yes_lot', 'Yes, a lot!'), ('yes_little', 'Yes, a little'), ('not_really', 'Not really'), ('already_knew', 'Already knew it')],
            onChanged: (v) => setState(() => _learned = v)),
          const SizedBox(height: 16),

          _FbRadio(label: 'Will this change how you engage with social media?',
            value: _changesMedia, accent: accent,
            options: const [('yes', 'Yes, definitely'), ('maybe', 'Maybe'), ('probably_not', 'Probably not'), ('no', 'No')],
            onChanged: (v) => setState(() => _changesMedia = v)),
          const SizedBox(height: 16),

          _FbField(label: 'Anything else you\'d like to add? (optional)', controller: _elseCtrl, maxLines: 2, accent: accent),
          const SizedBox(height: 28),

          AccentButton(
            label: _isSubmitting ? 'Submitting...' : 'Submit Feedback',
            onPressed: _isSubmitting ? null : _submit,
            isLoading: _isSubmitting,
            accentColor: accent,
            icon: const Icon(Icons.send_rounded, size: 16, color: Colors.black),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _FbField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;
  final Color accent;
  const _FbField({required this.label, required this.controller, required this.maxLines, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary, height: 1.4)),
      const SizedBox(height: 8),
      TextField(
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          filled: true, fillColor: AppColors.bg700,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: accent, width: 1.5)),
          contentPadding: const EdgeInsets.all(14),
        ),
      ),
    ]);
  }
}

class _FbRadio extends StatelessWidget {
  final String label;
  final String? value;
  final List<(String, String)> options;
  final void Function(String) onChanged;
  final Color accent;
  const _FbRadio({required this.label, required this.value, required this.options, required this.onChanged, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary, height: 1.4)),
      const SizedBox(height: 8),
      ...options.map((opt) {
        final isSelected = value == opt.$1;
        return GestureDetector(
          onTap: () => onChanged(opt.$1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? accent.withValues(alpha: 0.1) : AppColors.bg700,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isSelected ? accent.withValues(alpha: 0.5) : AppColors.border, width: isSelected ? 1.5 : 1),
            ),
            child: Row(children: [
              Container(
                width: 18, height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: isSelected ? accent : AppColors.textMuted, width: 2),
                  color: isSelected ? accent : Colors.transparent,
                ),
                child: isSelected ? const Icon(Icons.check_rounded, size: 10, color: Colors.black) : null,
              ),
              const SizedBox(width: 12),
              Text(opt.$2, style: GoogleFonts.inter(fontSize: 13, color: isSelected ? accent : AppColors.textSecondary, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
            ]),
          ),
        );
      }),
    ]);
  }
}

class _FbScale extends StatelessWidget {
  final String label;
  final String subLabel;
  final int? value;
  final int min;
  final int max;
  final void Function(int) onChanged;
  final Color accent;
  const _FbScale({required this.label, required this.subLabel, required this.value, required this.min, required this.max, required this.onChanged, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      const SizedBox(height: 2),
      Text(subLabel, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
      const SizedBox(height: 10),
      Row(
        children: List.generate(max - min + 1, (i) {
          final v = min + i;
          final isSelected = value == v;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(v),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: EdgeInsets.only(right: i < (max - min) ? 6 : 0),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? accent : AppColors.bg700,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isSelected ? accent : AppColors.border, width: isSelected ? 1.5 : 1),
                  boxShadow: isSelected ? [BoxShadow(color: accent.withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 2))] : null,
                ),
                child: Text('$v', textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: isSelected ? Colors.black : AppColors.textSecondary)),
              ),
            ),
          );
        }),
      ),
    ]);
  }
}
