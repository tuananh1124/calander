import 'package:flutter/material.dart';
import 'package:flutter_calendar/models/list_event_calendar_model.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/network/api_service.dart';
import 'package:intl/intl.dart'; // Import thư viện để định dạng ngày tháng

class CalendarWidget extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime)? onDaySelected; // Thêm callback

  CalendarWidget({
    Key? key,
    required this.selectedDate,
    this.onDaySelected,
  }) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _currentDate;
  final ApiProvider _apiProvider = ApiProvider();
  Map<int, int> eventsCount = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.selectedDate;
    _fetchEvents();
  }

  @override
  void didUpdateWidget(CalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      setState(() {
        _currentDate = widget.selectedDate;
        _fetchEvents();
      });
    }
  }

  Future<void> _fetchEvents() async {
    setState(() => _isLoading = true);
    try {
      List<ListEventcalendarModel>? events =
          await _apiProvider.getListEveneCalendar(User.token.toString());

      if (events != null) {
        Map<int, int> newEventsCount = {};

        for (var event in events) {
          if (event.from != null) {
            DateTime eventDate =
                DateTime.fromMillisecondsSinceEpoch(event.from!);

            // Chỉ đếm các sự kiện trong tháng hiện tại
            if (eventDate.year == _currentDate.year &&
                eventDate.month == _currentDate.month) {
              int day = eventDate.day;
              newEventsCount[day] = (newEventsCount[day] ?? 0) + 1;
            }
          }
        }

        if (mounted) {
          setState(() {
            eventsCount = newEventsCount;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching events: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

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

            bool isWeekend = (index % 7 == 0); // Chỉ Chủ nhật
            bool hasEvents = eventsCount.containsKey(day);
            int eventCount = eventsCount[day] ?? 0;

            return _buildDayCell(
                day, isWeekend, isToday, hasEvents && !isWeekend, eventCount);
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
    return GestureDetector(
      onTap: () {
        if (hasCheckmark) {
          final selectedDate =
              DateTime(_currentDate.year, _currentDate.month, day);
          widget.onDaySelected?.call(selectedDate);
        }
      },
      child: Container(
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
      ),
    );
  }
}
