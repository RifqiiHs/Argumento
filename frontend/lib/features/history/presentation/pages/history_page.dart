import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/app_state.dart';
import '../../../../core/utils/models.dart';
import '../../../../core/utils/widgets.dart';

// ── History List ────────────────────────────────────────────
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state.user;
    final accent = AppTheme.getAccentColor(user?.activeTheme ?? 'theme_green');
    final history = user?.postsHistory.reversed.toList() ?? [];

    return Scaffold(
      backgroundColor: AppColors.bg900,
      appBar: AppBar(
        backgroundColor: AppColors.bg900,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.bg700, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: AppColors.textSecondary)),
          onPressed: () => context.go('/dashboard'),
        ),
        title: Text('Post History', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppColors.border)),
      ),
      body: history.isEmpty
          ? EmptyState(
              title: 'No history yet',
              subtitle: 'Complete a daily shift to see your post log here.',
              icon: const Icon(Icons.history_rounded, size: 40, color: AppColors.textMuted),
            )
          : Column(
              children: [
                // Summary bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: AppColors.bg800,
                  child: Row(children: [
                    Text('${history.length} posts reviewed', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted)),
                    const Spacer(),
                    StatusBadge(
                      label: '${history.where((h) => h.isCorrect).length} correct',
                      color: accent,
                    ),
                  ]),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (ctx, i) {
                      final item = history[i];
                      final post = item.post;
                      return GestureDetector(
                        onTap: () => context.go('/history/${item.postId}'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: const BorderSide(color: AppColors.border),
                              left: BorderSide(color: item.isCorrect ? accent : AppColors.error, width: 3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (post != null) ...[
                                      Text(post.headline, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 4),
                                      Text(post.content, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted), maxLines: 2, overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 6),
                                      Row(children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: post.type == 'slop' ? AppColors.errorBg : AppColors.successBg,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(post.type.toUpperCase(), style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: post.type == 'slop' ? AppColors.error : AppColors.success)),
                                        ),
                                        if (post.category != null) ...[
                                          const SizedBox(width: 6),
                                          Text(post.category!.replaceAll('_', ' '), style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                                        ],
                                      ]),
                                    ] else
                                      Text('Post ID: ${item.postId.substring(0, 8)}...', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                Icon(item.isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded, color: item.isCorrect ? accent : AppColors.error, size: 22),
                                const SizedBox(height: 2),
                                Text(item.isCorrect ? 'Right' : 'Wrong', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: item.isCorrect ? accent : AppColors.error)),
                              ]),
                            ],
                          ),
                        ).animate().fadeIn(delay: Duration(milliseconds: i < 15 ? i * 20 : 0)),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

// ── History Detail ───────────────────────────────────────────
class HistoryDetailPage extends StatefulWidget {
  final String postId;
  const HistoryDetailPage({super.key, required this.postId});
  @override
  State<HistoryDetailPage> createState() => _HistoryDetailPageState();
}

class _HistoryDetailPageState extends State<HistoryDetailPage> {
  PostModel? _post;
  bool _isLoading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final post = await ApiService().getPost(widget.postId);
      setState(() { _post = post; _isLoading = false; });
    } catch (_) { setState(() => _isLoading = false); }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state.user;
    final accent = AppTheme.getAccentColor(user?.activeTheme ?? 'theme_green');
    final historyItem = user?.postsHistory.firstWhere(
      (h) => h.postId == widget.postId,
      orElse: () => PostHistoryModel(postId: widget.postId, isCorrect: false),
    );

    return Scaffold(
      backgroundColor: AppColors.bg900,
      appBar: AppBar(
        backgroundColor: AppColors.bg900,
        elevation: 0,
        leading: IconButton(
          icon: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.bg700, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: AppColors.textSecondary)),
          onPressed: () => context.go('/history'),
        ),
        title: Text('Post Detail', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppColors.border)),
      ),
      body: _isLoading
          ? LoadingOverlay(accentColor: accent)
          : _post == null
              ? const EmptyState(title: 'Post not found')
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Your result banner
                      if (historyItem != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: historyItem.isCorrect ? AppColors.successBg : AppColors.errorBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: (historyItem.isCorrect ? AppColors.success : AppColors.error).withValues(alpha: 0.3)),
                          ),
                          child: Row(children: [
                            Icon(historyItem.isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                                color: historyItem.isCorrect ? AppColors.success : AppColors.error, size: 22),
                            const SizedBox(width: 10),
                            Text(historyItem.isCorrect ? 'Your Assessment Was Correct' : 'Your Assessment Was Incorrect',
                                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: historyItem.isCorrect ? AppColors.success : AppColors.error)),
                          ]),
                        ).animate().fadeIn(),
                        const SizedBox(height: 14),
                      ],

                      // Post content card
                      Container(
                        decoration: BoxDecoration(color: AppColors.bg800, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                        child: Column(
                          children: [
                            // Header
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(children: [
                                Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.bg600, borderRadius: BorderRadius.circular(10)),
                                    child: const Icon(Icons.person_rounded, size: 18, color: AppColors.textMuted)),
                                const SizedBox(width: 10),
                                Expanded(child: Text(_post!.headline, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
                              ]),
                            ),
                            Container(height: 1, color: AppColors.border),
                            // Content
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(_post!.content, style: GoogleFonts.inter(fontSize: 15, color: AppColors.textSecondary, height: 1.65)),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 100.ms),
                      const SizedBox(height: 14),

                      // Verdict card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _post!.type == 'slop' ? AppColors.errorBg : AppColors.successBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: (_post!.type == 'slop' ? AppColors.error : AppColors.success).withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Icon(_post!.type == 'slop' ? Icons.warning_amber_rounded : Icons.verified_rounded,
                                  color: _post!.type == 'slop' ? AppColors.error : AppColors.success, size: 20),
                              const SizedBox(width: 8),
                              Text(_post!.type == 'slop' ? 'Slop Detected' : 'Safe Content',
                                  style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: _post!.type == 'slop' ? AppColors.error : AppColors.success)),
                            ]),
                            if (_post!.reasons.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text('Violations:', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              ..._post!.reasons.map((r) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(children: [
                                  Container(width: 6, height: 6, margin: const EdgeInsets.only(right: 8, top: 1), decoration: BoxDecoration(color: AppColors.error, shape: BoxShape.circle)),
                                  Text(r.replaceAll('_', ' '), style: GoogleFonts.inter(fontSize: 13, color: AppColors.error, fontWeight: FontWeight.w500)),
                                ]),
                              )),
                            ],
                          ],
                        ),
                      ).animate().fadeIn(delay: 200.ms),
                      const SizedBox(height: 14),

                      // Metadata
                      InfoCard(children: [
                        InfoRow(label: 'Type', value: _post!.type.toUpperCase()),
                        InfoRow(label: 'Category', value: (_post!.category ?? '-').replaceAll('_', ' ').toUpperCase()),
                        InfoRow(label: 'Origin', value: _post!.origin.toUpperCase()),
                        InfoRow(label: 'Post ID', value: _post!.id.substring(0, 8).toUpperCase(), isLast: true),
                      ]).animate().fadeIn(delay: 250.ms),
                    ],
                  ),
                ),
    );
  }
}
