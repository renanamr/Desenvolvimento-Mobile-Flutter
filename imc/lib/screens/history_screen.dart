import 'package:flutter/material.dart';
import '../models/imc.dart';
import 'widgets/card_imc.dart';

class HistoryScreen extends StatelessWidget {
  final List<IMC> historico;

  const HistoryScreen({
    super.key,
    required this.historico,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Consultas'),
      ),
      body: historico.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma consulta realizada ainda.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: historico.length,
              itemBuilder: (context, index) {
                // Mostra os registros mais recentes primeiro
                final item = historico[historico.length - 1 - index];
                return CardIMC(imc: item);
              },
            ),
    );
  }
}
