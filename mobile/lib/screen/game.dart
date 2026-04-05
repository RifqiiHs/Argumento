import 'package:flutter/material.dart';

class name extends StatefulWidget {
  const name({super.key});

  @override
  _nameState createState() => _nameState();
}

class _nameState extends State<name> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const Center(
      child: Text(
        'TERMINAL INTERFACE LOADING...',
        style: TextStyle(color: Colors.greenAccent),
      ),
    ),
    const Center(
      child: Text(
        'MANUAL DATABANKS OPEN...',
        style: TextStyle(color: Colors.white),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.greenAccent,
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
