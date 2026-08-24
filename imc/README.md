# App IMC
Nesse projeto serão demonstrados conceitos como:
* `Form`, `GlobalKey<FormState>` e `TextFormField`;
* `ListView`, `MediaQuery` e `Expanded`;
* `Theme` e `ThemeData`;
* `Navigator`;


## Parte 1 - Estruturas de Forms
Itens trabalhados nessa parte do projeto.
* `Form` e `GlobalKey<FormState>`;
* `TextFormField`;
* `TextInputFormatter` para máscara da altura;
* `FilteringTextInputFormatter` para permitir apenas números;
* limite de dígitos para o peso;
* `validator` para validar os campos;
* cálculo do IMC;
* `AlertDialog` para apresentar o resultado.

### Estrutura do projeto

Implementação da classe main: 
```dart
import 'package:flutter/material.dart';
import 'package:imc/screens/imc_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de IMC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const ImcScreen(),
    );
  }
}
```

Implementação da classe IMC na pasta models, para representar as informações do calculo:
```dart
class IMC{
  final double peso;
  final double altura;
  late double resultado;
  late String classificacao;

  IMC({
    required this.altura,
    required this.peso,
  }){
    resultado = _calcularImc(peso, altura);
    classificacao = _classificarImc(resultado);
  }

  double _calcularImc(double peso, double altura) => peso / (altura * altura);

  String _classificarImc(double imc) {
    if (imc < 18.5) {
      return 'Abaixo do peso';
    } else if (imc < 25) {
      return 'Peso normal';
    } else if (imc < 30) {
      return 'Sobrepeso';
    } else {
      return 'Obesidade';
    }
  }

}
```

Implementação da classe imc_screen na pasta screens, para construção da tela:
```dart
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
```


### O que está sendo trabalhado no exemplo

**1. Form**

O `Form` agrupa os campos que precisam ser validados:

```dart
final _formKey = GlobalKey<FormState>();
```

E:

```dart
Form(
  key: _formKey,
  child: Column(
    children: [
      // campos
    ],
  ),
)
```

Para executar todas as validações:

```dart
if (!_formKey.currentState!.validate()) {
  return;
}
```

---

**2. Validação numérica**

O `double.tryParse()` permite verificar se o conteúdo realmente representa um número:

```dart
final peso = double.tryParse(value);

if (peso == null) {
  return 'Informe um valor numérico';
}
```

Isso é preferível ao `double.parse()` dentro do `validator`, pois `tryParse()` não lança uma exceção quando o valor é inválido.

---

**3. Limitação de dígitos do peso**

Aqui o peso aceita somente números e no máximo **3 dígitos**:

```dart
inputFormatters: [
  FilteringTextInputFormatter.digitsOnly,
  LengthLimitingTextInputFormatter(3),
],
```

mas não consegue inserir letras ou mais de três dígitos.

---

**4. Máscara/formatação da altura**

Para a altura foi utilizado um `FilteringTextInputFormatter` com expressão regular:

```dart
inputFormatters: [
  FilteringTextInputFormatter.allow(
    RegExp(r'^\d{0,1}([,.]\d{0,2})?$'),
  ),
],
```

Isso permite valores como:

```text
1
1,7
1,75
1.75
```

A altura é posteriormente convertida para `double`:

```dart
final altura = double.parse(
  _alturaController.text.replaceAll(',', '.'),
);
```

A substituição é necessária porque o Dart utiliza `.` como separador decimal.

---

**5. AlertDialog**

Depois do cálculo, o resultado é apresentado em um diálogo:

```dart
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
```
