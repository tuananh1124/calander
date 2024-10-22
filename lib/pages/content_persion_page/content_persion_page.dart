import 'package:flutter/material.dart';
import 'package:flutter_calendar/components/location/location_item.dart';
import 'package:flutter_calendar/components/resource/resource_item.dart';
import 'package:flutter_calendar/components/list_user/user_item.dart';

class TabContentPerson extends StatefulWidget {
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
        FocusScope.of(context)
            .unfocus(); // Tắt bàn phím khi bấm vào khoảng trắng
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
              UserListCard(title: 'Người chủ trì'),
              Row(
                children: [
                  Text(
                    'Cán bộ tham dự:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: 10),
              UserListCard(title: 'Người tham dự'),
              SizedBox(height: 10),
              UserListCard(title: 'Người tham dự bắt buộc'),
              Row(
                children: [
                  Text(
                    'Địa điểm:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: 10),
              LocationItem(location: 'Địa điểm'),
              Row(
                children: [
                  Text(
                    'Tài nguyên:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ResourceItem(resource: 'Tài nguyên'),
            ],
          ),
        ),
      ),
    );
  }
}
