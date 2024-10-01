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

  // Thay đổi ở đây
  final Map<int, int> eventsCount = {
    2: 1, // Ngày 2 có 1 lịch
    4: 5, // Ngày 4 có 5 lịch
    1: 1, //
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

  // Hàm tạo header
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Nút để chuyển về tháng trước
        IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.grey[600]),
          onPressed: () {
            setState(() {
              _currentDate = DateTime(
                  _currentDate.year, _currentDate.month - 1, _currentDate.day);
            });
          },
        ),
        // Hiển thị tháng và năm hiện tại
        Text(
          DateFormat('MMMM', 'VI')
              .format(_currentDate), // Tháng và năm hiện tại
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // Nút để chuyển sang tháng tiếp theo
        IconButton(
          icon: Icon(Icons.chevron_right, color: Colors.grey[600]),
          onPressed: () {
            setState(() {
              _currentDate = DateTime(
                  _currentDate.year, _currentDate.month + 1, _currentDate.day);
            });
          },
        ),
      ],
    );
  }

  // Hàm tạo lưới lịch
  Widget _buildCalendarGrid() {
    DateTime firstDayOfMonth = DateTime(_currentDate.year, _currentDate.month,
        1); // Ngày đầu tiên của tháng hiện tại
    int daysInMonth = DateTime(_currentDate.year, _currentDate.month + 1,
            0) // Tính số ngày trong tháng
        .day;
    int weekdayOfFirstDay = firstDayOfMonth.weekday %
        7; // Thứ của ngày đầu tiên (CN = 0, T2 = 1,...)

    DateTime today = DateTime.now(); // Lấy ngày hiện tại

    // Tổng số ô lịch (bao gồm cả các ô trống trước ngày 1 của tháng)
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
            // Tính ngày cho từng ô trong lưới (chừa khoảng trống cho các ngày trước tháng)
            int day =
                index >= weekdayOfFirstDay ? index - weekdayOfFirstDay + 1 : 0;

            if (day <= 0 || day > daysInMonth) {
              return Container(); // Trả về ô trống nếu không phải là ngày hợp lệ
            }

            // Kiểm tra nếu ngày hiện tại là hôm nay
            bool isToday = _currentDate.year == today.year &&
                _currentDate.month == today.month &&
                day == today.day;

            bool isWeekend =
                (index % 7 == 0 || index % 7 == 6); // Thứ 7 và Chủ nhật
            bool hasCheckmark =
                [1, 2, 4, 6, 10, 12, 16, 18, 20, 22, 26, 30].contains(day);

            // Lấy số lượng lịch cho ngày này
            int eventCount =
                eventsCount[day] ?? 0; // Mặc định là 0 nếu không có lịch

            return _buildDayCell(
                day, isWeekend, isToday, hasCheckmark, eventCount);
          },
        ),
      ],
    );
  }

  // Hiển thị tên các ngày trong tuần
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

  // Tạo các ô cho mỗi ngày
  Widget _buildDayCell(int day, bool isWeekend, bool isToday, bool hasCheckmark,
      int eventCount) {
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
          // Hiển thị số lượng lịch
          if (eventCount > 0)
            Positioned(
              left: 2,
              bottom: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
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
