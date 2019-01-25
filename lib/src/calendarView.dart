import 'dart:async';

import 'package:flutter/material.dart';

import 'constants.dart';
import 'eventsView.dart';
import 'monthView.dart';

class CalendarView extends StatefulWidget {
  CalendarView({
    Key key,
    this.onEventTapped,
    this.titleField = 'name',
    this.detailField = 'location',
    this.dateField = 'date',
    this.separatorTitle = 'Events',
    this.theme,
    this.eventStream,
  }) : super(key: key);

  /// Stream that accepts a list of events for display in the calendar.
  /// Events should have a title, detail, date, and unique id field
  /// Date field should be anything that DateTime.parse() can handle.
  /// Any updates passed through the stream will replace existing events.
  final Stream<List<Map<String, String>>> eventStream;

  ///Handler to use in your app should a user tap on an event in the event list.
  ///Passes the event (Map<String, String>) as a parameter.
  final Function onEventTapped;

  ///Field on each event to use as the title for display in the event list.
  final String titleField;

  ///Field on each event to use as the detail information (line 2) for display in the event list.
  final String detailField;

  ///Field to use as the date field for organizing events by month.
  ///Also used to display time information in the event list.
  final String dateField;

  ///Title used in the separator between the month and list views.
  final String separatorTitle;

  ///Theme used to style the calendar as needed.
  final ThemeData theme;

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<CalendarView> {
  int _currentMonth;
  int _currentYear;
  int _currentDay;
  Map<int, Map<int, Map<int, List>>> _events;
  ThemeData _theme;

  @override
  initState() {
    super.initState();
    widget.eventStream.listen(_setEvents);
    _currentMonth = DateTime.now().month;
    _currentYear = DateTime.now().year;
    _currentDay = 0;
    _theme = widget.theme ?? ThemeData.light();
  }

  /// Processes events and sets state for events in calendar
  /// Used by initState to initialize widget
  /// and to update widget when needed
  void _setEvents(List<Map<String, String>> events) {
    List<Map<String, String>> filteredEvents = List.from(events);
    filteredEvents
        .removeWhere((Map<String, String> event) => !_validEvent(event));

    // sort events based on date field
    final sortedEvents = List.from(filteredEvents);
    sortedEvents
        .sort((a, b) => a[widget.dateField].compareTo(b[widget.dateField]));

    Map<int, Map<int, Map<int, List>>> structuredEvents = {};
    for (var event in sortedEvents) {
      var date = DateTime.parse(event[widget.dateField]).toUtc();
      // guard null date
      if (date == null) {
        continue;
      }

      Map year = structuredEvents[date.year];
      // guard null year
      if (year == null) {
        structuredEvents[date.year] = {
          date.month: {
            date.day: [event]
          }
        };
        continue;
      }

      Map month = year[date.month];
      // guard null month
      if (month == null) {
        structuredEvents[date.year][date.month] = {
          date.day: [event]
        };
        continue;
      }

      List day = month[date.day];
      // guard null day
      if (day == null) {
        structuredEvents[date.year][date.month][date.day] = [event];
        continue;
      }

      day.add(event);
      structuredEvents[date.year][date.month][date.day] = day;
    }
    setState(() => _events = structuredEvents);
  }

  bool _validEvent(Map<String, String> event) =>
      event[widget.dateField] != null && event[widget.dateField].isNotEmpty;

  String _getMonth(int month) => (MonthNames[month - 1]);

  void _nextMonth() {
    var nextMonth = _currentMonth + 1;
    if (nextMonth > DateTime.monthsPerYear) {
      nextMonth = nextMonth % DateTime.monthsPerYear;
      setState(() => _currentYear += 1);
    }
    setState(() {
      _currentMonth = nextMonth;
      _currentDay = 0;
    });
  }

  void _prevMonth() {
    var prevMonth = _currentMonth - 1;
    if (prevMonth <= 0) {
      prevMonth = prevMonth + DateTime.monthsPerYear;
      setState(() => _currentYear -= 1);
    }
    setState(() {
      _currentMonth = prevMonth;
      _currentDay = 0;
    });
  }

  Map<int, List> _monthlyEvents() {
    if (_events != null && _events[_currentYear] != null) {
      final yearEvents = _events[_currentYear];
      if (yearEvents[_currentMonth] != null) {
        return yearEvents[_currentMonth];
      }
    }
    return {};
  }

  Widget _header() {
    return Container(
      color: _theme.canvasColor,
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MaterialButton(
            child: Icon(
              Icons.chevron_left,
              color: _theme.accentColor,
            ),
            onPressed: () => _prevMonth(),
          ),
          Expanded(
            child: Container(),
          ),
          Column(
            children: <Widget>[
              Text(
                _getMonth(_currentMonth),
                style: _theme.textTheme.display1,
              ),
              Text(
                _currentYear.toString(),
                style: _theme.textTheme.subhead
                    .copyWith(fontWeight: FontWeight.bold),
              )
            ],
          ),
          Expanded(child: Container()),
          MaterialButton(
            child: Icon(
              Icons.chevron_right,
              color: _theme.accentColor,
            ),
            onPressed: () => _nextMonth(),
          )
        ],
      ),
    );
  }

  Widget _separator() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            color: _theme.backgroundColor,
            child: Text(
              widget.separatorTitle,
              style: _theme.accentTextTheme.display1,
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }

  _daySelectHandler(int day) {
    if (_currentDay == day) {
      day = 0;
    }
    setState(() => _currentDay = day);
  }

  _onEventTapped(Map<String, String> event) {
    widget.onEventTapped(event);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _header(),
            Divider(
              height: 0.0,
              color: _theme.dividerColor,
            ),
            MonthView(
              _currentYear,
              _currentMonth,
              _monthlyEvents(),
              onTapHandler: _daySelectHandler,
              theme: _theme,
            ),
            _separator(),
            EventsView(
              events: _monthlyEvents(),
              month: _currentMonth,
              currentDay: _currentDay,
              onEventTapped: _onEventTapped,
              titleField: widget.titleField,
              detailField: widget.detailField,
              dateField: widget.dateField,
              theme: _theme,
            ),
          ],
        ),
      ),
    );
  }
}
