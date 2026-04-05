import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Sesi66666 extends StatefulWidget {
    const Sesi66666({super.key});

    @override
    State<Sesi66666> createState() => _Sesi66666State();
}

class _Sesi66666State extends State<Sesi66666> {
    String temperature = "Data not found";

    Future<void> fetchWeather() async {
        final url = Uri.parse("https://api.open-meteo.com/v1/forecast?latitude=-6.18&longitude=106.73&current_weather=true");
        try {
            final response = await http.get(url);
            if(response.statusCode == 200){
                final data = jsonDecode(response.body);
                setState(() => temperature = "${data['current_weather']['temperature']} °C");
            } else {
                temperature = "Failed to fetch data";
            }
        } catch (e) {
            setState(() => temperature = "Network error");
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Penggunaan API'), centerTitle: true,
            ),
            body: Column(
                children: [
                    Card(
                        child: Column(
                            children: [
                              const SizedBox(height:15),
                              const Icon(Icons.cloud),
                              const SizedBox(height:8),
                              const Text("Cuaca Jakarta", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                              Text(temperature),
                              SizedBox(height:8),
                              ElevatedButton.icon(
                                  onPressed: fetchWeather,
                                  icon: Icon(Icons.refresh),
                                  label: Text("Refresh")
                              )
                            ],
                        )
                    ),
                ],
            ),
        );
    }
}