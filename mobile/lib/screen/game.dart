import 'package:flutter/material.dart';
import 'package:mobile/components/screens/briefingStateComponent.dart';
import 'package:mobile/components/screens/gameSetup.dart';
import 'package:mobile/components/screens/gameState.dart';
import 'package:mobile/components/screens/manualStateComponent.dart';
import 'package:mobile/screen/dashboard.dart';
import 'package:mobile/screen/login.dart';
import 'package:mobile/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _currentIndex = 0;
  String? _shiftData;
  bool _isLoadingShiftData = true;
  bool _isRedirecting = false;

  final List<Widget> _screens = [
    const GameStateComponent(),
    const BriefingStateComponent(),
  ];

  @override
  void initState() {
    super.initState();
    _loadShiftData();
  }

  Future<void> _loadShiftData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _shiftData = prefs.getString("shift_data");
      _isLoadingShiftData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoadingShiftData && _shiftData == null && !_isRedirecting) {
      _isRedirecting = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GameSetup()),
        );
      });
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: SafeArea(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Dashboard'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.computer),
                title: const Text('Game'),
                onTap: () => Navigator.pop(context),
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
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: AppColors.neon,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.computer),
            label: 'TERMINAL',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'MANUAL'),
        ],
      ),
    );
  }
}
