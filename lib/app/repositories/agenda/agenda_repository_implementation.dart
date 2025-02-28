import 'package:flutter/material.dart';

import '../../models/compromisso_model.dart';
import '../../shared/either.dart';
import '../../shared/services/httpClient/DIOHttpClientServiceImplementation.dart';
import '../../shared/services/httpClient/IHttpClientServiceInterface.dart';
import 'agenda_repository.dart';

class AgendaRepositoryImplementation implements AgendaRepository {
  late final IHttpClientServiceInterface _httpClientService;

  AgendaRepositoryImplementation() {
    _httpClientService = DIOHttpClientServiceImplementation();
  }

  @override
  Future<Either<String, String>> salvarCompromisso({
    required String titulo,
    required String descricao,
    required DateTime data,
    required TimeOfDay hora,
  }) async {
    TimeOfDay horaFim = TimeOfDay(hour: hora.hour + 1, minute: hora.minute);
    String dataInicio = '${data.year}-${data.month}-${data.day}';
    String dataFim = '${data.year}-${data.month}-${data.day}';
    final resposta = await _httpClientService.post(
      endpoint: '/agenda/evento',
      body: {
        'titulo': titulo,
        'descricao': descricao,
        'diaTodo': false,
        'recorrencia': 0,
        'horarioEventoInicio': '$dataInicio' '${hora.hour}:${hora.minute}',
        'horarioEventoFim': '$dataFim' '${horaFim.hour}:${horaFim.minute}',
      },
    );

    return resposta.fold(
      (l) => Left(l),
      (r) => Right(r.data['message']),
    );
  }

  @override
  Future<Either<String, String>> atualizarCompromisso({
    required String codigo,
    required String titulo,
    required bool diaTodo,
    required String descricao,
    required DateTime data,
  }) async {
    Map<String, dynamic> body = {
      'eventoID': codigo,
      'titulo': titulo,
      'descricao': descricao,
      'diaTodo': diaTodo,
      'recorrencia': 0,
      'horarioEventoInicio': data.toUtc().toIso8601String(),
      'horarioEventoFim':
          data.add(const Duration(hours: 1)).toUtc().toIso8601String()
    };

    final resposta = await _httpClientService.put(
      endpoint: '/agenda/evento',
      body: body,
    );

    return resposta.fold(
      (l) => Left(l),
      (r) => Right(r.data['message']),
    );
  }

  @override
  Future<Either<String, CompromissoModel>> getCompromissoPorCodigo(
      String compromissoCodigo) async {
    String endpoint = '/agenda/compromisso/$compromissoCodigo';

    final resposta = await _httpClientService.get(endpoint);

    return resposta.fold((l) {
      return Left(l);
    }, (r) {
      CompromissoModel objeto = CompromissoModel.fromMap(r.data);

      return Right(objeto);
    });
  }

  @override
  Future<Either<String, List<CompromissoModel>>>
      getCompromissosDaSemana() async {
    final resposta = await _httpClientService.get('/agenda/meuscompromissos');

    return resposta.fold(
      (l) => Left(l),
      (r) {
        var retorno = r.data.map<CompromissoModel>((e) {
          CompromissoModel objeto = CompromissoModel.fromMap(e);

          return objeto;
        }).toList();

        return Right(retorno);
      },
    );
  }
}
