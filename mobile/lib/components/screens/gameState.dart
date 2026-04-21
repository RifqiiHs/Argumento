import 'package:flutter/material.dart';

class GameStateComponent extends StatefulWidget {
  const GameStateComponent({super.key});

  @override
  State<GameStateComponent> createState() => _GameStateComponentState();
}

class _GameStateComponentState extends State<GameStateComponent> {
  @override
  Widget build(BuildContext context) {
    const neon = Color(0xff00e676);
    const deepBlack = Color(0xff03050a);
    const muted = Color(0xff7a7f88);
    const textWhite = Color(0xffdfe2e6);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: deepBlack,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: neon, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.article_outlined, color: neon, size: 22),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'POST #1',
                          style: TextStyle(
                            color: neon,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff0c3525),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: neon),
                    ),
                    child: const Text(
                      'REF: C0_L1_P1',
                      style: TextStyle(
                        color: neon,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 2, color: neon),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 26, 20, 28),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 4, color: neon),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HEADLINE',
                          style: TextStyle(
                            color: neon,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'City Park Maintenance\nScheduled',
                          style: TextStyle(
                            color: textWhite,
                            fontWeight: FontWeight.w700,
                            height: 1.15,
                          ),
                        ),
                        SizedBox(height: 34),
                        Text(
                          'CONTENT',
                          style: TextStyle(
                            color: muted,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3,
                          ),
                        ),
                        SizedBox(height: 18),
                        Text(
                          'The north side of Central Park will be\nclosed for routine landscaping this\nTuesday from 9 AM to 11 AM. Visitors can\naccess the south entrance during this\ntime.',
                          style: TextStyle(
                            color: textWhite,
                            fontWeight: FontWeight.w500,
                            height: 1.42,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 14),
                child: Text(
                  'VERDICT',
                  style: TextStyle(
                    color: muted,
                    letterSpacing: 4.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.verified_user_outlined, size: 22),
                      label: const Text('APPROVE'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: neon,
                        side: const BorderSide(color: neon, width: 2),
                        backgroundColor: const Color(0xff032216),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.highlight_off, size: 22),
                      label: const Text('REJECT'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xffff3b4f),
                        side: const BorderSide(
                          color: Color(0xffff3b4f),
                          width: 2,
                        ),
                        backgroundColor: const Color(0xff2d0309),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
