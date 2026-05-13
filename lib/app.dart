import 'package:flutter/material.dart';
import 'core/features/dashboard/dashboard_screen.dart';

class AeroFlowApp extends StatelessWidget {
  const AeroFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AeroFlow',
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.blue),
      home: const DashboardScreen(),
    );
  }
}
