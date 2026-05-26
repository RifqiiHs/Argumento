import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class ManualWidget extends StatelessWidget {
  const ManualWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg900,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Field Manual', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2),
          const SizedBox(height: 4),
          Text('Reference guide for identifying logical flaws', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2),
          const SizedBox(height: 20),
          ..._sections.map((s) => _ManualSection(title: s['title']!, color: s['color'] as Color, icon: s['icon'] as IconData, entries: s['entries']! as List<Map<String, String>>)),
        ],
      ),
    );
  }
}

final List<Map<String, dynamic>> _sections = [
  {
    'title': 'Logical Fallacies',
    'color': AppColors.primary,
    'icon': Icons.psychology_alt_rounded,
    'entries': [
      {'name': 'Ad Hominem', 'desc': 'Attacking the person making the argument rather than the argument itself.'},
      {'name': 'Strawman', 'desc': 'Misrepresenting someone\'s position to make it easier to attack.'},
      {'name': 'False Dichotomy', 'desc': 'Presenting only two options when more exist.'},
      {'name': 'Slippery Slope', 'desc': 'Claiming one event will inevitably lead to extreme consequences.'},
      {'name': 'Appeal to Authority', 'desc': 'Using authority as evidence without further support.'},
      {'name': 'Circular Reasoning', 'desc': 'Using the conclusion as a premise to support itself.'},
      {'name': 'Hasty Generalization', 'desc': 'Drawing broad conclusions from insufficient evidence.'},
      {'name': 'Red Herring', 'desc': 'Introducing an irrelevant topic to divert attention.'},
    ],
  },
  {
    'title': 'Cognitive Biases',
    'color': AppColors.accentAmber,
    'icon': Icons.blur_on_rounded,
    'entries': [
      {'name': 'Confirmation Bias', 'desc': 'Favoring information that confirms existing beliefs.'},
      {'name': 'Availability Heuristic', 'desc': 'Overestimating the likelihood of easily-remembered events.'},
      {'name': 'Anchoring Bias', 'desc': 'Over-relying on the first piece of information encountered.'},
      {'name': 'Bandwagon Effect', 'desc': 'Adopting beliefs because many others hold them.'},
      {'name': 'Dunning-Kruger', 'desc': 'Overestimating competence in areas of limited knowledge.'},
    ],
  },
  {
    'title': 'Media Manipulation',
    'color': AppColors.accentCyan,
    'icon': Icons.campaign_rounded,
    'entries': [
      {'name': 'Clickbait', 'desc': 'Sensationalized headlines that misrepresent the actual content.'},
      {'name': 'Framing Effect', 'desc': 'Presenting information in a way that influences interpretation.'},
      {'name': 'Cherry Picking', 'desc': 'Selecting only favorable evidence while ignoring contradictory data.'},
      {'name': 'False Balance', 'desc': 'Giving equal weight to unequal positions.'},
      {'name': 'Emotional Manipulation', 'desc': 'Using emotional language to bypass critical thinking.'},
    ],
  },
  {
    'title': 'AI Hallucinations',
    'color': AppColors.accentRed,
    'icon': Icons.smart_toy_rounded,
    'entries': [
      {'name': 'Fabricated Citations', 'desc': 'References to studies or sources that do not exist.'},
      {'name': 'False Expertise', 'desc': 'Presenting fabricated credentials as authoritative.'},
      {'name': 'Plausible Fabrication', 'desc': 'Generating convincing-sounding but entirely false information.'},
      {'name': 'Overconfident Claims', 'desc': 'Presenting uncertain information with complete certainty.'},
    ],
  },
];

class _ManualSection extends StatefulWidget {
  final String title;
  final Color color;
  final IconData icon;
  final List<Map<String, String>> entries;
  const _ManualSection({required this.title, required this.color, required this.icon, required this.entries});

  @override
  State<_ManualSection> createState() => _ManualSectionState();
}

class _ManualSectionState extends State<_ManualSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.bg800,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _expanded ? widget.color.withValues(alpha: 0.3) : AppColors.border),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Container(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: widget.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                    child: Icon(widget.icon, color: widget.color, size: 16),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(widget.title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
                  Icon(_expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, color: AppColors.textMuted, size: 20),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            Container(height: 1, color: AppColors.border),
            ...widget.entries.map((e) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: widget.entries.last == e ? Colors.transparent : AppColors.border.withValues(alpha: 0.5)))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(margin: const EdgeInsets.only(top: 6), width: 4, height: 4, decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle)),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(e['name']!, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2),
                    const SizedBox(height: 2),
                    Text(e['desc']!, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted, height: 1.4),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2),
                  ])),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }
}
