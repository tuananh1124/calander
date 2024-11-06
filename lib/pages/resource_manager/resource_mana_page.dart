import 'package:flutter/material.dart';
import 'package:flutter_calendar/pages/resource_manager/tab_resource/content_location_tab.dart';
import 'package:flutter_calendar/pages/resource_manager/tab_resource/content_resourc_tab.dart';

class ResourceManagementPage extends StatefulWidget {
  final String calendarType; // Thêm tham số này

  const ResourceManagementPage({
    Key? key,
    required this.calendarType,
  }) : super(key: key);
  @override
  _ResourceManagementPageState createState() => _ResourceManagementPageState();
}

class _ResourceManagementPageState extends State<ResourceManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.calendarType == 'organization'
            ? 'Quản lý danh mục đơn vị'
            : 'Quản lý danh mục cá nhân'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                height: 50,
                color: Colors.blue,
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
                    TabContentLocation(calendarType: widget.calendarType),
                    TabContentResource(calendarType: widget.calendarType),
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
