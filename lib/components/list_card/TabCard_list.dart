import 'package:flutter/material.dart';
import 'package:flutter_calendar/components/list_card/TabCard.dart';
import 'package:flutter_calendar/models/list_of_user_personal_model.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/network/api_service.dart';
import 'package:intl/intl.dart';

class TabContent extends StatefulWidget {
  @override
  _TabContentState createState() => _TabContentState();
}

class _TabContentState extends State<TabContent>
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
    List<ListofpersonalModel>? modelList =
        await _apiProvider.getListOfPersonal(User.token.toString());
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
              return ExpandableCard(
                updatedTime: item['updatedTime'],
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
