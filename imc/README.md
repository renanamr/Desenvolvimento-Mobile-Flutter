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
#### Verificando andamento...
Para verificar se seu projeto está igual a este, você pode usar o comando **git** abaixo:
```bash
git checkout 8f82457
```

## Parte 2 - Estruturas responsivas e uso do ListView
Itens trabalhados nessa parte do projeto:
* **`MediaQuery`** → obter o tamanho disponível da tela e adaptar espaçamentos/tamanhos.
* **`Expanded`** → fazer o histórico ocupar o espaço restante da tela.
* **`ListView`** → apresentar uma lista rolável das consultas realizadas.

### 1.Modificando a Screen — `imc_screen.dart`

A principal alteração ficará aqui.

```dart
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
```

### 2. Adicionando o componente `card_imc`

A fim de facilitar a reutilização dos elementos foi criado o componente para representar o item listado.
```dart 
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
```

### Onde estão os três novos conceitos?

### 1. `MediaQuery`

Foi utilizado para descobrir a largura disponível da tela:

```dart
final tamanhoTela = MediaQuery.sizeOf(context);
final paddingTela = tamanhoTela.width * 0.04;
```

E usamos essa informação no `Padding`:

```dart
padding: EdgeInsets.fromLTRB(paddingTela, paddingTela, paddingTela, 0),
```

Assim, em vez de utilizar um valor fixo o espaçamento é calculado proporcionalmente à largura da tela.
Desta forma, podemos usar o MediaQuery para consultar dados sobre proporções do dispositivo (largura, altura, quanidade de pixels, padding etc).
Abaixo segue exemplo de recuperação de altura e largura da tela:
```dart
MediaQuery.sizeOf(context).height;
MediaQuery.sizeOf(context).width;
```

### 2. `Expanded`

O ponto mais importante está aqui:

```dart
Expanded(
  child: ListView.builder(
    ...
  ),
),
```

O `Expanded` diz:

> "Utilize todo o espaço restante disponível para este widget."

Isso é particularmente importante porque o `ListView` precisa ficar limitado a uma altura dentro do `Column`.

Sem o `Expanded`, você pode encontrar problemas de **overflow** ou até mesmo erro ao gerar o widget da lista.

---

### 3. `ListView.builder`

O histórico é construído dinamicamente:

```dart
ListView.builder(
  padding: EdgeInsets.only(bottom: paddingTela),
  // Representa a quantidade de itens a ser listada
  itemCount: _historico.length,
  // Mostra os registros mais recentes primeiro
  itemBuilder: (context, index)=> CardIMC(imc: _historico[index]),
),
```

Se houver:

```text
_historico.length == 3
```

o Flutter construirá três itens. Cada item é baseado em um objeto `CardIMC`, que representa os dados listados.
E, caso existam muitos registros, o `ListView` permitirá a rolagem.

#### Verificando andamento...
Para verificar se seu projeto está igual a este, você pode usar o comando **git** abaixo:
```bash
git checkout 165fe6a
```

## Parte 3 - Theme
Nesta etapa, implementamos uma camada de estilização centralizada para tornar o aplicativo mais moderno e profissional, seguindo as diretrizes visuais do **Padrão Digital de Governo (DS Gov)**.

### Itens trabalhados nessa parte do projeto:
* **Classe `DSGovTheme`:** Criação de um tema customizado centralizado;
* **Paleta DS Gov:** Implementação das cores institucionais (Azul Institucional) e de feedback (Sucesso, Erro, Aviso);
* **Estilização Global:** Padronização de botões (`ElevatedButton`), campos de texto (`TextFormField`), `AppBar`, `Cards` e Diálogos;
* **Material 3:** Ativação e configuração do sistema de design mais recente do Android/Flutter.

### Importância e Vantagens
A utilização de um tema centralizado é fundamental para o desenvolvimento escalável:
1. **Manutenibilidade:** Qualquer alteração visual (como trocar a cor principal) é feita em um único arquivo e reflete em todo o app.
2. **Consistência Visual:** Garante que todos os componentes tenham a mesma aparência, proporcionando uma melhor experiência de usuário.
3. **Padronização:** Segue padrões de identidade visual reconhecidos (como o do Governo Federal), transmitindo mais confiança e profissionalismo.
4. **Agilidade:** Elimina a necessidade de estilizar manualmente cada novo widget adicionado ao projeto.

### Implementação do Tema Centralizado
A classe `DSGovTheme` define as cores e estilos de cada componente, adicione a estrutura abaixo em seu projeto:

```dart
import 'package:flutter/material.dart';

class DSGovTheme {
  // Paleta de Cores DS Gov (Padrão Digital de Governo)
  static const Color primary = Color(0xFF1351B4); // blue-warm-vivid-70
  static const Color primaryDark = Color(0xFF0C326F);
  static const Color background = Color(0xFFF8F8F8); // gray-warm-2
  static const Color surface = Colors.white;

  static const Color success = Color(0xFF168821); // green-cool-vivid-50
  static const Color warning = Color(0xFFFFCD07); // yellow-vivid-20
  static const Color error = Color(0xFFE52207);   // red-vivid-50
  static const Color info = Color(0xFF155BCB);    // blue-warm-vivid-60

  static const Color grayDark = Color(0xFF333333);
  static const Color grayMedium = Color(0xFF888888);
  static const Color grayLight = Color(0xFFE6E6E6);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: primaryDark,
        surface: background,
        error: error,
        onPrimary: Colors.white,
        onSurface: grayDark,
      ),
      scaffoldBackgroundColor: background,

      // Estilização da AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      // Estilização dos Botões
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Estilização dos Campos de Texto (Inputs)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(color: grayDark),
        hintStyle: const TextStyle(color: grayMedium),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: grayLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: grayLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: error),
        ),
      ),

      // Estilização dos Cards
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),

      // Tipografia
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: grayDark, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: grayDark, fontWeight: FontWeight.bold, fontSize: 18),
        bodyLarge: TextStyle(color: grayDark, fontSize: 16),
        bodyMedium: TextStyle(color: grayDark, fontSize: 14),
      ),

      // Estilização do ListTile (usado no histórico)
      listTileTheme: const ListTileThemeData(
        iconColor: primary,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: grayDark,
          fontSize: 16,
        ),
        subtitleTextStyle: TextStyle(
          color: grayMedium,
          fontSize: 14,
        ),
      ),

      // Estilização dos Diálogos
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          color: primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Estilização dos TextButtons (usados em diálogos)
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
```

### Aplicação no Projeto
O tema é aplicado no `MaterialApp` dentro do arquivo `main.dart`, tornando-o disponível para todo o aplicativo:

```dart
// lib/main.dart
return MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'Calculadora de IMC',
  theme: DSGovTheme.lightTheme, // Aplicação do tema customizado
  home: const ImcScreen(),
);
```
