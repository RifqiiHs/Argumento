import 'package:flutter/material.dart';

class Sesi4page2 extends StatelessWidget {
  const Sesi4page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Halaman2"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Kembali ke halaman sebelumnya"),
        )
      )
    );
  }
}