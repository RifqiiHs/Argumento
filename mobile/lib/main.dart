import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/screen/landing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Argumento',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.greenAccent,
        colorScheme: const ColorScheme.dark(
          primary: Colors.greenAccent,
          secondary: Colors.white,
        ),
        textTheme: GoogleFonts.firaCodeTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: Colors.grey[300],
            displayColor: Colors.white,
          ),
        ),
      ),

      home: LandingScreen(),
    );
  }
}
