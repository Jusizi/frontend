import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

import '../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../designSystem/snackbar_component.dart';
import '../../../../models/compromisso_model.dart';
import '../../../../shared/either.dart';
import 'agenda_store.dart';

class AgendaAtualizarCompromissoPage extends StatefulWidget {
  final String compromissoCodigo;
  const AgendaAtualizarCompromissoPage(
      {super.key, required this.compromissoCodigo});

  @override
  State<AgendaAtualizarCompromissoPage> createState() =>
      _AgendaAtualizarCompromissoPageState();
}

class _AgendaAtualizarCompromissoPageState
    extends State<AgendaAtualizarCompromissoPage> {
  // Widget body = const Center(
  //   child: CircularProgressIndicator.adaptive(),
  // );

  late final AgendaStore agendaStore;

  TimeOfDay horaDoDia = TimeOfDay.now();
  bool isLoading = false;
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _dataInicioController = TextEditingController();
  bool diaTodo = false;
  CompromissoModel? compromissoModel;

  @override
  void initState() {
    super.initState();

    agendaStore = Modular.get<AgendaStore>();

    agendaStore
        .getCompromissoPorCodigo(widget.compromissoCodigo)
        .then((Either<String, CompromissoModel> resposta) {
      resposta.fold((String erro) {
        setState(() {});
      }, (CompromissoModel compromisso) {
        setState(() {
          compromissoModel = compromisso;
          _tituloController.text = compromisso.titulo;
          _descricaoController.text = compromisso.descricao;
          _dataInicioController.text =
              DateFormat('yyyy-MM-dd').format(compromisso.dataInicio);

          diaTodo = compromisso.diaTodo;
          horaDoDia = TimeOfDay(
              hour: compromisso.dataInicio.hour,
              minute: compromisso.dataInicio.minute);
        });
      });
    });
  }

  String _formatTimeOfDay(TimeOfDay time) {
    // Formata como "HH:mm"
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  DateTime updateDateTimeWithTimeOfDay(DateTime dateTime, TimeOfDay timeOfDay) {
    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atualizar Compromisso'),
      ),
      drawer: drawerORleading(),
      body: Visibility(
        visible: compromissoModel != null,
        replacement: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título do compromisso',
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _dataInicioController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Data',
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
                            firstDate: DateTime.now(),
                            initialDate: DateTime.now(),
                            locale: const Locale('pt', 'BR'),
                          );

                          if (pickedDate == null) return;
                          _dataInicioController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        },
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(
                            text: _formatTimeOfDay(horaDoDia)),
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Hora',
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: horaDoDia,
                          );
                          if (pickedTime == null) return;
                          setState(() {
                            horaDoDia = pickedTime;
                          });
                          // _horaController.text =
                          //     '${pickedTime.hour}:${pickedTime.minute}';
                        },
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("Dia todo"),
                    const SizedBox(
                      width: 10,
                    ),
                    Switch.adaptive(
                      value: diaTodo,
                      onChanged: (bool valor) {
                        setState(() {
                          diaTodo = valor;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descricaoController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição do compromisso',
                  ),
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: isLoading,
                  child: const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
                Visibility(
                  visible: !isLoading,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });

                      final data = DateTime.parse(_dataInicioController.text);

                      final Either<String, String> resposta =
                          await agendaStore.atualizarCompromisso(
                        codigo: widget.compromissoCodigo,
                        titulo: _tituloController.text,
                        descricao: _descricaoController.text,
                        diaTodo: diaTodo,
                        data: updateDateTimeWithTimeOfDay(data, horaDoDia),
                      );
                      resposta.fold((l) {
                        SnackBarComponent().showError(l);
                      }, (r) {
                        SnackBarComponent().showSuccess(r);
                        Modular.to.pop();
                      });

                      setState(() {
                        isLoading = false;
                      });
                    },
                    label: const Text('Atualizar'),
                    icon: const Icon(Icons.calendar_today_outlined),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
