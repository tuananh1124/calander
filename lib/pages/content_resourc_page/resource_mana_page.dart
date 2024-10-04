import 'package:flutter/material.dart';
import 'package:flutter_calendar/pages/content_location_page/content_location.dart';
import 'package:flutter_calendar/pages/content_resourc_page/content_resourc_page.dart';

class ResourceManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý tài nguyên'),
        backgroundColor: Colors.blue,
        foregroundColor:
            Colors.white, // Thay đổi màu chữ của các phần tử trong AppBar
      ),
      body: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                height: 50,
                color: Colors.blue, // Đặt màu nền cho TabBar
                child: const TabBar(
                  indicatorColor: Colors.white,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.white,
                  labelPadding: EdgeInsets.symmetric(vertical: 10),
                  unselectedLabelStyle: TextStyle(color: Colors.white),
                  dividerHeight: 0,
                  tabs: [
                    Tab(text: 'Địa điểm'),
                    Tab(text: 'Tài nguyên'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    TabContentLocation(),
                    TabContentResource(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
