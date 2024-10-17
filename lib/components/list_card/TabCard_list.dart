import 'package:flutter/material.dart';
import 'package:flutter_calendar/components/list_card/TabCard_item.dart';
import 'package:flutter_calendar/models/list_eventcalendar_model.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/network/api_service.dart';
import 'package:intl/intl.dart';

class TabcardList extends StatefulWidget {
  @override
  _TabcardListState createState() => _TabcardListState();
}

class _TabcardListState extends State<TabcardList>
    with AutomaticKeepAliveClientMixin {
  List<Map<String, dynamic>> _filteredDataListOfPersonal = [];
  bool _isLoading = true;
  final ApiProvider _apiProvider = ApiProvider();

  @override
  void initState() {
    super.initState();
    ListOfPersonalApi();
  }

  Future<void> ListOfPersonalApi() async {
    List<ListEventcalendarModel>? modelList =
        await _apiProvider.getListEveneCalendar(User.token.toString());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return _filteredDataListOfPersonal.isEmpty
        ? Center(child: Text("Không có dữ liệu cho buổi"))
        : ListView.builder(
            itemCount: _filteredDataListOfPersonal.length,
            itemBuilder: (context, index) {
              final item = _filteredDataListOfPersonal[index];
              final creator = item['creator']; // Lấy thông tin creator
              return TabcardItem(
                createdTime: item['createdTime'],
                content: item['content'],
                notes: item['notes'],
                color: item['color'],
                hosts: creator != null
                    ? creator['fullName'] ?? 'Không có tên' // Sử dụng fullName
                    : 'Không có tên',
                creator: creator != null
                    ? creator['fullName'] ?? 'Không có tên' // Sử dụng fullName
                    : 'Không có tên',
                attendeesRequired: item['attendeesRequired'],
                attendeesNoRequired: item['attendeesNoRequired'],
                resources: item['resources'],
                attachments: item['attachments'],
                //session: item['session'],
                // onDelete: () => _removeItem(index),
              );
            },
          );
  }

  @override
  bool get wantKeepAlive => true;
}
