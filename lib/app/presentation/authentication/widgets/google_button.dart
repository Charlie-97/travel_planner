import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_planner/app/presentation/home_page/home_page.dart';
import 'package:travel_planner/app/router/base_navigator.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        BaseNavigator.pushNamedAndReplace(HomePage.routeName);
      },
      icon: const Icon(FontAwesomeIcons.google),
      label: const Text('Continue with Google'),
    );
  }
}
