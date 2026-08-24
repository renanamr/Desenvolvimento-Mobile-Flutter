import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../alerts/alerts.dart';
import '../models/imc.dart';

class ImcScreen extends StatefulWidget {
  const ImcScreen({super.key});

  @override
  State<ImcScreen> createState() => _ImcScreenState();
}

class _ImcScreenState extends State<ImcScreen> {
  final _formKey = GlobalKey<FormState>();

  final _pesoController = TextEditingController();
  final _alturaController = TextEditingController();

  @override
  void dispose() {
    _pesoController.dispose();
    _alturaController.dispose();
    super.dispose();
  }

  void _calcularImc() {
    //Verifica se campos foram preenchidos corretamente
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final peso = double.parse(_pesoController.text.replaceAll(',', '.'),);

    final altura = double.parse(_alturaController.text.replaceAll(',', '.'),);

    final imc = IMC(altura: altura, peso: peso);
    mostrarAlertImc(context:context, imc: imc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _pesoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Peso',
                  hintText: 'Ex.: 70',
                  suffixText: 'kg',
                  border: OutlineInputBorder(),
                ),

                // Limita o peso a 3 dígitos
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o peso';
                  }

                  final peso = double.tryParse(value);

                  if (peso == null) {
                    return 'Informe um valor numérico';
                  }

                  if (peso <= 0) {
                    return 'Informe um peso válido';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _alturaController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Altura',
                  hintText: 'Ex.: 1,75',
                  suffixText: 'm',
                  border: OutlineInputBorder(),
                ),

                // Permite números e uma vírgula para a altura
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d{0,1}([,.]\d{0,2})?$'),
                  ),
                ],

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a altura';
                  }

                  final altura = double.tryParse(
                    value.replaceAll(',', '.'),
                  );

                  if (altura == null) {
                    return 'Informe um valor numérico';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _calcularImc,
                  child: const Text('Calcular IMC'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}