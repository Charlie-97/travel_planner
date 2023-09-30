import 'package:flutter/material.dart';
import 'package:travel_planner/app/presentation/home_page/home_page.dart';
import 'package:travel_planner/app/presentation/settings/screen/settings.dart';

class Navigation extends StatefulWidget {
  static const routeName = "navigation";
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: () {
        switch (currentIndex) {
          case 0:
            return const HomePage();
          case 1:
            return const SettingsScreen();
        }
      }(),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            )
          ]),
    );
  }
}
