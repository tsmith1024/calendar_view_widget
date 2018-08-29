import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  Widget header(String month) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MaterialButton(
            child: Icon(Icons.chevron_left, color: Colors.blueGrey,),
            onPressed: () => {},
          ),
          Expanded(child: Container(),),
          Text('August', style: TextStyle(fontSize: 28.0, color: Colors.blueGrey)),
          Expanded(child: Container()),
          MaterialButton(
            child: Icon(Icons.chevron_right, color: Colors.blueGrey,),
            onPressed: () => {},
          )
        ],
      ),
    );
  }

  Widget dayMarker(String day) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          shape: BoxShape.circle,
        ),
        child: Center(child: Text(day, style: TextStyle(color: Colors.white),)),
      ),
    );
  }

  Widget weekRow(int startDay) {
    List<Widget> days = [];
    for (var i = startDay; i < startDay + 7; i++) {
      days.add(dayMarker(i.toString()));
    }

    return Row(
      children: days,
    );
  }

  Widget monthLayout() {
    const spacing = 16.0;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: spacing),
          child: weekRow(1),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: spacing),
          child: weekRow(8),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: spacing),
          child: weekRow(15),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: spacing),
          child: weekRow(22),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: spacing),
          child: weekRow(29),
        ),
      ],
    );
  }

  Widget eventRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Event Name'),
              Text('Location'),
              Text('Time of Event')
            ],
          ),
          Expanded(
            child: Container(),
          ),
          Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueAccent,
            ),
            child: Column(
              children: <Widget>[
                Text('AUGUST', style: TextStyle(color: Colors.white)),
                Text(
                  '4',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                  )
                ),
              ],
            )
          ),
        ],
      ),
    );
  }

  Widget separator() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            color: Colors.blueGrey,
            child: Text(
              'Upcoming Events',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            header('August'),
            Divider(height: 0.0, color: Colors.blueGrey,),
            monthLayout(),
            separator(),
            Expanded(
              child: ListView(
                children: <Widget>[
                  eventRow(),
                  Divider(color: Colors.grey, height: 0.0,),
                  eventRow(),
                  Divider(color: Colors.grey, height: 0.0,),
                  eventRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}