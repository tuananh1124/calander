import 'package:flutter/material.dart';
import 'package:flutter_calendar/pages/addtask_manager/addtask_tab/content_addtask_tab.dart';
import 'package:flutter_calendar/pages/addtask_manager/addtask_tab/content_persion_tab.dart';

class AddTaskPage extends StatefulWidget {
  final String calendarType;
  final Function(bool)? onEventCreated;
  const AddTaskPage({
    Key? key,
    required this.calendarType,
    this.onEventCreated,
  }) : super(key: key);
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  List<Map<String, String>> _selectedHosts = [];
  List<Map<String, String>> _selectedAttendees = [];
  List<Map<String, String>> _selectedRequiredAttendees = [];
  Map<String, String> _selectedLocation = {};
  List<Map<String, String>> _selectedResources = [];

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
                    SingleChildScrollView(
                      child: TabContentAddTask(
                        selectedHosts: _selectedHosts,
                        selectedAttendees: _selectedAttendees,
                        selectedRequiredAttendees: _selectedRequiredAttendees,
                        selectedLocation: _selectedLocation,
                        selectedResources: _selectedResources,
                        isOrganization: widget.calendarType == 'organization',
                        onEventCreated: () {
                          if (widget.onEventCreated != null) {
                            widget.onEventCreated!(true);
                          }
                        },
                      ),
                    ),
                    SingleChildScrollView(
                      child: TabContentPerson(
                        calendarType: widget.calendarType,
                        onHostsSelected: (hosts) {
                          setState(() {
                            _selectedHosts = hosts;
                          });
                        },
                        onAttendeesSelected: (attendees) {
                          setState(() {
                            _selectedAttendees = attendees;
                          });
                        },
                        onRequiredAttendeesSelected: (required) {
                          setState(() {
                            _selectedRequiredAttendees = required;
                          });
                        },
                        onLocationSelected: (location) {
                          setState(() {
                            _selectedLocation = location;
                          });
                        },
                        onResourcesSelected: (resources) {
                          setState(() {
                            _selectedResources = resources;
                          });
                        },
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
