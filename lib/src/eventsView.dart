import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsView extends StatelessWidget {
  const EventsView(
      {Key key,
      this.events,
      this.month,
      this.currentDay,
      this.onEventTapped,
      this.titleField,
      this.detailField,
      this.dateField,
      this.theme})
      : super(key: key);

  final Map<int, List> events;
  final int month;
  final int currentDay;
  final Function onEventTapped;
  final String titleField;
  final String detailField;
  final String dateField;
  final ThemeData theme;

  Widget dateBadge(day) => ConstrainedBox(
        constraints: new BoxConstraints(minWidth: 75.0),
        child: new Container(
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.accentColor,
          ),
          child: Column(
            children: <Widget>[
              Text(
                day.toString(),
                textAlign: TextAlign.center,
                style: theme.accentTextTheme.title,
              ),
            ],
          ),
        ),
      );

  String timeString(event) {
    final date = DateTime.parse(event[dateField]).toLocal().add(DateTime.now().timeZoneOffset);
    return DateFormat.jm().format(date);
  }

  Widget eventRow(int day, Map<String, String> event) => InkWell(
        onTap: () => onEventTapped(event),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      event[titleField] ?? "",
                      style: theme.textTheme.headline,
                    ),
                    Text(
                      event[detailField] ?? "",
                      style: theme.textTheme.subhead,
                    ),
                    Text(
                      timeString(event),
                      style: theme.textTheme.subhead,
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(),
              ),
              dateBadge(day),
            ],
          ),
        ),
      );

  List<Widget> eventList() {
    List<Widget> list = [];
    events.forEach((int day, List dayEvents) {
      if (currentDay == 0 || currentDay == day) {
        for (var i = 0; i < dayEvents.length; i++) {
          list.add(eventRow(day, dayEvents[i]));
          list.add(Divider(
            color: theme.dividerColor,
            height: 0.0,
          ));
        }
      }
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: theme.canvasColor,
        child: ListView(
          children: eventList(),
        ),
      ),
    );
  }
}
