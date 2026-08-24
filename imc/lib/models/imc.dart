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