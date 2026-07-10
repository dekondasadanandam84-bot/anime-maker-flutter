import 'package:flutter/material.dart';

// Screens
import 'screens/collaboration_screen.dart';
import 'screens/premium_screen.dart';
import 'screens/create_project_screen.dart';
import 'screens/earn_credits_screen.dart';
import 'package:flutter_application_1/widgets/app_layout.dart';

void main() {
  runApp(const AnimeMakerApp());
}

enum RouteDirection { forward, back }

class AnimeMakerApp extends StatelessWidget {
  const AnimeMakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anime Maker',

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromARGB(255, 137, 58, 255),
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),

      initialRoute: '/',

      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return slideRoute(const ResponsiveRoot());

          case '/collaboration':
            return slideRoute(const CollaborationScreen());

          case '/earn-credits':
            return slideRoute(const EarnCreditsScreen());

          case '/premium':
            return slideRoute(const PremiumScreen());

          case '/create-project':
            return slideRoute(const CreateProjectScreen());

          case '/create-manga-project':
            return slideRoute(const CreateProjectScreen(isManga: true));

          default:
            return slideRoute(const ResponsiveRoot());
        }
      },
    );
  }
}

// 🌐 RESPONSIVE ROOT (PHONE vs TABLET)
class ResponsiveRoot extends StatelessWidget {
  const ResponsiveRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLayout();
  }
}



//
// 🚀 ROUTE ANIMATION
//
PageRouteBuilder slideRoute(
  Widget page, {
  RouteDirection direction = RouteDirection.forward,
}) {
  final begin = direction == RouteDirection.forward
      ? const Offset(1.0, 0.0)
      : const Offset(-1.0, 0.0);

  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(begin: begin, end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeInOut));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}