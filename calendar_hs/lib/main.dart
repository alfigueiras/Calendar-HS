import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

CalendarFormat _calendarFormat = CalendarFormat.month;

class DateEvents {
  String title;
  String details;
  DateTime startHour;
  DateTime endHour;

  DateEvents(this.title, this.details, this.startHour, this.endHour);

  DateTime get getStartHour {
    return startHour;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HS Calendar',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'HS - Calendar'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late final ValueNotifier<List<DateEvents>> _selectedEvents;
  Map<DateTime, List<DateEvents>> _eventsMap = {};
  var _counter = 0;
  bool? _tasks = true;
  bool? _events = true;
  bool? _reminders = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<DateEvents> _getEventsForDay(DateTime day) {
    return _eventsMap[day] ?? [];
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: 'Info',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Info"),
                    content: const Text(
                        "Calendário desenvolvido para o projeto de AppDev"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("OK"))
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(1900, 1, 1),
        lastDay: DateTime.utc(2200, 12, 31),
        calendarStyle: CalendarStyle(
          canMarkersOverflow: true,
          todayDecoration: BoxDecoration(
              color: Colors.green.shade300, shape: BoxShape.circle),
          selectedDecoration: BoxDecoration(
              color: Colors.green.shade800, shape: BoxShape.circle),
          todayTextStyle: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white),
        ),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: ((
          selectedDay,
          focusedDay,
        ) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          _selectedEvents.value = _getEventsForDay(selectedDay);
        }),
        headerStyle:
            const HeaderStyle(titleCentered: true, formatButtonVisible: false),
        calendarFormat: _calendarFormat,
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                color: Colors.green,
                padding: EdgeInsets.only(
                    top: 16 + MediaQuery.of(context).padding.top, bottom: 16),
                child: const Center(
                  child: Text(
                    "HS - Calendar",
                    style: TextStyle(fontSize: 26, color: Colors.white),
                  ),
                )),
            Container(
                padding: const EdgeInsets.all(5),
                child: Wrap(runSpacing: 16, children: [
                  ListTile(
                    leading: const Icon(Icons.calendar_view_day_outlined),
                    title: const Text("Day"),
                    onTap: () {
                      setState(() {
                        _calendarFormat = CalendarFormat.twoWeeks;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_view_week_outlined),
                    title: const Text("Week"),
                    onTap: () {
                      setState(() {
                        _calendarFormat = CalendarFormat.week;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_view_month_outlined),
                    title: const Text("Month"),
                    onTap: () {
                      setState(() {
                        _calendarFormat = CalendarFormat.month;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(
                    color: Colors.black54,
                    thickness: 1.0,
                  ),
                  CheckboxListTile(
                    title: const Text("Events"),
                    value: _events,
                    activeColor: Colors.red[300],
                    onChanged: (bool? value) {
                      setState(() {
                        _events = value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Tasks"),
                    value: _tasks,
                    activeColor: Colors.blue[300],
                    onChanged: (bool? value) {
                      setState(() {
                        _tasks = value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Reminders"),
                    value: _reminders,
                    activeColor: Colors.orange[200],
                    onChanged: (bool? value) {
                      setState(() {
                        _reminders = value;
                      });
                    },
                  )
                ])),
          ],
        )),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
