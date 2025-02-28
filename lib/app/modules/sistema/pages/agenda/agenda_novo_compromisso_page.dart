// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

import '../../../../../main.dart';
import '../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../designSystem/snackbar_component.dart';
import '../../../../shared/either.dart';
import '../../../../shared/stores/auth/auth_store.dart';
import 'agenda_store.dart';

class AgendaNovoCompromissoPage extends StatefulWidget {
  String data = '';
  String hora = '';
  AgendaNovoCompromissoPage({
    super.key,
    required this.data,
    required this.hora,
  });

  @override
  State<AgendaNovoCompromissoPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<AgendaNovoCompromissoPage> {
  late final AgendaStore agendaStore;
  late AuthStore _authStore;

  final TextEditingController _tituloAgendaController = TextEditingController();
  final TextEditingController _descricaoAgendaController =
      TextEditingController();

  final TextEditingController _dataController = TextEditingController();

  final TextEditingController _horaController = TextEditingController();

  TimeOfDay horaDoDia = TimeOfDay.now();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _authStore = Modular.get<AuthStore>();

    agendaStore = Modular.get<AgendaStore>();

    if (isTest) {
      _tituloAgendaController.text = 'Compromisso teste';
      _descricaoAgendaController.text = 'Descrição do compromisso teste';
      _dataController.text = widget.data;
      _horaController.text = widget.hora;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo compromisso'),
      ),
      drawer: drawerORleading(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: _tituloAgendaController,
                decoration: const InputDecoration(
                  labelText: 'Título do compromisso',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _dataController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Data',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Color.fromRGBO(238, 238, 238, 1),
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
                        _dataController.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      },
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _horaController,
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
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime == null) return;

                        horaDoDia = pickedTime;
                        _horaController.text =
                            '${pickedTime.hour}:${pickedTime.minute}';
                      },
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descricaoAgendaController,
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

                    final Either<String, String> resposta =
                        await agendaStore.salvarCompromisso(
                      titulo: _tituloAgendaController.text,
                      descricao: _descricaoAgendaController.text,
                      data: DateTime.parse(_dataController.text),
                      hora: horaDoDia,
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
                  label: const Text('Salvar na agenda'),
                  icon: const Icon(Icons.calendar_today_outlined),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
