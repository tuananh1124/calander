import 'package:flutter/material.dart';
import 'package:flutter_calendar/components/list_card/TabCard_list.dart';
import 'package:flutter_calendar/pages/addtask_manager/addtask_tab/content_addtask_tab.dart';

class CalendarManagementScreen extends StatefulWidget {
  @override
  _CalendarManagementScreenState createState() =>
      _CalendarManagementScreenState();
}

class _CalendarManagementScreenState extends State<CalendarManagementScreen> {
  final _tabcardListKey = GlobalKey<TabcardListState>();
  DateTime selectedDate = DateTime.now(); // hoặc date bạn muốn
  bool isMorning = true; // hoặc false tùy thuộc vào requirement
  String calendarType = 'organization'; // hoặc 'personal'

  void _handleEventCreated() {
    // Refresh TabcardList khi tạo lịch thành công
    _tabcardListKey.currentState?.fetchListEveneCalendar();
  }

  void _handleEventCountChanged(int count) {
    // Xử lý khi số lượng event thay đổi
    print('Event count: $count');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabContentAddTask(
          selectedHosts: [], // Thêm các props cần thiết
          selectedAttendees: [],
          selectedRequiredAttendees: [],
          selectedLocation: {},
          selectedResources: [],
          isOrganization: true,
          onEventCreated: _handleEventCreated,
        ),
        Expanded(
          child: TabcardList(
            key: _tabcardListKey,
            isMorning: isMorning,
            onEventCountChanged: _handleEventCountChanged,
            selectedDate: selectedDate,
            calendarType: calendarType,
          ),
        ),
      ],
    );
  }
}
