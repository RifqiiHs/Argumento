import 'package:flutter/material.dart';
import 'package:mobile/components/button.dart';

class GameSetup extends StatefulWidget {
  const GameSetup({super.key});

  @override
  State<GameSetup> createState() => _GameSetupState();
}

class _GameSetupState extends State<GameSetup> {
  late TextEditingController _postAmountController;

  @override
  void initState() {
    super.initState();
    _postAmountController = TextEditingController(text: '3');
  }

  @override
  void dispose() {
    _postAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const neon = Color(0xff00e676);
    const deepBlack = Color(0xff03050a);
    const muted = Color(0xff7a7f88);
    const textWhite = Color(0xffdfe2e6);
    const scrollBg = Color(0xff1a1a1a);

    return Scaffold(
      backgroundColor: deepBlack,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CUSTOM SIMULATION',
                      style: TextStyle(
                        color: textWhite,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Select specific protocols to test your detection\nability.',
                      style: TextStyle(color: muted, height: 1.4),
                    ),
                    const SizedBox(height: 24),
                    Container(height: 1, color: muted),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: deepBlack,
                  border: Border.all(color: neon, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LOGICAL FALLACIES',
                      style: TextStyle(
                        color: neon,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(height: 1, color: muted.withOpacity(0.8)),
                    const SizedBox(height: 20),
                    Wrap(spacing: 12, runSpacing: 12, children: const [
                      
                    ],
                  ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: deepBlack,
                  border: Border.all(color: muted.withOpacity(0.25), width: 1),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                        border: Border.all(color: muted.withOpacity(0.3)),
                      ),
                      child: Icon(Icons.lock_outline, color: muted, size: 34),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'COGNITIVE BIASES',
                      style: TextStyle(
                        color: muted,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        border: Border.all(color: muted.withOpacity(0.15)),
                      ),
                      child: const Text(
                        'LOCKED: Complete campaign_2',
                        style: TextStyle(color: muted, fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.warning_outlined, color: neon, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'AI JUDGE AND POST GENERATION COULD BE WRONG.',
                          style: TextStyle(
                            color: neon,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: 220,
                      decoration: BoxDecoration(
                        color: deepBlack,
                        border: Border.all(color: neon, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              'POST AMOUNT:',
                              style: TextStyle(
                                color: neon,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _postAmountController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: textWhite,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    NeonButton(
                      label: 'GENERATE',
                      icon: Icons.play_arrow,
                      backgroundColor: neon,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
