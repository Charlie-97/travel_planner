import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_planner/app/presentation/splash/splash_screen.dart';
import 'package:travel_planner/app/router/app_router.dart';
import 'package:travel_planner/app/router/base_navigator.dart';
import 'package:travel_planner/services/local_storage/shared_prefs.dart';
import 'package:travel_planner/services/local_storage/sqflite/sqflite_service.dart';

bool navigationIconLoading = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStorage.instance.initialize();
  SqfLiteService.instance.openDb();
  runApp(
    const TravelPlannerApp(),
  );
}

class TravelPlannerApp extends StatefulWidget {
  const TravelPlannerApp({super.key});

  @override
  State<TravelPlannerApp> createState() => _TravelPlannerAppState();
}

class _TravelPlannerAppState extends State<TravelPlannerApp> {
  @override
  void initState() {
    super.initState();
    SqfLiteService.instance.openDb();
  }

  @override
  void dispose() {
    SqfLiteService.instance.closeDb();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Planner',
      debugShowCheckedModeBanner: false,

      /// This is where we get access to the navigation key to be used for several thingsin our app
      /// Navigation purposes,
      /// getting global buildcontext context to use generally in the app.
      navigatorKey: BaseNavigator.key,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true, textTheme: GoogleFonts.ubuntuTextTheme(Theme.of(context).textTheme)

          /// This is where we added our own custom theme extensions to the app.
          /// We can add ranging from text theme to button theme, to all sorts,
          /// But we decided on only text theme for the project
          /// You can follow the fallback for definitions
          // extensions: const [EventsTextTheme.fallback()],
          ),
      builder: (context, child) {
        /// This is where we impose our UI restrictions on the app using mediaQuery
        /// We restricted the scale as well as the pixelRatio to conform to that of the apps
        /// irrespective of the device
        final mediaQuery = MediaQuery.of(context);
        final scale = mediaQuery.textScaleFactor.clamp(0.85, 0.9);
        final pixelRatio = mediaQuery.devicePixelRatio.clamp(1.0, 1.0);

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: scale,
            devicePixelRatio: pixelRatio,
          ),
          child: child!,
        );
      },

      /// Follow Definitions
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: SplashScreen.routeName,
    );
  }
}
