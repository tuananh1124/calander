import 'package:flutter/material.dart';
import 'package:flutter_calendar/pages/addtask_manager/addtask_tab/content_addtask_tab.dart';
import 'package:flutter_calendar/pages/addtask_manager/addtask_tab/content_persion_tab.dart';

class AddTaskPage extends StatefulWidget {
  final String calendarType;

  const AddTaskPage({
    Key? key,
    required this.calendarType,
  }) : super(key: key);
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.calendarType == 'organization'
            ? 'Thêm lịch đơn vị'
            : 'Thêm lịch cá nhân'),
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
                color: Colors.blue, // Set background color for TabBar
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
                    SingleChildScrollView(
                      child: TabContentPerson(
                        calendarType:
                            widget.calendarType, // Truyền calendarType
                      ),
                    ),
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
