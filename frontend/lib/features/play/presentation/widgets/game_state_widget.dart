import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/models.dart';
import '../../../../core/utils/widgets.dart';
import 'manual_widget.dart';

class GameStateWidget extends StatefulWidget {
  final PostModel currentPost;
  final int currentIndex;
  final PostVerdictModel? verdict;
  final bool isResult;
  final bool isAnalyzing;
  final VoidCallback onApprove;
  final Future<void> Function(String reason) onReject;
  final VoidCallback onNext;
  final Color accentColor;

  const GameStateWidget({
    super.key,
    required this.currentPost,
    required this.currentIndex,
    required this.verdict,
    required this.isResult,
    required this.isAnalyzing,
    required this.onApprove,
    required this.onReject,
    required this.onNext,
    required this.accentColor,
  });

  @override
  State<GameStateWidget> createState() => _GameStateWidgetState();
}

class _GameStateWidgetState extends State<GameStateWidget> {
  bool _isRejecting = false;
  final _reasonCtrl = TextEditingController();
  int _tab = 0;

  @override
  void dispose() { _reasonCtrl.dispose(); super.dispose(); }

  void _handleNext() {
    setState(() { _isRejecting = false; _reasonCtrl.clear(); });
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab bar
        Container(
          color: AppColors.bg800,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              _TabBtn(label: 'Post', icon: Icons.article_rounded, isActive: _tab == 0, accent: widget.accentColor, onTap: () => setState(() => _tab = 0)),
              const SizedBox(width: 8),
              _TabBtn(label: 'Field Manual', icon: Icons.menu_book_rounded, isActive: _tab == 1, accent: widget.accentColor, onTap: () => setState(() => _tab = 1)),
            ],
          ),
        ),
        Expanded(child: _tab == 0 ? _buildGamePanel() : const ManualWidget()),
      ],
    );
  }

  Widget _buildGamePanel() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Post card
          Container(
            decoration: BoxDecoration(
              color: AppColors.bg800,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(color: AppColors.bg600, borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.person_rounded, size: 18, color: AppColors.textMuted),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(widget.currentPost.headline, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text('Post #${widget.currentIndex + 1}', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                        ]),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.bg700, borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.border)),
                        child: Text('AI Generated', style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted)),
                      ),
                    ],
                  ),
                ),

                // Post content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    widget.currentPost.content,
                    style: GoogleFonts.inter(fontSize: 15, color: AppColors.textSecondary, height: 1.65),
                  ),
                ),

                // Action area
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: AppColors.border)),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
                    color: AppColors.bg700,
                  ),
                  child: widget.isResult ? _buildVerdictUI() : _buildActionUI(),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: 0.05, end: 0),
        ],
      ),
    );
  }

  Widget _buildVerdictUI() {
    final isCorrect = widget.verdict?.isCorrect ?? false;
    final color = isCorrect ? AppColors.success : AppColors.error;
    final bgColor = isCorrect ? AppColors.successBg : AppColors.errorBg;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withValues(alpha: 0.3))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded, color: color, size: 20),
                const SizedBox(width: 8),
                Text(isCorrect ? 'Correct Assessment' : 'Incorrect Assessment',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
              ]),
              const SizedBox(height: 8),
              Text(widget.verdict?.message ?? '', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
            ],
          ),
        ).animate().fadeIn().scale(begin: const Offset(0.98, 0.98)),
        const SizedBox(height: 12),
        AccentButton(label: 'Next Post', onPressed: _handleNext, accentColor: widget.accentColor,
            icon: const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.black)),
      ],
    );
  }

  Widget _buildActionUI() {
    if (_isRejecting) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rejection Report', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.error)),
              GestureDetector(
                onTap: () => setState(() => _isRejecting = false),
                child: Text('Cancel', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _reasonCtrl,
            maxLines: 3,
            onChanged: (_) => setState(() {}),
            style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Describe the logical flaw or manipulation tactic you detected...',
              hintStyle: GoogleFonts.inter(color: AppColors.textDisabled, fontSize: 13),
              filled: true,
              fillColor: AppColors.bg800,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.error, width: 1)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.error, width: 1)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.error, width: 1.5)),
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: (widget.isAnalyzing || _reasonCtrl.text.trim().isEmpty) ? null : () => widget.onReject(_reasonCtrl.text),
              icon: widget.isAnalyzing
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.send_rounded, size: 16),
              label: Text(widget.isAnalyzing ? 'Analyzing...' : 'Submit Report', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                disabledBackgroundColor: AppColors.error.withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Text('Your verdict?', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted)),
        const SizedBox(height: 10),
        GameActionButtons(
          onApprove: widget.onApprove,
          onReject: () => setState(() => _isRejecting = true),
          isDisabled: widget.isAnalyzing,
        ),
      ],
    );
  }
}

class _TabBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final Color accent;
  final VoidCallback onTap;
  const _TabBtn({required this.label, required this.icon, required this.isActive, required this.accent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? accent.withValues(alpha: 0.12) : AppColors.bg700,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isActive ? accent.withValues(alpha: 0.4) : AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isActive ? accent : AppColors.textMuted),
              const SizedBox(width: 6),
              Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400, color: isActive ? accent : AppColors.textMuted)),
            ],
          ),
        ),
      ),
    );
  }
}
