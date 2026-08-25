import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imc/screens/widgets/card_imc.dart';

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

  // Lista que armazenará o histórico das consultas
  final List<IMC> _historico = [];

  @override
  void dispose() {
    _pesoController.dispose();
    _alturaController.dispose();
    super.dispose();
  }

  void _calcularImc() {
    // Verifica se os campos foram preenchidos corretamente
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final peso = double.parse(
      _pesoController.text.replaceAll(',', '.'),
    );

    final altura = double.parse(
      _alturaController.text.replaceAll(',', '.'),
    );

    final imc = IMC(
      altura: altura,
      peso: peso,
    );

    // Atualiza a tela adicionando a nova consulta ao histórico
    setState(() {
      _historico.add(imc);
    });

    // Exibe o resultado
    mostrarAlertImc(
      context: context,
      imc: imc,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtém as dimensões da tela
    final tamanhoTela = MediaQuery.sizeOf(context);
    final paddingTela = tamanhoTela.width * 0.04;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(paddingTela, paddingTela, paddingTela, 0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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

                  if (altura <= 0) {
                    return 'Informe uma altura válida';
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

              const SizedBox(height: 24),

              if(_historico.isNotEmpty)
                Text(
                  'Histórico de consultas',
                  style: Theme.of(context).textTheme.titleLarge,
                ),

              const SizedBox(height: 8),

              // O histórico ocupa o espaço restante
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: paddingTela),
                  // Representa a quantidade de itens a ser listada
                  itemCount: _historico.length,
                  // Mostra os registros mais recentes primeiro
                  itemBuilder: (context, index)=>
                      CardIMC(imc: _historico[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}