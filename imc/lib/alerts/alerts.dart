import 'package:flutter/material.dart';
import '../models/imc.dart';

void mostrarAlertImc({
  required BuildContext context,
  required IMC imc,
}){
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Resultado do IMC'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              imc.resultado.toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(imc.classificacao),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Fechar'),
          ),
        ],
      );
    },
  );
}