import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/components/button.dart';
import 'package:mobile/components/screens/gameSetup.dart';
import 'package:mobile/screen/game.dart';
import 'package:mobile/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScheme {
  static const Color black = Color(0xff000000);
  static const Color neonGreenAccent = Color(0xff1dff90);
  static const Color demoModeBlue = Color(0xff1d90ff);
  static const Color textDescriptionGrey = Color(0xff2c2c2c);
  static const Color serverTimeGrey = Color(0xff505050);
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardScheme.black,
      appBar: AppBar(
        backgroundColor: DashboardScheme.black,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: DashboardScheme.black,
        child: SafeArea(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Dashboard'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.computer),
                title: const Text('Game'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const GameScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('token');
                  if (!context.mounted) {
                    return;
                  }
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Logged in as",
                        style: TextStyle(
                          color: DashboardScheme.neonGreenAccent,
                        ),
                      ),
                      Text(
                        "JohnDoe",
                        style: TextStyle(fontSize: 32, fontWeight: .bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: DashboardScheme.black,
                    border: Border.all(
                      color: const Color(0xff1dff90),
                      width: 2.0,
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total EXP"),
                      SizedBox(height: 8),
                      Text(
                        "0",
                        style: TextStyle(fontSize: 28, fontWeight: .bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: DashboardScheme.black,
                    border: Border.all(
                      color: const Color(0xff1dff90),
                      width: 2.0,
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Coins"),
                      SizedBox(height: 8),
                      Text(
                        "0",
                        style: TextStyle(fontSize: 28, fontWeight: .bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: DashboardScheme.black,
                    border: Border.all(
                      color: const Color(0xff1dff90),
                      width: 2.0,
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Streak"),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("0", style: TextStyle(fontSize: 28)),
                              SizedBox(height: 8),
                              Text("Current"),
                            ],
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("0", style: TextStyle(fontSize: 28)),
                              SizedBox(height: 8),
                              Text("Best"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: DashboardScheme.black,
                    border: Border.all(
                      color: const Color(0xff1dff90),
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Performance"),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: GoogleFonts.firaCode().fontFamily,
                          ),
                          children: [
                            TextSpan(text: "0.0% ["),
                            TextSpan(
                              text: "0",
                              style: TextStyle(
                                color: DashboardScheme.neonGreenAccent,
                              ),
                            ),
                            TextSpan(text: " / "),
                            TextSpan(
                              text: "0",
                              style: TextStyle(color: Colors.red),
                            ),
                            TextSpan(text: "]"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: DashboardScheme.black,
                    border: Border.all(
                      color: const Color(0xff1dff90),
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Daily Assignment"),
                      const SizedBox(height: 8),
                      NeonButton(
                        label: 'Initiate Shift',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GameSetup(),
                            ),
                          );
                        },
                        backgroundColor: DashboardScheme.neonGreenAccent,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: DashboardScheme.black,
                    border: Border.all(
                      color: DashboardScheme.demoModeBlue,
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Demo Mode"),
                      const SizedBox(height: 8),
                      NeonButton(
                        label: 'Start Demo Mode',
                        backgroundColor: DashboardScheme.demoModeBlue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
