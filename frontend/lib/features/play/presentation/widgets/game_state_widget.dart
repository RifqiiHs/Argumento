import 'package:flutter/material.dart';
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
  final bool showManual;

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
    this.showManual = false,
  });

  @override
  State<GameStateWidget> createState() => _GameStateWidgetState();
}

class _GameStateWidgetState extends State<GameStateWidget> {
  bool _isRejecting = false;
  final _reasonCtrl = TextEditingController();
  int _mobileTab = 0; // 0 = game, 1 = manual

  @override
  void dispose() {
    _reasonCtrl.dispose();
    super.dispose();
  }

  void _handleNext() {
    setState(() { _isRejecting = false; _reasonCtrl.clear(); });
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Mobile tab switcher
        Container(
          color: Colors.black,
          child: Row(
            children: [
              _TabBtn(label: 'TERMINAL', icon: Icons.terminal, isActive: _mobileTab == 0,
                  accentColor: widget.accentColor, onTap: () => setState(() => _mobileTab = 0)),
              _TabBtn(label: 'MANUAL', icon: Icons.book_outlined, isActive: _mobileTab == 1,
                  accentColor: widget.accentColor, onTap: () => setState(() => _mobileTab = 1)),
            ],
          ),
        ),
        Expanded(
          child: _mobileTab == 0 ? _buildGamePanel() : const ManualWidget(),
        ),
      ],
    );
  }

  Widget _buildGamePanel() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Post Card
          Container(
            decoration: BoxDecoration(
              color: AppColors.zinc950,
              border: Border.all(color: widget.accentColor, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: widget.accentColor.withOpacity(0.1),
                    border: Border(bottom: BorderSide(color: widget.accentColor, width: 2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.description, color: widget.accentColor, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'POST #${widget.currentIndex + 1}',
                            style: TextStyle(
                              fontFamily: 'Courier New',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: widget.accentColor,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: widget.accentColor),
                          color: widget.accentColor.withOpacity(0.1),
                        ),
                        child: Text(
                          'REF: ${widget.currentPost.id.substring(widget.currentPost.id.length > 6 ? widget.currentPost.id.length - 6 : 0).toUpperCase()}',
                          style: TextStyle(
                            fontFamily: 'Courier New',
                            fontSize: 10,
                            color: widget.accentColor,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 12),
                        decoration: BoxDecoration(
                          border: Border(left: BorderSide(color: widget.accentColor, width: 4)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'HEADLINE',
                              style: TextStyle(
                                fontFamily: 'Courier New',
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: widget.accentColor,
                                letterSpacing: 3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.currentPost.headline,
                              style: const TextStyle(
                                fontFamily: 'Courier New',
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'CONTENT',
                              style: TextStyle(
                                fontFamily: 'Courier New',
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: AppColors.zinc500,
                                letterSpacing: 3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.currentPost.content,
                              style: const TextStyle(
                                fontFamily: 'Courier New',
                                fontSize: 15,
                                color: AppColors.zinc300,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Action Area
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: widget.isResult ? _buildVerdictUI() : _buildActionUI(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerdictUI() {
    final isCorrect = widget.verdict?.isCorrect ?? false;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        border: Border.all(
          color: isCorrect ? Colors.green.withOpacity(0.5) : Colors.red.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.shield : Icons.warning_amber,
                color: isCorrect ? Colors.green : Colors.red,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'ASSESSMENT CORRECT' : 'ASSESSMENT FAILED',
                style: TextStyle(
                  fontFamily: 'Courier New',
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: isCorrect ? Colors.green : Colors.red,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.only(left: 12),
            decoration: const BoxDecoration(border: Border(left: BorderSide(color: AppColors.zinc700, width: 2))),
            child: Text(
              widget.verdict?.message ?? '',
              style: const TextStyle(fontFamily: 'Courier New', fontSize: 13, color: AppColors.zinc300, height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          AccentButton(
            label: 'Next Document →',
            onPressed: _handleNext,
            accentColor: widget.accentColor,
          ),
        ],
      ),
    );
  }

  Widget _buildActionUI() {
    if (_isRejecting) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          border: Border.all(color: Colors.red.withOpacity(0.5), width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.red, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'VIOLATION REPORT',
                      style: TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => setState(() => _isRejecting = false),
                  child: const Text(
                    '[Cancel]',
                    style: TextStyle(fontFamily: 'Courier New', fontSize: 11, color: AppColors.zinc500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _reasonCtrl,
              maxLines: 4,
              style: const TextStyle(fontFamily: 'Courier New', color: Colors.red, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Describe the identified violation or manipulation tactic...',
                hintStyle: const TextStyle(color: Color(0xFF7F1D1D), fontFamily: 'Courier New', fontSize: 12),
                filled: true,
                fillColor: Colors.black.withOpacity(0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Colors.red.withOpacity(0.5)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (widget.isAnalyzing || _reasonCtrl.text.trim().isEmpty)
                    ? null
                    : () => widget.onReject(_reasonCtrl.text),
                icon: widget.isAnalyzing
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                    : const Icon(Icons.shield_outlined, color: Colors.black, size: 18),
                label: Text(
                  widget.isAnalyzing ? 'ANALYZING...' : 'SUBMIT REPORT',
                  style: const TextStyle(fontFamily: 'Courier New', fontWeight: FontWeight.bold, letterSpacing: 1.5),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.black,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  disabledBackgroundColor: Colors.red.withOpacity(0.4),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        const Center(
          child: Text(
            'RENDER VERDICT',
            style: TextStyle(
              fontFamily: 'Courier New',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.zinc500,
              letterSpacing: 3,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: widget.isAnalyzing ? null : widget.onApprove,
                icon: const Icon(Icons.verified_user_outlined, size: 20),
                label: const Text(
                  'APPROVE',
                  style: TextStyle(fontFamily: 'Courier New', fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.withOpacity(0.1),
                  foregroundColor: Colors.green,
                  side: const BorderSide(color: Colors.green, width: 2),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: widget.isAnalyzing ? null : () => setState(() => _isRejecting = true),
                icon: const Icon(Icons.gpp_bad_outlined, size: 20),
                label: const Text(
                  'REJECT',
                  style: TextStyle(fontFamily: 'Courier New', fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.1),
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red, width: 2),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ---- Tab button ----
class _TabBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final Color accentColor;
  final VoidCallback onTap;

  const _TabBtn({required this.label, required this.icon, required this.isActive, required this.accentColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? accentColor : AppColors.zinc900.withOpacity(0.4),
            border: Border(
              right: const BorderSide(color: AppColors.zinc800),
              bottom: BorderSide(color: isActive ? accentColor : AppColors.zinc800),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isActive ? Colors.black : AppColors.zinc400),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Courier New',
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: isActive ? Colors.black : AppColors.zinc400,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
