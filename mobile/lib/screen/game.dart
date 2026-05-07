import 'package:flutter/material.dart';
import 'package:mobile/components/screens/gameSetup.dart';
import 'package:mobile/components/screens/gameState.dart';
import 'package:mobile/components/screens/manualStateComponent.dart';
import 'package:mobile/components/ui/dashboard_shell.dart';
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
    const ManualStateComponent(),
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
    return DashboardShell(
      title: 'Game',
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
