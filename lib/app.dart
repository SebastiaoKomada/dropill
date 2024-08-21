import 'package:dropill_project/common/constants/routes.dart';
import 'package:dropill_project/features/config/config_page.dart';
import 'package:dropill_project/features/home/home_page.dart';
import 'package:dropill_project/features/home/home_page_view.dart';
import 'package:dropill_project/features/medication/medication_page.dart';
import 'package:dropill_project/features/monitoring/monitoring_page.dart';
import 'package:dropill_project/features/profile/profile_page.dart';
import 'package:dropill_project/features/sign_in/sign_in_page.dart';
import 'package:dropill_project/features/sign_up/sign_up_page.dart';
import 'package:dropill_project/features/splash/splash_page.dart';
import 'package:dropill_project/features/confirmation/confirmation_page.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      initialRoute: NamedRoute.initial,
      routes: {
        NamedRoute.initial: (context) => const SignUpPage(),
        NamedRoute.splash: (context) => const SplashPage(),
        NamedRoute.sigIn: (context) => const SignInPage(),
        NamedRoute.profile: (context) => const ProfilePage(),
        NamedRoute.home: (context) => const HomePage(),
        NamedRoute.homeView: (context) => const HomePageView(),
        NamedRoute.config: (context) => const ConfigPage(),
        NamedRoute.monitoring: (context) => const MonitoringPage(),
        NamedRoute.createMedication: (context) => const MedicationPage(),
        NamedRoute.confirmation: (context) => const ConfirmationPage(),
      },
    );
  }
}
