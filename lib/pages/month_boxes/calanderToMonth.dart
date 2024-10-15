import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import thư viện để định dạng ngày tháng

class CalendarWidget extends StatefulWidget {
  final DateTime selectedDate;

  CalendarWidget({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _currentDate;

  // Dữ liệu số lượng lịch theo ngày
  final Map<int, int> eventsCount = {
    1: 1,
    2: 1,
    4: 5,
    6: 2,
    10: 1,
    12: 3,
    16: 1,
    18: 2,
    20: 1,
    22: 4,
    26: 1,
    30: 1,
    // Thêm các ngày khác và số lượng lịch tương ứng
  };

  @override
  void initState() {
    super.initState();
    _currentDate = widget.selectedDate;
  }

  @override
  void didUpdateWidget(CalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      setState(() {
        _currentDate = widget.selectedDate;
      });
    }
  }

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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          DateFormat('MMMM', 'vi').format(_currentDate), // Sửa 'VI' thành 'vi'
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    DateTime firstDayOfMonth =
        DateTime(_currentDate.year, _currentDate.month, 1);
    int daysInMonth =
        DateTime(_currentDate.year, _currentDate.month + 1, 0).day;
    int weekdayOfFirstDay = firstDayOfMonth.weekday % 7;

    DateTime today = DateTime.now();

    int totalDays = daysInMonth + weekdayOfFirstDay;

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
          itemCount: totalDays,
          itemBuilder: (context, index) {
            int day =
                index >= weekdayOfFirstDay ? index - weekdayOfFirstDay + 1 : 0;

            if (day <= 0 || day > daysInMonth) {
              return Container();
            }

            bool isToday = _currentDate.year == today.year &&
                _currentDate.month == today.month &&
                day == today.day;

            bool isWeekend = (index % 7 == 0 || index % 7 == 7); // Chủ nhật
            bool hasCheckmark =
                [1, 2, 4, 6, 10, 12, 16, 18, 20, 22, 26, 30].contains(day);

            // Lấy số lượng lịch cho ngày này, chỉ áp dụng cho các ngày không phải là Chủ nhật
            int eventCount = (index % 7 != 0) ? (eventsCount[day] ?? 0) : 0;

            return _buildDayCell(day, isWeekend, isToday,
                hasCheckmark && !isWeekend, eventCount);
          },
        ),
      ],
    );
  }

  Widget _buildWeekdayLabels() {
    List<String> weekdays = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays
          .map(
              (day) => Text(day, style: TextStyle(fontWeight: FontWeight.bold)))
          .toList(),
    );
  }

  Widget _buildDayCell(int day, bool isWeekend, bool isToday, bool hasCheckmark,
      int eventCount) {
    return Container(
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isWeekend
            ? Colors.red[100]
            : (isToday ? Colors.green : Colors.white),
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
          if (hasCheckmark) // Hiện dấu tích chỉ khi không phải Chủ nhật
            Positioned(
              right: 6,
              bottom: 2,
              child: Icon(Icons.check, color: Colors.red, size: 20),
            ),
          // Hiển thị số lượng lịch
          if (eventCount > 0)
            Positioned(
              left: 6,
              bottom: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  eventCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
