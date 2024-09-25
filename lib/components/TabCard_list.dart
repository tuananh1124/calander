import 'package:flutter/material.dart';
import 'package:flutter_calendar/components/TabCard.dart';

class TabContent extends StatefulWidget {
  @override
  _TabContentState createState() => _TabContentState();
}

class _TabContentState extends State<TabContent>
    with AutomaticKeepAliveClientMixin {
  late List<Map<String, dynamic>> _data;
  bool _isLoading =
      true; // Biến này dùng để kiểm tra xem dữ liệu đã được tải chưa

  @override
  void initState() {
    super.initState();
    _fetchDatabaseData().then((data) {
      setState(() {
        _data = data;
        _isLoading = false; // Đánh dấu việc hoàn thành tải dữ liệu
      });
    });
  }

  void _removeItem(int index) {
    setState(() {
      _data.removeAt(index);
    });
  }

  Future<List<Map<String, dynamic>>> _fetchDatabaseData() async {
    // Giả lập dữ liệu mẫu
    return [
      {
        "NameCreate": "Nguyễn Văn A",
        "date": "07/09/2024",
        "time": "14:00 - 17:00",
        "content": "Họp để thảo luận về dự án mới. ",
        "note": "Thảo luận về dự án mới.",
        "file": "Không có file đính kèm",
        "Preside": "Trưởng phòng",
        "member":
            "Nhân viên kỹ thuật, nhân viên test, nhân viên kỹ thuật số, nhân viên trực.",
        "location":
            "456 Nguyễn Thị Minh Khai, Quận 3, 456 Nguyễn Thị Minh Khai, Quận 3",
        "resources": "Trà",
        "error": 1,
      },
      {
        "NameCreate": "Nguyễn Văn B",
        "date": "07/09/2024",
        "time": "14:00 - 17:00",
        "content": "Họp để thảo luận về dự án mới.",
        "note": "Thảo luận về dự án mới.",
        "file": "Có file đính kèm",
        "Preside": "Trưởng phòng",
        "member": "Nhân viên kỹ thuật",
        "location": "456 Nguyễn Thị Minh Khai, Quận 3",
        "resources": "Trà",
        "error": 2,
      },
      {
        "NameCreate": "Nguyễn Văn C",
        "date": "07/09/2024",
        "time": "14:00 - 17:00",
        "content": "Họp để thảo luận về dự án mới.",
        "note": "Thảo luận về dự án mới.",
        "file": "Có file đính kèm",
        "Preside": "Trưởng phòng",
        "member": "Nhân viên kỹ thuật",
        "location": "456 Nguyễn Thị Minh Khai, Quận 3",
        "resources": "Trà",
        "error": 0,
      },
      {
        "NameCreate": "Nguyễn Văn A",
        "date": "07/09/2024",
        "time": "14:00 - 17:00",
        "content": "Họp để thảo luận về dự án mới. ",
        "note": "Thảo luận về dự án mới.",
        "file": "Có file đính kèm",
        "Preside": "Trưởng phòng",
        "member":
            "Nhân viên kỹ thuật, nhân viên test, nhân viên kỹ thuật số, nhân viên trực.",
        "location":
            "456 Nguyễn Thị Minh Khai, Quận 3, 456 Nguyễn Thị Minh Khai, Quận 3",
        "resources": "Trà",
        "error": 1,
      },
      // Thêm dữ liệu khác ở đây
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensure keep-alive functionality
    if (_isLoading) {
      return Center(
          child:
              CircularProgressIndicator()); // Hiển thị loading trong khi đợi dữ liệu
    }

    return _data == null
        ? Center(child: CircularProgressIndicator())
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
                onDelete: () => _removeItem(index),
              );
            },
          );
  }

  @override
  bool get wantKeepAlive => true;
}
