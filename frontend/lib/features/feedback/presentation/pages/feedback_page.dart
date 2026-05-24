import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
    _descCtrl.dispose();
    _favoriteCtrl.dispose();
    _frustratedCtrl.dispose();
    _improvementsCtrl.dispose();
    _elseCtrl.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _descCtrl.text.trim().isNotEmpty &&
      _expectation != null &&
      _favoriteCtrl.text.trim().isNotEmpty &&
      _frustratedCtrl.text.trim().isNotEmpty &&
      _clarity != null &&
      _playAgain != null &&
      _improvementsCtrl.text.trim().isNotEmpty &&
      _learned != null &&
      _changesMedia != null;

  Future<void> _submit() async {
    if (!_isValid) {
      ArgumentoSnackBar.show(context, 'Please fill all required fields.', isError: true);
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await ApiService().submitFeedback({
        'description': _descCtrl.text.trim(),
        'expectation': _expectation,
        'favoritePart': _favoriteCtrl.text.trim(),
        'frustrated': _frustratedCtrl.text.trim(),
        'clarity': _clarity,
        'playAgainTomorrow': _playAgain,
        'improvements': _improvementsCtrl.text.trim(),
        'learnedSomething': _learned,
        'changesSocialMedia': _changesMedia,
        'anythingElse': _elseCtrl.text.trim(),
      });
      setState(() => _submitted = true);
    } catch (e) {
      if (mounted) ArgumentoSnackBar.show(context, 'Failed to submit. Try again.', isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state.user;
    final accentColor = AppTheme.getAccentColor(user?.activeTheme ?? 'theme_green');

    return Scaffold(
      backgroundColor: AppColors.zinc950,
      appBar: AppBar(
        backgroundColor: AppColors.zinc950,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.zinc400), onPressed: () => context.go('/dashboard')),
        title: const Text('FEEDBACK', style: TextStyle(fontFamily: 'Courier New', fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppColors.zinc800)),
      ),
      body: _submitted ? _buildThanks(accentColor) : _buildForm(accentColor),
    );
  }

  Widget _buildThanks(Color accentColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.mark_chat_read, color: accentColor, size: 64),
            const SizedBox(height: 24),
            Text('THANK YOU', style: TextStyle(fontFamily: 'Courier New', fontSize: 28, fontWeight: FontWeight.w900, color: accentColor, letterSpacing: 2), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            const Text('Your feedback has been submitted. It helps us improve Argumento.', style: TextStyle(fontFamily: 'Courier New', color: AppColors.zinc400, fontSize: 13), textAlign: TextAlign.center),
            const SizedBox(height: 32),
            AccentButton(label: 'Back to Dashboard', accentColor: accentColor, onPressed: () => context.go('/dashboard')),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(Color accentColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Share your experience with Argumento. All fields marked are required.', style: TextStyle(fontFamily: 'Courier New', fontSize: 13, color: AppColors.zinc400, height: 1.5)),
          const SizedBox(height: 24),

          _FeedbackField(label: 'How would you describe Argumento to a friend?', controller: _descCtrl, maxLines: 3),
          const SizedBox(height: 20),

          _FeedbackRadio<String>(
            label: "Compared to your expectations, Argumento was...",
            value: _expectation,
            options: const [('better', 'Better than expected'), ('same', 'About the same'), ('worse', 'Worse than expected')],
            onChanged: (v) => setState(() => _expectation = v),
            accentColor: accentColor,
          ),
          const SizedBox(height: 20),

          _FeedbackField(label: "What was your favorite part?", controller: _favoriteCtrl, maxLines: 2),
          const SizedBox(height: 20),

          _FeedbackField(label: "What frustrated you most?", controller: _frustratedCtrl, maxLines: 2),
          const SizedBox(height: 20),

          _FeedbackScale(
            label: "How clear were the game mechanics? (1=very unclear, 4=very clear)",
            value: _clarity,
            min: 1, max: 4,
            onChanged: (v) => setState(() => _clarity = v),
            accentColor: accentColor,
          ),
          const SizedBox(height: 20),

          _FeedbackScale(
            label: "How likely are you to play again tomorrow? (1=not at all, 5=definitely)",
            value: _playAgain,
            min: 1, max: 5,
            onChanged: (v) => setState(() => _playAgain = v),
            accentColor: accentColor,
          ),
          const SizedBox(height: 20),

          _FeedbackField(label: "What would make Argumento better?", controller: _improvementsCtrl, maxLines: 2),
          const SizedBox(height: 20),

          _FeedbackRadio<String>(
            label: "Did you learn something new today?",
            value: _learned,
            options: const [('yes_lot', 'Yes, a lot!'), ('yes_little', 'Yes, a little'), ('not_really', 'Not really'), ('already_knew', 'Already knew it')],
            onChanged: (v) => setState(() => _learned = v),
            accentColor: accentColor,
          ),
          const SizedBox(height: 20),

          _FeedbackRadio<String>(
            label: "Will this change how you engage with social media?",
            value: _changesMedia,
            options: const [('yes', 'Yes, definitely'), ('maybe', 'Maybe'), ('probably_not', 'Probably not'), ('no', 'No')],
            onChanged: (v) => setState(() => _changesMedia = v),
            accentColor: accentColor,
          ),
          const SizedBox(height: 20),

          _FeedbackField(label: "Anything else you'd like to add? (optional)", controller: _elseCtrl, maxLines: 2),
          const SizedBox(height: 32),

          AccentButton(
            label: _isSubmitting ? 'Submitting...' : 'Submit Feedback',
            onPressed: _isSubmitting ? null : _submit,
            isLoading: _isSubmitting,
            accentColor: accentColor,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _FeedbackField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;

  const _FeedbackField({required this.label, required this.controller, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Courier New', fontSize: 12, color: AppColors.zinc300, height: 1.4)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(fontFamily: 'Courier New', color: Colors.white, fontSize: 13),
          decoration: const InputDecoration(
            filled: true,
            fillColor: AppColors.zinc900,
            border: OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: AppColors.zinc800)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: AppColors.zinc800)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: AppColors.green500, width: 2)),
            contentPadding: EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }
}

