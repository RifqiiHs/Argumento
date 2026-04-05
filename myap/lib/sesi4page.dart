import 'package:flutter/material.dart';
import 'package:myap/sesi4page2.dart';

class Sesi4page extends StatefulWidget {
  const Sesi4page({super.key});

  @override
  State<Sesi4page> createState() => _Sesi4pageState();
}

class _Sesi4pageState extends State<Sesi4page> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title:Text('Jenis-jenis Navigasi'),
          bottom: TabBar(
            tabs: [
              Tab(text: "Pilihan 1"),
              Tab(text: "Pilihan 2"),
              Tab(text: "Pilihan 3"),
            ],
         ),
          actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem(
                  onTap: () {},
                  child: Text("Pilihan 1")
                  ),
                PopupMenuItem(
                  onTap: () {},
                  child: Text("Pilihan 2")
                  ),
                PopupMenuItem(
                  onTap: () {},
                  child: Text("Pilihan 3")
                  ),
              ];
            },
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blueAccent),
                child: Text(
                  "Judul Drawer",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    )
                  )
                ),
                ListTile(
                  title: Text("Pilihan 1"),
                  onTap: () {},
                ),
                ListTile(
                  title: Text("Pilihan 2"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Sesi4page2(),
                      )
                    );
                  },
                ),
                ListTile(
                  title: Text("Pilihan 3"),
                  onTap: () {},
                ),
            ],
          ),
        ),

        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: "Explore"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings"
            ),
          ]

          ),
        body: Center(
          child: TabBarView(
            children: [
              Column(
                children: [
                  Text("Halaman 1"),
                  Text("Halaman 2"),
                  Text("Halaman 3")
                ],
              ),
              Container(
                child: Text("Halaman 2")
              ),
              Container(
                child: Text("Halaman 3")
              )
            ]
            ),
        )
      )
    );
  }
}