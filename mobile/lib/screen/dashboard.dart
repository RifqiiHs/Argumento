import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HackerColors {
  static const Color black = Color(0xff000000);
  static const Color neonGreenAccent = Color(0xff1dff90);
  static const Color demoModeBlue = Color(0xff1d90ff);
  static const Color textDescriptionGrey = Color(0xff2c2c2c);
  static const Color serverTimeGrey = Color(0xff505050);
}

void main() {
  runApp(const HackerDashboardApp());
}

class HackerDashboardApp extends StatelessWidget {
  const HackerDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terminal Dashboard',
      theme: ThemeData(
        scaffoldBackgroundColor: HackerColors.black,
        textTheme: GoogleFonts.firaCodeTextTheme(
          ThemeData.dark().textTheme,
        ).apply(bodyColor: Colors.white, displayColor: Colors.white),
        primaryColor: HackerColors.neonGreenAccent,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildHeaderRow(),
            const SizedBox(height: 30),
            _buildDashboardCardGrid(),
            const SizedBox(height: 24),
            _buildBottomCardsRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildCommonCard({
    required Widget header,
    required Widget content,
    Color borderColor = HackerColors.neonGreenAccent,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1.0),
        borderRadius: BorderRadius.circular(4), // Subtle rounding
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [header, const SizedBox(height: 18), content],
      ),
    );
  }

  Widget _buildLargeAccentText(
    String text, [
    Color color = HackerColors.neonGreenAccent,
  ]) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w900,
        color: color,
        letterSpacing: -1.0,
      ),
    );
  }

  Widget _buildDescriptionText(
    String text, [
    Color color = HackerColors.textDescriptionGrey,
  ]) {
    return Text(
      text,
      style: TextStyle(fontSize: 12, color: color, letterSpacing: 0.5),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.shield_outlined,
                    color: HackerColors.neonGreenAccent,
                    size: 14,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'LOGGED IN AS',
                    style: TextStyle(
                      color: HackerColors.neonGreenAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Main bold monospace username
              _buildLargeAccentText('JohnDoe', Colors.white),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'SERVER TIME',
                    style: TextStyle(
                      color: HackerColors.neonGreenAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              // Right-aligned grey server time
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '8:47:44 PM',
                    style: TextStyle(
                      color: HackerColors.serverTimeGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardCardGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildCommonCard(
                header: _buildCardHeader('TOTAL EXP', Icons.abc),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLargeAccentText('0'),
                    _buildDescriptionText('XP Points Accumulated'),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildCommonCard(
                header: _buildCardHeader(
                  'TOTAL COINS',
                  Icons.account_balance_wallet_outlined,
                ),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLargeAccentText('0'),
                    _buildDescriptionText('Total Coins Accumulated'),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildCommonCard(
                header: _buildCardHeader(
                  'STREAK',
                  Icons.local_fire_department_outlined,
                ),
                content: Row(
                  children: [
                    _buildComplexValueDesc('0', 'Current'),
                    const SizedBox(width: 40),
                    _buildComplexValueDesc('0', 'Record'),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildCommonCard(
                header: _buildCardHeader(
                  'PERFORMANCE',
                  Icons.bar_chart_outlined,
                ),
                content: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLargeAccentText('0.0%'),
                        Text(
                          'Accuracy Rating',
                          style: TextStyle(
                            color: HackerColors.neonGreenAccent,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _buildLargeAccentText(
                            '0/0',
                            HackerColors.textDescriptionGrey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardHeader(
    String label,
    IconData icon, [
    Color color = HackerColors.neonGreenAccent,
  ]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        Icon(icon, color: color, size: 16),
      ],
    );
  }

  Widget _buildComplexValueDesc(String value, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLargeAccentText(value, HackerColors.textDescriptionGrey),
        _buildDescriptionText(desc),
      ],
    );
  }

  Widget _buildBottomCardsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildCommonCard(
            header: _buildCardHeader(
              'DAILY ASSIGNMENT',
              Icons.play_arrow_outlined,
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDescriptionText(
                  'Pending tasks available.',
                  Colors.grey[400]!,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HackerColors.neonGreenAccent,
                      foregroundColor: HackerColors.black,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'INITIATE SHIFT',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildCommonCard(
            borderColor: HackerColors.demoModeBlue,
            header: _buildCardHeader(
              'DEMO MODE',
              Icons.shield_outlined,
              HackerColors.demoModeBlue,
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDescriptionText(
                  'Train without pressure.',
                  Colors.grey[400]!,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: HackerColors.demoModeBlue,
                      side: const BorderSide(
                        color: HackerColors.demoModeBlue,
                        width: 1,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'INITIATE SHIFT',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
