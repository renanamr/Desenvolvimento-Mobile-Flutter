import 'package:flutter/material.dart';
import 'package:imc/screens/history_screen.dart';
import 'package:imc/screens/imc_screen.dart';
import 'package:imc/theme/ds_gov_theme.dart';
import 'package:imc/utils/routes_app.dart';
import 'models/imc.dart';

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
      initialRoute: RoutesApp.imc,
      onGenerateRoute: (settings) {
        if (settings.name == RoutesApp.imc) {
          return MaterialPageRoute(
            builder: (_) => const ImcScreen(),
          );
        }

        if (settings.name == RoutesApp.history) {
          // Extraindo a lista de argumentos passados via Navigator
          final args = settings.arguments as List<IMC>? ?? [];
          return MaterialPageRoute(
            builder: (_) => HistoryScreen(historico: args),
          );
        }

        return null; // Caso a rota não exista
      },
    );
  }
}
