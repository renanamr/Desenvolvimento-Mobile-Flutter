import 'package:deputados_information/modules/deputados/domain/entities/deputado.dart';

enum DeputadoDetailsStatus {
  initial,
  loading,
  success,
  error,
}

class DeputadoDetailsState {
  final DeputadoDetailsStatus status;
  final Deputado? deputado;
  final Object? error;

  const DeputadoDetailsState({
    required this.status,
    this.deputado,
    this.error,
  });

  factory DeputadoDetailsState.initial() {
    return const DeputadoDetailsState(
      status: DeputadoDetailsStatus.initial,
    );
  }

  DeputadoDetailsState copyWith({
    DeputadoDetailsStatus? status,
    Deputado? deputado,
    Object? error,
  }) {
    return DeputadoDetailsState(
      status: status ?? this.status,
      deputado: deputado ?? this.deputado,
      error: error ?? this.error,
    );
  }
}