import 'package:flutter/material.dart';
import 'package:flutter_calendar/components/list_card/TabCard.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/network/api_service.dart';
import 'package:intl/intl.dart';

class TabContent extends StatefulWidget {
  final String session;
  final DateTime selectedDate;
  final Function(int, int) updateCounts;

  const TabContent({
    required this.session,
    required this.selectedDate,
    required this.updateCounts,
    Key? key,
  }) : super(key: key);

  @override
  _TabContentState createState() => _TabContentState();
}

class _TabContentState extends State<TabContent>
    with AutomaticKeepAliveClientMixin {
  late List<Map<String, dynamic>> _data = [];
  bool _isLoading = true;
  int morningCount = 0;
  int afternoonCount = 0;
  final ApiProvider _apiProvider = ApiProvider();

  @override
  void initState() {
    super.initState();
    _fetchAndFilterData(widget.selectedDate);
    getListOfPersonal();
  }

  Future<List<Map<String, dynamic>>> getListOfPersonal() async {
    await _apiProvider.getListOfPersonal(User.token.toString());
    return [];
  }

  @override
  void didUpdateWidget(TabContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _fetchAndFilterData(widget.selectedDate);
    }
  }

  void _removeItem(int index) {
    final session = _data[index]['session'];
    setState(() {
      _data.removeAt(index);

      // Cập nhật lại số lượng sáng/chiều
      if (session == 'sáng') {
        morningCount--;
      } else if (session == 'chiều') {
        afternoonCount--;
      }

      // Gọi phương thức updateCounts để cập nhật số lượng trên HomePage
      widget.updateCounts(morningCount, afternoonCount);
    });
  }

  Future<List<Map<String, dynamic>>> _fetchDatabaseData() async {
    // This is a mock database. In a real app, you'd fetch this data from your actual database.
    return [
      {
        "NameCreate": "Nguyễn Văn A",
        "date": "04/10/2024",
        "time": "8:00 - 9:00",
        "content": "Họp để thảo luận về dự án mới.",
        "note": "Thảo luận về dự án mới.",
        "file": "Không có file đính kèm",
        "Preside": "Trưởng phòng",
        "member": "Nhân viên kỹ thuật",
        "location": "456 Nguyễn Thị Minh Khai, Quận 3",
        "resources": "Trà",
        "error": 1,
        "session": "sáng"
      },
      {
        "NameCreate": "Nguyễn Văn A",
        "date": "04/10/2024",
        "time": "9:30 - 11:00",
        "content": "Họp để thảo luận về dự án mới.",
        "note": "Thảo luận về dự án mới.",
        "file": "Không có file đính kèm",
        "Preside": "Trưởng phòng",
        "member": "Nhân viên kỹ thuật, Nhân viên IT",
        "location": "456 Nguyễn Thị Minh Khai, Quận 3",
        "resources": "Trà",
        "error": 1,
        "session": "sáng"
      },
      {
        "NameCreate": "Nguyễn Văn B",
        "date": "05/10/2024",
        "time": "9:00 - 11:00",
        "content": "Họp để thảo luận về dự án mới.",
        "note": "Thảo luận về dự án mới.",
        "file": "Có file đính kèm",
        "Preside": "Trưởng phòng",
        "member": "Nhân viên kỹ thuật",
        "location": "456 Nguyễn Thị Minh Khai, Quận 3",
        "resources": "Trà",
        "error": 2,
        "session": "sáng"
      },
      {
        "NameCreate": "Nguyễn Văn B",
        "date": "03/10/2024",
        "time": "15:00 - 16:00",
        "content": "Họp để thảo luận về dự án mới.",
        "note": "Thảo luận về dự án mới.",
        "file": "Có file đính kèm",
        "Preside": "Trưởng phòng",
        "member": "Nhân viên kỹ thuật",
        "location": "456 Nguyễn Thị Minh Khai, Quận 3",
        "resources": "Trà",
        "error": 0,
        "session": "chiều"
      },
      // ... other data items ...
    ];
  }

  void _fetchAndFilterData(DateTime selectedDate) {
    setState(() {
      _isLoading = true;
    });
    _fetchDatabaseData().then((data) {
      setState(() {
        // Count events for each session
        morningCount = data
            .where((item) =>
                item['session'] == 'sáng' &&
                item['date'] == DateFormat('dd/MM/yyyy').format(selectedDate))
            .length;

        afternoonCount = data
            .where((item) =>
                item['session'] == 'chiều' &&
                item['date'] == DateFormat('dd/MM/yyyy').format(selectedDate))
            .length;

        // Update counts in HomePage
        widget.updateCounts(morningCount, afternoonCount);

        // Filter data for the current session
        _data = data
            .where((item) =>
                item['session'] == widget.session &&
                item['date'] == DateFormat('dd/MM/yyyy').format(selectedDate))
            .toList();
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return _data.isEmpty
        ? Center(child: Text("Không có dữ liệu cho buổi ${widget.session}"))
        : ListView.builder(
            itemCount: _data.length,
            itemBuilder: (context, index) {
              final item = _data[index];
              return ExpandableCard(
                nameCreate: item['NameCreate'],
                date: item['date'],
                time: item['time'],
                content: item['content'],
                note: item['note'],
                file: item['file'],
                preside: item['Preside'],
                member: item['member'],
                location: item['location'],
                resources: item['resources'],
                error: item['error'],
                session: item['session'],
                onDelete: () => _removeItem(index),
              );
            },
          );
  }

  @override
  bool get wantKeepAlive => true;
}
