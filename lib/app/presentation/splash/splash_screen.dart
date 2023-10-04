import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:travel_planner/app/presentation/authentication/screens/sign_in.dart';
import 'package:travel_planner/app/presentation/navigation.dart';
import 'package:travel_planner/app/router/base_navigator.dart';
import 'package:travel_planner/services/local_storage/shared_prefs.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "splash";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final storage = AppStorage.instance;

  @override
  void initState() {
    super.initState();
    initCheck();
  }

  initCheck() async {
    await Future.delayed(const Duration(milliseconds: 2400));
    if (storage.getToken() == null) {
      BaseNavigator.pushNamedAndclear(SignInScreen.routeName);
    } else {
      BaseNavigator.pushNamedAndclear(Navigation.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: Lottie.asset(
                  "assets/plane.json",
                ),
              ),
            ),
            const SizedBox(height: 10),
            FadeInUp(
              duration: const Duration(milliseconds: 800),
              child: const Text(
                "Travel Planner",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Euclid",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
