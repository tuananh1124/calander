import 'package:flutter/material.dart';
import 'package:flutter_calendar/pages/add_task_page/tabcontent_addtask_page.dart';
import 'package:flutter_calendar/pages/content_persion_page/content_persion_page.dart';

class AddTaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
            size: 16,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Thêm lịch',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside of text fields
          FocusScope.of(context).unfocus();
        },
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
                    Tab(
                      text: 'Thông tin lịch',
                    ),
                    Tab(
                      text: 'Chủ trì cuộc họp',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(child: TabContentAddTask()),
                    SingleChildScrollView(child: TabContentPerson()),
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
