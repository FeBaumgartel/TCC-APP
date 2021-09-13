import 'package:flutter/material.dart';
import 'package:tcc_app/models/evento.dart';
import 'package:tcc_app/screens/agenda/cadastrar-editar/cadastrar-editar.dart';
import 'package:tcc_app/screens/agenda/widgets/agenda-mes/dia-atual.dart';
import 'package:tcc_app/screens/agenda/widgets/agenda-mes/dia-selecionado.dart';
import 'package:tcc_app/screens/agenda/widgets/agenda-mes/lista-eventos.dart';
import 'package:tcc_app/screens/agenda/widgets/agenda-mes/marcador-eventos.dart';
import 'package:tcc_app/services/dao/eventos.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tcc_app/theme.dart' as ThemeApp;

class AgendaMesProvider extends ChangeNotifier {
  BuildContext? context;
  AnimationController? _animationController; 
  CalendarController? _calendarController;
  final EventosService _eventosService = new EventosService();
  DateTime _dia = DateTime.now();
  String? _data;
  String? _mes;
  DateTime _selectedDay = DateTime.now();
  int? _verificador;
  List<int> _tiposFiltro = []; //variavel do filtro tipo
  List<int> _usersFiltro = []; //variavel do filtro users

  AgendaMesProvider(this.context, this._animationController) {
    initializeDateFormatting();
    _onVisibleDaysChanged(_dia, _dia, CalendarFormat.month);
    _animationController!.forward();
    _onVisibleDaysChanged(_dia, _dia, CalendarFormat.month);
    _selectedDay = DateTime.now();
    _verificador = 1;
    _tiposFiltro = [];
    _usersFiltro = [];
  }

  build() {
    return this
        ._eventosService
        .getEventsMonth(_mes!, _tiposFiltro, _usersFiltro);
  }

  goToToday() {
    _calendarController!.setSelectedDay(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      runCallback: true,
    );
    _selectedDay = DateTime.now();
    _mes = (DateTime.now().toString().split(' ')[0].split('-')[1]) +
        "/" +
        DateTime.now().year.toString();
    notifyListeners();
  }

  void _onDaySelected(DateTime day, List events) {
    _data = day.toString();
    final temp = _data!.split(" ");
    _data = temp[0];
    _selectedDay = day;
    notifyListeners();
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    if (_verificador == 1) {
      int m = (_calendarController!.focusedDay).month;
      if (m < 10) {
        _mes = "0" +
            ((_calendarController!.focusedDay).month).toString() +
            "/" +
            ((_calendarController!.focusedDay).year).toString();
      } else
        _mes = ((_calendarController!.focusedDay).month).toString() +
            "/" +
            ((_calendarController!.focusedDay).year).toString();
    } else
      _mes = (DateTime.now().toString().split(' ')[0].split('-')[1]) +
          "/" +
          DateTime.now().year.toString();
    _data = (_dia.toString()).split(" ")[0];
    notifyListeners();
    _animationController!.fling();
  }

  Widget buildTableCalendarWithBuilders(Map<DateTime, List<Evento>> _events) {
    return TableCalendar(
      locale: 'pt_BR',
      calendarController: _calendarController,
      events: _events,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.scale,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      rowHeight: 50,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        outsideWeekendStyle: TextStyle().copyWith(color: Colors.grey[400]),
        outsideStyle: TextStyle().copyWith(color: Colors.grey[400]),
        weekendStyle: TextStyle().copyWith(color: ThemeApp.Theme.primary),
        markersAlignment: Alignment(0, 0),
        highlightSelected: true,
        highlightToday: true,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: ThemeApp.Theme.primary),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return DiaSelecionado(_animationController!, date, _calendarController!);
        },
        todayDayBuilder: (context, date, _) {
          return DiaAtual(date);
        },
        markersBuilder: (context, date, events, holidays) {
          double? right;
          if (MediaQuery.of(context).size.width > 380 &&
              MediaQuery.of(context).size.width < 1000)
            right = 24;
          else if (MediaQuery.of(context).size.width >= 1000) right = 55;
          if (MediaQuery.of(context).size.width <= 380) right = 3;
          final children = <Widget>[];
          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: right,
                bottom: 2,
                child: MarcadorEventos(_calendarController!, date, _events[date]!),
              ),
            );
          }
          return children;
        },
      ),
      // onDaySelected: (date, _events) {
      //   _onDaySelected(date, _events);
      //   _animationController.forward(from: 0.1);
      // },
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget buildEventList(Map<DateTime, List<Evento>> eventos) {
    var temp = _selectedDay.toString().split(' ')[0];
    _selectedDay = DateTime.parse(temp);

    if (eventos[_selectedDay] != null) {
      return ListaEventos(eventos, _selectedDay);
    } else {
      return Container();
    }
  }

  events(List<Evento>? eventos) {
    Map<DateTime, List<Evento>> _events = Map<DateTime, List<Evento>>();
    for (Evento e in eventos!) {
      DateTime data = DateTime.parse(e.data!);
      if (!(_events.containsKey(data))) {
        _events[data] = [];
      }
      _events[data]!.add(e);
    }
    return _events;
  }

  cadastrarEvento() {
    Evento _evento = Evento();
    Navigator.push(
      context!,
      MaterialPageRoute(
          builder: (context) => CadastrarEditarEvento(eventoParam: _evento, atendimento: false,)),
    ).then((value) => notifyListeners());
  }
}
