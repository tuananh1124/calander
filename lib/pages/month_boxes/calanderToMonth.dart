import 'package:flutter/material.dart';

class CalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 16),
            _buildCalendarGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.chevron_left, color: Colors.grey[600]),
        Text(
          'September 2024',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Icon(Icons.chevron_right, color: Colors.grey[600]),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    return Column(
      children: [
        _buildWeekdayLabels(),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
          ),
          itemCount: 30,
          itemBuilder: (context, index) {
            int day = index + 1;
            bool isWeekend = day % 7 == 1 || day % 7 == 0;
            bool isToday = day == 23;
            bool hasCheckmark =
                [2, 4, 6, 10, 12, 16, 18, 20, 22, 26, 30].contains(day);
            bool hasX = [
              1,
              3,
              5,
              7,
              9,
              11,
              13,
              15,
              17,
              19,
              21,
              24,
              25,
              27,
              28,
              29
            ].contains(day);

            return _buildDayCell(day, isWeekend, isToday, hasCheckmark, hasX);
          },
        ),
      ],
    );
  }

  Widget _buildWeekdayLabels() {
    List<String> weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays
          .map(
              (day) => Text(day, style: TextStyle(fontWeight: FontWeight.bold)))
          .toList(),
    );
  }

  Widget _buildDayCell(
      int day, bool isWeekend, bool isToday, bool hasCheckmark, bool hasX) {
    return Container(
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isWeekend
            ? Colors.red[100]
            : (isToday ? Colors.blue : Colors.white),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            day.toString(),
            style: TextStyle(
              color: isToday ? Colors.white : Colors.black,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (hasCheckmark)
            Positioned(
              right: 2,
              bottom: 2,
              child: Icon(Icons.check, color: Colors.green, size: 12),
            ),
          if (hasX)
            Positioned(
              right: 2,
              bottom: 2,
              child: Icon(Icons.close, color: Colors.red, size: 12),
            ),
        ],
      ),
    );
  }
}
