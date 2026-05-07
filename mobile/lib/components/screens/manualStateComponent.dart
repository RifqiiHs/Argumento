import 'package:flutter/material.dart';
import '../../utils/content_types.dart';
import '../../theme/app_colors.dart';

class ManualStateComponent extends StatefulWidget {
  const ManualStateComponent({super.key});

  @override
  State<ManualStateComponent> createState() => _ManualStateComponentState();
}

class _ManualStateComponentState extends State<ManualStateComponent> {
  int currTypeIndex = 0;
  int currTopicIndex = 0;
  bool isOpened = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.scrollBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.panelDivider),
        boxShadow: [
          BoxShadow(color: AppColors.neon.withOpacity(0.06), blurRadius: 30),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0B0F12), Color(0xFF0A0B0D)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              border: Border(bottom: BorderSide(color: AppColors.panelDivider)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.neon.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.bookmark,
                    color: AppColors.neon,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Manual',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: AppColors.textWhite,
                        letterSpacing: 1,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Use this whenever necessary',
                      style: TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: isOpened ? _buildDetail(context) : _buildTopics(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetail(BuildContext context) {
    final item = contentTypes[currTypeIndex];
    final types = (item['types'] as List).cast<Map<String, dynamic>>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: () => setState(() => isOpened = false),
            icon: const Icon(Icons.arrow_back, size: 16),
            label: const Text(
              'Back to Topics',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            style: TextButton.styleFrom(foregroundColor: AppColors.neon),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: AppColors.neon, width: 4)),
            ),
            padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  types[currTopicIndex]['name'] as String,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.neon,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${item['name']} • Topic ${currTopicIndex + 1}',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.verdictBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.panelDivider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Definition',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.neon,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  types[currTopicIndex]['definition'] as String,
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopics(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxis = width > 700 ? 2 : 1;

    return SingleChildScrollView(
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxis,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3 / 2,
            ),
            itemCount: contentTypes.length,
            itemBuilder: (context, i) {
              final item = contentTypes[i];
              final types = (item['types'] as List)
                  .cast<Map<String, dynamic>>();

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F1720), Color(0xFF0B0F12)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.panelDivider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.neon.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.bookmark,
                        color: AppColors.neon,
                        size: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['name'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: AppColors.textWhite,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['description'] as String,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: types.map((type) {
                        final tIndex = types.indexOf(type);
                        return OutlinedButton(
                          onPressed: () => setState(() {
                            currTypeIndex = i;
                            currTopicIndex = tIndex;
                            isOpened = true;
                          }),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.neon.withOpacity(0.35),
                            ),
                            backgroundColor: Colors.transparent,
                            foregroundColor: AppColors.neon,
                          ),
                          child: Text(
                            (type['name'] as String).toUpperCase(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