class _FeedbackRadio<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<(T, String)> options;
  final void Function(T) onChanged;
  final Color accentColor;

  const _FeedbackRadio({required this.label, required this.value, required this.options, required this.onChanged, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Courier New', fontSize: 12, color: AppColors.zinc300, height: 1.4)),
        const SizedBox(height: 8),
        ...options.map((opt) {
          final isSelected = value == opt.$1;
          return GestureDetector(
            onTap: () => onChanged(opt.$1),
            child: Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? accentColor.withOpacity(0.1) : AppColors.zinc900,
                border: Border.all(color: isSelected ? accentColor : AppColors.zinc800, width: isSelected ? 2 : 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: isSelected ? accentColor : AppColors.zinc600, width: 2),
                      color: isSelected ? accentColor : Colors.transparent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(opt.$2, style: TextStyle(fontFamily: 'Courier New', fontSize: 12, color: isSelected ? accentColor : AppColors.zinc300)),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _FeedbackScale extends StatelessWidget {
  final String label;
  final int? value;
  final int min;
  final int max;
  final void Function(int) onChanged;
  final Color accentColor;

  const _FeedbackScale({required this.label, required this.value, required this.min, required this.max, required this.onChanged, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Courier New', fontSize: 12, color: AppColors.zinc300, height: 1.4)),
        const SizedBox(height: 10),
        Row(
          children: List.generate(max - min + 1, (i) {
            final v = min + i;
            final isSelected = value == v;
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(v),
                child: Container(
                  margin: EdgeInsets.only(right: i < (max - min) ? 6 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected ? accentColor : AppColors.zinc900,
                    border: Border.all(color: isSelected ? accentColor : AppColors.zinc800, width: isSelected ? 2 : 1),
                  ),
                  child: Text(
                    '$v',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Courier New', fontSize: 14, fontWeight: FontWeight.bold, color: isSelected ? Colors.black : AppColors.zinc300),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
