import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'add_sch_page.dart';

import 'dart:math';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key, required this.likedroomsList});
  final List likedroomsList;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final List<Color> _colorCollection = <Color>[];
  MeetingDataSource? events;
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    _initializeEventColor();
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
    super.initState();
  }

  final CalendarController _controller = CalendarController();
  DateTime _selectedDate = DateTime.now();

  void selectionChanged(CalendarSelectionDetails details) {
    _selectedDate = details.date!;
  }

  void calendarTapped(CalendarTapDetails details) {
    if ((details.targetElement == CalendarElement.appointment ||
            details.targetElement == CalendarElement.agenda) &&
        details.appointments!.isNotEmpty) {
      dialogBuilder(context, details.appointments?[0].id)
          .then((value) => getDataFromFireStore());
    }
  }

  Future<void> dialogBuilder(BuildContext context, id) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('삭제/수정'),
          content: const Text('삭제/수정'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('삭제'),
              onPressed: () {
                try {
                  db
                      .collection('CalendarAppointmentCollection')
                      .doc(id)
                      .delete();
                } catch (e) {}

                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('수정'),
              onPressed: () {
                // try {
                //   db
                //       .collection('CalendarAppointmentCollection')
                //       .doc('1')
                //       .update({'Subject': 'Meeting'});
                // } catch (e) {}
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScheduleMaker(
                      selectedDate: _selectedDate,
                      likedroomsList: widget.likedroomsList,
                    ),
                  ),
                ).then((value) {
                  setState(() {
                    getDataFromFireStore();
                  });
                });
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: SfCalendar(
          view: CalendarView.month,
          initialDisplayDate: DateTime.now(),
          dataSource: events,
          monthViewSettings: MonthViewSettings(
            appointmentDisplayCount: 1,
            agendaViewHeight: MediaQuery.of(context).size.height * 0.45,
            showAgenda: true,
          ),
          onSelectionChanged: selectionChanged,
          initialSelectedDate: DateTime.now(),
          controller: _controller,
          onTap: calendarTapped,
        ));
  }

  void _initializeEventColor() {
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorCollection.add(const Color(0xFF0A8043));
  }

  Future<void> getDataFromFireStore() async {
    var snapShotsValue =
        await db.collection("CalendarAppointmentCollection").get();

    final Random random = Random();
    List<Meeting> list = snapShotsValue.docs
        .map(
          (e) => Meeting(
              eventName: e.data()['Theme'],
              from: DateFormat('dd/MM/yyyy HH:mm:ss')
                  .parse(e.data()['StartTime']),
              to: DateFormat('dd/MM/yyyy HH:mm:ss').parse(e.data()['EndTime']),
              background: _colorCollection[random.nextInt(9)],
              isAllDay: false,
              id: e.data()['Id']),
        )
        .toList();
    setState(() {
      events = MeetingDataSource(list);
    });
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }
}

class Meeting {
  String? eventName;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? isAllDay;
  String? id;

  Meeting(
      {this.eventName,
      this.from,
      this.to,
      this.background,
      this.isAllDay,
      this.id});
}
