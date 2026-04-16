import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'config/routes.dart';

/// Root application widget for RaktSetu.
/// Configures Material 3 theming, routing, and global app behavior.
class RaktSetuApp extends StatelessWidget {
  const RaktSetuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RaktSetu',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: RaktSetuTheme.lightTheme,
      darkTheme: RaktSetuTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Routing
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,

      // Global error handling for widgets
      builder: (context, child) {
        return MediaQuery(
          // Prevent system font scaling from breaking layouts
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child!,
        );
      },
    );
  }
}
