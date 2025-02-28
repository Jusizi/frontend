// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../designSystem/layout/drawermenuComponent.dart';
import '../../../../models/compromisso_model.dart';
import '../../../../shared/stores/auth/auth_store.dart';
import 'agenda_store.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<AgendaPage> {
  late final AgendaStore agendaStore;
  late AuthStore _authStore;

  @override
  void initState() {
    super.initState();

    _authStore = Modular.get<AuthStore>();

    agendaStore = Modular.get<AgendaStore>();
  }

  Widget _buildError(Exception state) {
    return Center(
      child: Text(state.toString()),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator.adaptive());
  }

  Widget _buildSuccess(state) {
    return SfCalendar(
      showDatePickerButton: true,
      controller: agendaStore.calendarController,
      view: CalendarView.month,
      allowedViews: const [
        CalendarView.day,
        CalendarView.week,
        CalendarView.workWeek,
        CalendarView.month,
        /*
              CalendarView.timelineDay,
              CalendarView.timelineWeek,
              CalendarView.timelineWorkWeek,
              CalendarView.timelineMonth,
        */
      ],
      appointmentTimeTextFormat: 'HH:mm',
      timeZone: 'E. South America Standard Time',
      dataSource: MeetingDataSource(_getDataSource()),
      onTap: (CalendarTapDetails calendarDetalhes) {
        if (calendarDetalhes.appointments != null &&
            calendarDetalhes.appointments!.isNotEmpty) {
          Modular.to.pushNamed(
              '/sistema/agenda/compromisso/${calendarDetalhes.appointments![0].id}');
        } else {
          if (calendarDetalhes.date is DateTime &&
              calendarDetalhes.targetElement != CalendarElement.header) {
            final DateTime selectedDate = calendarDetalhes.date as DateTime;

            String mes = (selectedDate.month < 10
                    ? '0${selectedDate.month}'
                    : selectedDate.month)
                .toString();
            String dia = (selectedDate.day < 10
                    ? '0${selectedDate.day}'
                    : selectedDate.day)
                .toString();

            String data = '${selectedDate.year}-$mes-$dia';
            String hora = selectedDate.hour < 10
                ? '0${selectedDate.hour}'
                : selectedDate.hour.toString();

            String minuto = selectedDate.minute < 10
                ? '0${selectedDate.minute}'
                : selectedDate.minute.toString();

            String parametros = '/$data/$hora:$minuto';
            Modular.to.pushNamed('/sistema/agenda/novocompromisso$parametros');
          }
        }
      },
      monthViewSettings: const MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
      ),
    );
  }

  List<Appointment> _getDataSource() {
    final List<Appointment> meetings = <Appointment>[];
    for (CompromissoModel compromisso in agendaStore.state) {
      meetings.add(
        Appointment(
          id: compromisso.codigo,
          subject: compromisso.titulo,
          startTime: compromisso.dataInicio,
          endTime: compromisso.dataFim,
          color: compromisso.cor,
          isAllDay: compromisso.diaTodo,
        ),
      );
    }

    return meetings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus compromissos'),
        actions: [
          IconButton(
            onPressed: () {
              agendaStore.getCompromissosDaSemana();
            },
            icon: const Icon(Icons.refresh_outlined),
          ),
        ],
      ),
      drawer: DrawerMenuComponent(),
      body: RefreshIndicator(
        onRefresh: agendaStore.getCompromissosDaSemana,
        child: ScopedBuilder<AgendaStore, List<CompromissoModel>>(
          store: agendaStore,
          onError: (context, erro) => _buildError(erro!),
          onLoading: (context) => _buildLoading(),
          onState: (context, state) => _buildSuccess(state),
        ),
      ),
    );
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    Meeting? meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData!;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
