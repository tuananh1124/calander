import 'package:flutter/material.dart';

class CalendarItem extends StatefulWidget {
  const CalendarItem({super.key});

  @override
  State<CalendarItem> createState() => _CalendarItemState();
}

class _CalendarItemState extends State<CalendarItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.white,
        child: ListTile(
          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        ),
      ),
    );
  }
}
