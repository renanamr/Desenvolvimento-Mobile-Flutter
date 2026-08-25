import 'package:flutter/material.dart';
import 'package:imc/screens/imc_screen.dart';
import 'package:imc/theme/ds_gov_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora de IMC',
      theme: DSGovTheme.lightTheme,
      home: const ImcScreen(),
    );
  }
}