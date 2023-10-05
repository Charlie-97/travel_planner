import 'dart:io';

import 'package:flutter/material.dart';
import 'package:travel_planner/app/presentation/home_page/home_page.dart';
import 'package:travel_planner/app/presentation/settings/screen/settings.dart';
import 'package:travel_planner/component/overlays/dialogs.dart';
import 'package:travel_planner/main.dart';

class Navigation extends StatefulWidget {
  static const routeName = "navigation";
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentIndex = 0;
  bool get isLastPage => ModalRoute.of(context)!.isFirst;

  void closeAppUsingExit() {
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isLastPage != false) {
          final s = await AppOverlays.showExitConfirmationDialog(context);
          if (mounted) {
            if (s) {
              closeAppUsingExit();
            }
          }
          return false;
        }
        return false;
      },
      child: Scaffold(
        body: switch (currentIndex) {
          0 => const HomePage(),
          1 => const SettingsScreen(),
          _ => const HomePage(),
        },
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (value) {
            if (navigationIconLoading) {
              return;
            }
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
          ],
        ),
      ),
    );
  }
}
