import 'package:flutter/material.dart';
import 'package:flutter_calendar/components/list_user/user_list.dart';
import 'package:flutter_calendar/components/location/location_item.dart';
import 'package:flutter_calendar/components/resource/resource_item.dart';
import 'package:flutter_calendar/components/list_user/user_item.dart';

class TabContentPerson extends StatefulWidget {
  final String calendarType;
  final Function(List<Map<String, String>>)? onHostsSelected;
  final Function(List<Map<String, String>>)? onAttendeesSelected;
  final Function(List<Map<String, String>>)? onRequiredAttendeesSelected;
  final Function(Map<String, String>)? onLocationSelected;
  final Function(List<Map<String, String>>)? onResourcesSelected;

  const TabContentPerson({
    Key? key,
    required this.calendarType,
    this.onHostsSelected,
    this.onAttendeesSelected,
    this.onRequiredAttendeesSelected,
    this.onLocationSelected,
    this.onResourcesSelected,
  }) : super(key: key);

  @override
  _TabContentPersonState createState() => _TabContentPersonState();
}

class _TabContentPersonState extends State<TabContentPerson>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Cán bộ chủ trì:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: 10),
              UserItem(
                title: 'Người chủ trì',
                onSelectedUsers: (users) {
                  print(
                      'Selected hosts in TabContentPerson: $users'); // Debug log
                  if (widget.onHostsSelected != null) {
                    final formattedUsers = users
                        .map((user) => {
                              'id': user['userId'] ??
                                  user['id'] ??
                                  '', // Sử dụng userId hoặc id
                              'userId': user['userId'] ??
                                  user['id'] ??
                                  '', // Thêm trường userId
                              'fullName': user['fullName'] ?? '',
                              'jobTitle': user['jobTitle'] ?? '',
                              'organizationId': user['organizationId'] ??
                                  '605b064ad9b8222a8db47eb8',
                              'organizationName': user['organizationName'] ??
                                  'VĂN PHÒNG TRUNG ƯƠNG ĐẢNG',
                            })
                        .toList();
                    widget.onHostsSelected!(formattedUsers);
                  }
                },
              ),
              Row(
                children: [
                  Text(
                    'Cán bộ tham dự:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: 10),
              UserItem(
                title: 'Người tham dự',
                onSelectedUsers: (users) {
                  // Xử lý attendees
                  if (widget.onAttendeesSelected != null) {
                    widget.onAttendeesSelected!(users);
                  }
                },
              ),
              SizedBox(height: 10),
              UserItem(
                title: 'Người tham dự bắt buộc',
                onSelectedUsers: (users) {
                  // Xử lý required attendees
                  if (widget.onRequiredAttendeesSelected != null) {
                    widget.onRequiredAttendeesSelected!(users);
                  }
                },
              ),
              Row(
                children: [
                  Text(
                    'Địa điểm:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: 10),
              LocationItem(
                location: 'Địa điểm',
                calendarType: widget.calendarType,
                onLocationSelected: (location) {
                  if (widget.onLocationSelected != null) {
                    widget.onLocationSelected!(location);
                  }
                },
              ),
              Row(
                children: [
                  Text(
                    'Tài nguyên:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ResourceItem(
                resource: 'Tài nguyên',
                calendarType: widget.calendarType,
                onResourcesSelected: (resources) {
                  if (widget.onResourcesSelected != null) {
                    widget.onResourcesSelected!(resources);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
