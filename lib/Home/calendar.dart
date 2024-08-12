import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';


class Calendar_Home extends StatelessWidget {
  const Calendar_Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const[
        Locale('th'),
      ],
      locale: const Locale('th'),
      home: CalendarPage(),
    );
  }
}
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPage();
}

class _CalendarPage extends State<CalendarPage> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final kFirstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 12, DateTime.now().day);
  final kLastDay = DateTime(
      DateTime.now().year, DateTime.now().month + 12, DateTime.now().day);

  String year = '${DateTime.now().year + 543}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: TableCalendar(
        locale: 'th_Th',
        firstDay: kFirstDay,
        lastDay: kLastDay,
        focusedDay: _focusedDay,

        //เปลี่ยนเป็น พ.ศ.
         headerStyle: HeaderStyle(
            titleTextStyle: TextStyle(fontSize: 18),
            titleCentered: true,
            titleTextFormatter: (date, locale) =>
                '${DateFormat.MMMMEEEEd(locale).format(date)} $year'),
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {

          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {

            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;


              
            });
          }
        },
        //ปุ่มเปลี่ยน week/month
        // onFormatChanged: (format) {
        //   if (_calendarFormat != format) {
        //     // Call `setState()` when updating calendar format
        //     setState(() {
        //       _calendarFormat = format;
        //     });
        //   }
        // },
        onPageChanged: (focusedDay) {
          // No need to call `setState()` here
          _focusedDay = focusedDay;
          year = '${(focusedDay.year + 543)}';
        },

      ),
    );
  }
}