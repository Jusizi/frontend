import 'package:flutter/material.dart';

import '../../models/compromisso_model.dart';
import '../../shared/either.dart';

abstract class AgendaRepository {
  Future<Either<String, List<CompromissoModel>>> getCompromissosDaSemana();
  Future<Either<String, String>> salvarCompromisso({
    required String titulo,
    required String descricao,
    required DateTime data,
    required TimeOfDay hora,
  });

  Future<Either<String, String>> atualizarCompromisso({
    required String codigo,
    required String titulo,
    required bool diaTodo,
    required String descricao,
    required DateTime data,
  });

  Future<Either<String, CompromissoModel>> getCompromissoPorCodigo(
      String compromissoCodigo);
}
