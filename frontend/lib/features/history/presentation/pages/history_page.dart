import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/app_state.dart';
import '../../../../core/utils/models.dart';
import '../../../../core/utils/widgets.dart';

// ============ HISTORY LIST PAGE ============
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state.user;
    final accentColor = AppTheme.getAccentColor(user?.activeTheme ?? 'theme_green');
    final history = user?.postsHistory.reversed.toList() ?? [];

    return Scaffold(
      backgroundColor: AppColors.zinc950,
      appBar: AppBar(
        backgroundColor: AppColors.zinc950,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.zinc400), onPressed: () => context.go('/dashboard')),
        title: const Text('POST LOG', style: TextStyle(fontFamily: 'Courier New', fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppColors.zinc800)),
      ),
      body: history.isEmpty
          ? EmptyState(
              title: 'No History Yet',
              subtitle: 'Complete a daily shift to see your log.',
              icon: Icon(Icons.history, color: AppColors.zinc600, size: 48),
            )
          : ListView.builder(
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
                        bottom: const BorderSide(color: AppColors.zinc900),
                        left: BorderSide(
                          color: item.isCorrect ? accentColor : Colors.red,
                          width: 4,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (post != null) ...[
                                Text(
                                  post.headline,
                                  style: const TextStyle(fontFamily: 'Courier New', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  post.content,
                                  style: const TextStyle(fontFamily: 'Courier New', fontSize: 11, color: AppColors.zinc500),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      color: post.type == 'slop'
                                          ? Colors.red.withOpacity(0.15)
                                          : AppColors.green500.withOpacity(0.15),
                                      child: Text(
                                        post.type.toUpperCase(),
                                        style: TextStyle(
                                          fontFamily: 'Courier New',
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: post.type == 'slop' ? Colors.red : AppColors.green500,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (post.category != null)
                                      Text(
                                        post.category!.replaceAll('_', ' ').toUpperCase(),
                                        style: const TextStyle(fontFamily: 'Courier New', fontSize: 9, color: AppColors.zinc600, letterSpacing: 1),
                                      ),
                                  ],
                                ),
                              ] else ...[
                                Text(
                                  'Post ID: ${item.postId.substring(0, item.postId.length > 8 ? 8 : item.postId.length)}...',
                                  style: const TextStyle(fontFamily: 'Courier New', fontSize: 12, color: AppColors.zinc500),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(
                              item.isCorrect ? Icons.shield : Icons.gpp_bad,
                              color: item.isCorrect ? accentColor : Colors.red,
                              size: 22,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.isCorrect ? 'CORRECT' : 'WRONG',
                              style: TextStyle(
                                fontFamily: 'Courier New',
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: item.isCorrect ? accentColor : Colors.red,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ============ HISTORY DETAIL PAGE ============
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
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final post = await ApiService().getPost(widget.postId);
      setState(() { _post = post; _isLoading = false; });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state.user;
    final accentColor = AppTheme.getAccentColor(user?.activeTheme ?? 'theme_green');
    final historyItem = user?.postsHistory.firstWhere(
      (h) => h.postId == widget.postId,
      orElse: () => PostHistoryModel(postId: widget.postId, isCorrect: false),
    );

    return Scaffold(
      backgroundColor: AppColors.zinc950,
      appBar: AppBar(
        backgroundColor: AppColors.zinc950,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.zinc400), onPressed: () => context.go('/history')),
        title: const Text('POST DETAIL', style: TextStyle(fontFamily: 'Courier New', fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppColors.zinc800)),
      ),
      body: _isLoading
          ? LoadingOverlay(accentColor: accentColor)
          : _post == null
              ? const EmptyState(title: 'Post not found')
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Result banner
                      if (historyItem != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: (historyItem.isCorrect ? AppColors.green500 : Colors.red).withOpacity(0.1),
                            border: Border.all(color: historyItem.isCorrect ? AppColors.green500 : Colors.red, width: 2),
                          ),
                          child: Row(
                            children: [
                              Icon(historyItem.isCorrect ? Icons.shield : Icons.gpp_bad, color: historyItem.isCorrect ? AppColors.green500 : Colors.red, size: 24),
                              const SizedBox(width: 12),
                              Text(
                                historyItem.isCorrect ? 'YOUR ASSESSMENT: CORRECT' : 'YOUR ASSESSMENT: INCORRECT',
                                style: TextStyle(fontFamily: 'Courier New', fontSize: 14, fontWeight: FontWeight.bold, color: historyItem.isCorrect ? AppColors.green500 : Colors.red, letterSpacing: 1),
                              ),
                            ],
                          ),
                        ),

                      // Post content
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: accentColor, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 12),
                              decoration: BoxDecoration(border: Border(left: BorderSide(color: accentColor, width: 4))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('HEADLINE', style: TextStyle(fontFamily: 'Courier New', fontSize: 9, color: accentColor, letterSpacing: 3, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  Text(_post!.headline, style: const TextStyle(fontFamily: 'Courier New', fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, height: 1.2)),
                                  const SizedBox(height: 14),
                                  const Text('CONTENT', style: TextStyle(fontFamily: 'Courier New', fontSize: 9, color: AppColors.zinc500, letterSpacing: 3, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  Text(_post!.content, style: const TextStyle(fontFamily: 'Courier New', fontSize: 14, color: AppColors.zinc300, height: 1.6)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Verdict section - show real answer
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _post!.type == 'slop' ? Colors.red.withOpacity(0.08) : AppColors.green500.withOpacity(0.08),
                          border: Border.all(color: _post!.type == 'slop' ? Colors.red : AppColors.green500, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(_post!.type == 'slop' ? Icons.warning_amber : Icons.verified_user, color: _post!.type == 'slop' ? Colors.red : AppColors.green500, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  _post!.type == 'slop' ? 'VERDICT: SLOP DETECTED' : 'VERDICT: SAFE CONTENT',
                                  style: TextStyle(fontFamily: 'Courier New', fontSize: 14, fontWeight: FontWeight.w900, color: _post!.type == 'slop' ? Colors.red : AppColors.green500, letterSpacing: 1),
                                ),
                              ],
                            ),
                            if (_post!.reasons.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              const Text('VIOLATIONS:', style: TextStyle(fontFamily: 'Courier New', fontSize: 10, color: AppColors.zinc500, letterSpacing: 2, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              ..._post!.reasons.map((r) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.circle, color: Colors.red, size: 6),
                                        const SizedBox(width: 8),
                                        Text(r.toUpperCase().replaceAll('_', ' '), style: const TextStyle(fontFamily: 'Courier New', fontSize: 12, color: Colors.red)),
                                      ],
                                    ),
                                  )),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Metadata
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(border: Border.all(color: AppColors.zinc800)),
                        child: Column(
                          children: [
                            _MetaRow(label: 'Type', value: _post!.type.toUpperCase()),
                            _MetaRow(label: 'Category', value: (_post!.category ?? '-').toUpperCase().replaceAll('_', ' ')),
                            _MetaRow(label: 'Origin', value: _post!.origin.toUpperCase()),
                            _MetaRow(label: 'Post ID', value: _post!.id.substring(0, 8).toUpperCase()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetaRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label.toUpperCase(), style: const TextStyle(fontFamily: 'Courier New', fontSize: 10, color: AppColors.zinc500, letterSpacing: 1.5)),
          Text(value, style: const TextStyle(fontFamily: 'Courier New', fontSize: 12, color: AppColors.zinc300, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
