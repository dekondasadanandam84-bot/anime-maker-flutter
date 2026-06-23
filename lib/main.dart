import 'package:flutter/material.dart';
import 'package:flutter_application_1/earn_credits_screen.dart';
import 'home_dashboard.dart';
import 'collaboration_screen.dart';
import 'premium_screen.dart';

void main() {
  runApp(const AnimeMakerApp());
}

enum RouteDirection {
  forward,
  back,
}

class AnimeMakerApp extends StatelessWidget {
  const AnimeMakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anime Maker',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
      ),

      // First screen
      initialRoute: '/',

      // Global route animations
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return slideRoute(const HomeDashboardScreen());
            
          case '/collaboration':
            return slideRoute(const CollaborationScreen());

            case '/earn-credits':
          return slideRoute(const EarnCreditsScreen());

          case '/premium':
            return slideRoute(const PremiumScreen());

          default:
            return slideRoute(const HomeDashboardScreen());
        }
      },
    );
  }
}

// Global slide animation
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
      final tween = Tween(
        begin: begin,
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeInOut));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}