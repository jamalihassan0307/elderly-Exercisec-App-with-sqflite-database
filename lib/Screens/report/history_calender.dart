import 'dart:collection';
import 'package:ex_app/Core/calender/table_calendar.dart';
import 'package:ex_app/Core/color.dart';
import 'package:ex_app/Core/size/size_config.dart';
import 'package:ex_app/Core/space.dart';
import 'package:ex_app/data/database/app_db.dart';
import 'package:ex_app/data/model/report.dart';
import 'package:ex_app/widgets/dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/model/event.dart';

class HistoryCalender extends StatefulWidget {
  const HistoryCalender({Key? key}) : super(key: key);

  @override
  _HistoryCalenderState createState() => _HistoryCalenderState();
}

var _kEventSource2 = <DateTime, List<Event>>{};

class _HistoryCalenderState extends State<HistoryCalender> {
  final ValueNotifier<List<Event>> _selectedEvents = ValueNotifier([]);

  // Using a `LinkedHashSet` is recommended due to equality comparison override
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  final CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
//is used no data from weeks
  bool isDataHas = true;
  List<Reports> history = [];
  List<Event> events = [];
  List<Event> weekEvents = [];
  @override
  void initState() {
    showData();
    super.initState();
  }

  Future showData() async {
    history = await ExerciseDatabase.instance.showReports();

    if (history.isNotEmpty) {
      for (int i = 0; history.length > i; i++) {
        var date = history[i].time;
        events = await ExerciseDatabase.instance
            .showEvents('${date.year}${date.month}${date.day}');
        setState(() {
          _kEventSource2[DateTime.utc(date.year, date.month, date.day)] = [
            for (int k = 0; events.length > k; k++)
              Event(
                id: events[k].id,
                eventKey: events[k].eventKey,
                title: events[k].title,
                duration: events[k].duration,
                kcal: events[k].kcal,
                dateTime: events[k].dateTime,
              )
          ];
        });
      }
    }
  }

  Future getWeekData(strat, end) async {
    weekEvents = await ExerciseDatabase.instance.showBetweenEvents(strat, end);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _kEventSource2[day] ?? [];
    // return kEvents[day] ?? [];
  }

  List<Event> _getEventsForDays(Set<DateTime> days) {
    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;

      _selectedDays.clear();
      _selectedEvents.value = [];
      _selectedDays.add(selectedDay);
    });

    _selectedEvents.value = _getEventsForDays(_selectedDays);
  }

  String monthSet(int index) {
    String setMount = '';
    switch (index) {
      case 1:
        setMount = 'Jan';
        break;
      case 2:
        setMount = 'Feb';
        break;
      case 3:
        setMount = 'Mar';
        break;
      case 4:
        setMount = 'Apr';
        break;
      case 5:
        setMount = 'May';
        break;
      case 6:
        setMount = 'Jun';
        break;
      case 7:
        setMount = 'Jul';
        break;
      case 8:
        setMount = 'Aug';
        break;
      case 9:
        setMount = 'Sep';
        break;
      case 10:
        setMount = 'Oct';
        break;
      case 11:
        setMount = 'Nov';
        break;

      default:
        setMount = 'Dec';
        break;
    }
    return setMount;
  }

  @override
  Widget build(BuildContext context) {
    var day = _focusedDay.subtract(const Duration(days: 6));

    return Column(
      children: [
        TableCalendar<Event>(
          firstDay: kFirstDay,
          lastDay: kLastDay,
          focusedDay: _focusedDay,
          eventLoader: _getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.sunday,
          selectedDayPredicate: (day) {
            // Use values from Set to mark multiple days as selected
            return _selectedDays.contains(day);
          },
          onDaySelected: _onDaySelected,
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        h10,
        Expanded(
          child: ValueListenableBuilder<List<Event>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              if (value.isEmpty) {
                getWeekData('${day.year}${day.month}${day.day}',
                    '${_focusedDay.year}${_focusedDay.month}${_focusedDay.day}');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '       ${monthSet(day.month)} ${day.day.toString()}',
                          style: TextStyle(
                            color: black.withOpacity(0.4),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        w10,
                        Text(
                          '-',
                          style: TextStyle(
                            color: black.withOpacity(0.4),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        w10,
                        Text(
                          "${monthSet(_focusedDay.month)} ${_focusedDay.day.toString()}",
                          style: TextStyle(
                            color: black.withOpacity(0.4),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    weekEvents.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                                itemCount: weekEvents.length,
                                itemBuilder: (itemBuilder, index) {
                                  var date = DateFormat.yMMMd('en_US')
                                      .add_jm()
                                      .format(weekEvents[index].dateTime);
                                  return eventListTile(
                                      weekEvents[index], date, index);
                                }),
                          )
                        : Center(
                            child: Text(
                              "No Data",
                              style: TextStyle(
                                color: black.withOpacity(0.4),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "       ${monthSet(value[0].dateTime.month)} ${value[0].dateTime.day}",
                      style: TextStyle(
                        color: black.withOpacity(0.4),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          var date = DateFormat.yMMMd('en_US')
                              .add_jm()
                              .format(value[index].dateTime);

                          return eventListTile(value[index], date, index);
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget eventListTile(Event event, String date, int index) {
    var time = int.parse(event.duration);
    String newtime = '';
    if (time >= 60) {
      var cal = time / 60;
      newtime = '${cal.toStringAsFixed(0)} min';
    } else {
      newtime = "$time sec";
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1 * SizeConfig.height!),
      padding: EdgeInsets.symmetric(vertical: 1 * SizeConfig.height!),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: blueShadow.withOpacity(0.3),
            offset: const Offset(0, 0),
            blurRadius: 20,
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 2.3 * SizeConfig.height!,
          backgroundColor: blue,
          child: Image.asset(
            'assets/icons/done.png',
            height: 2.5 * SizeConfig.height!,
            color: white,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: TextStyle(
                color: black.withOpacity(0.4),
                fontSize: 1.7 * SizeConfig.text!,
                fontWeight: FontWeight.bold,
              ),
            ),
            h5,
            Text(
              event.title,
              style: TextStyle(
                color: black.withOpacity(0.7),
                fontSize: 2 * SizeConfig.text!,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        subtitle: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(
              'assets/icons/gas.png',
              height: 2 * SizeConfig.height!,
              color: orange,
            ),
            w5,
            Text(newtime),
            w20,
            Image.asset(
              'assets/icons/time.png',
              height: 2.5 * SizeConfig.height!,
              color: blue,
            ),
            w5,
            Text('${event.kcal} Kcal'),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (builder) {
                  return AppDialog(
                    title: 'Delete',
                    subTitle: 'Are you sure you want to delete it?',
                    onContinue: () {
                      setState(() => events.removeAt(index));
                      ExerciseDatabase.instance.deleteEvents(event.id!);

                      showData();

                      Navigator.pop(context);
                    },
                  );
                });
          },
          icon: const Icon(Icons.more_vert_outlined),
        ),
      ),
    );
  }
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year - 5, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year + 5, kToday.month, kToday.day);

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
