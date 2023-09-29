import 'package:flutter/material.dart';
import 'package:travel_planner/app/presentation/home_page/home_page.dart';
import 'package:travel_planner/app/presentation/splash/splash_screen.dart';
import 'package:travel_planner/app/router/app_router.dart';
import 'package:travel_planner/app/router/base_navigator.dart';
import 'package:travel_planner/component/constants.dart';
import 'package:travel_planner/services/local_storage/object_box/object_box_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectbox = await ObjectBox.create();

  runApp(const TravelPlannerApp());
}

class TravelPlannerApp extends StatelessWidget {
  const TravelPlannerApp({super.key});

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(),

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
      initialRoute: HomePage.routeName,
    );
  }
}
