import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../models/compromisso_model.dart';
import '../../../../repositories/agenda/agenda_repository.dart';
import '../../../../shared/either.dart';

class AgendaStore extends Store<List<CompromissoModel>> {
  final AgendaRepository _repository;
  CalendarController calendarController = CalendarController();

  AgendaStore(this._repository) : super(<CompromissoModel>[]) {
    getCompromissosDaSemana();
  }

  Future<Either<String, String>> atualizarCompromisso({
    required String codigo,
    required String titulo,
    required String descricao,
    required bool diaTodo,
    required DateTime data,
  }) async {
    final result = await _repository.atualizarCompromisso(
      codigo: codigo,
      titulo: titulo,
      diaTodo: diaTodo,
      descricao: descricao,
      data: data,
    );

    result.fold(
      (error) => setError(error),
      (success) {
        getCompromissosDaSemana();
      },
    );

    return result;
  }

  Future<Either<String, String>> salvarCompromisso({
    required String titulo,
    required String descricao,
    required DateTime data,
    required TimeOfDay hora,
  }) async {
    final result = await _repository.salvarCompromisso(
      titulo: titulo,
      descricao: descricao,
      data: data,
      hora: hora,
    );

    result.fold(
      (error) => setError(error),
      (success) {
        getCompromissosDaSemana();
      },
    );

    return result;
  }

  Future<Either<String, CompromissoModel>> getCompromissoPorCodigo(
      String compromissoCodigo) async {
    final result = await _repository.getCompromissoPorCodigo(compromissoCodigo);

    return result;
  }

  Future<Either<String, List<CompromissoModel>>>
      getCompromissosDaSemana() async {
    setLoading(true);

    final result = await _repository.getCompromissosDaSemana();

    result.fold(
      (error) => setError(error),
      (compromissos) {
        update(compromissos);
        setLoading(false);
      },
    );

    return result;
  }
}
