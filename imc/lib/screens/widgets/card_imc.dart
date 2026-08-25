import 'package:flutter/material.dart';
import 'package:imc/models/imc.dart';

class CardIMC extends StatelessWidget {
  final IMC imc;
  const CardIMC({
    super.key,
    required this.imc
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.calculate_outlined),
        ),
        title: Text(
          imc.classificacao,
        ),
        subtitle: Text(
          'Peso: ${imc.peso.toStringAsFixed(0)} kg\n'
              'Altura: ${imc.altura.toStringAsFixed(2)} m',
        ),
        trailing: Text(
          'IMC\n${imc.resultado.toStringAsFixed(2)}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
