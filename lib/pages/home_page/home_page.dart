import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar/components/TabCard_list.dart';
import 'package:flutter_calendar/components/animation_page.dart';
import 'package:flutter_calendar/components/dateBox_item.dart';
import 'package:flutter_calendar/pages/add_task_page.dart';
import 'package:flutter_calendar/pages/add_task_page/add_task_page.dart';
import 'package:flutter_calendar/pages/content_location_page/content_location.dart';
import 'package:flutter_calendar/pages/content_persion_page/content_persion_page.dart';
import 'package:flutter_calendar/pages/content_resourc_page/content_resourc_page.dart';
import 'package:flutter_calendar/pages/home_page/bloc/bloc.dart';
import 'package:flutter_calendar/pages/menu_drawer.dart';
import 'package:flutter_calendar/pages/resource_mana_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedDate = "19";
  String _selectedDropdownDate =
      DateFormat('dd/MM/yyyy').format(DateTime.now());
  DateTime _currentDate = DateTime.now();
  DateTime _currentWeek = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day -
          DateTime.now().weekday +
          1); // Ngày đầu tuần hiện tại
  bool _hasChangedWeek = false; // Biến trạng thái theo dõi việc chuyển tuần

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Builder(
          builder: (context) => IconButton(
            icon:
                Icon(Icons.format_list_bulleted, color: Colors.white, size: 24),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title:
            Text("Lịch công tác đơn vị", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white, size: 24),
            onPressed: () {
              // Handle notification button press
            },
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Row(
            children: [
              _buildDateDropdown(),
            ],
          ),
          _buildAddTaskButtons(),
          _buildDateBoxes(),
          _buildTabBar(),
          Expanded(child: _buildTabBarView()),
        ],
      ),
    );
  }

  Widget _buildDateDropdown() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: () {
              _changeWeek(-1); // Chuyển tuần trước
              setState(() {
                _hasChangedWeek = true; // Đánh dấu đã thay đổi tuần
              });
            },
          ),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Text(
              _selectedDropdownDate,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: () {
              _changeWeek(1); // Chuyển tuần sau
              setState(() {
                _hasChangedWeek = true; // Đánh dấu đã thay đổi tuần
              });
            },
          ),
          Row(
            children: [
              // Nút 'Tuần hiện tại' sẽ xuất hiện sau nút điều hướng tuần
              if (_hasChangedWeek)
                TextButton(
                  onPressed: () {
                    _goToCurrentWeek(); // Quay lại tuần hiện tại
                    setState(() {
                      _hasChangedWeek =
                          false; // Đặt lại giá trị của _hasChangedWeek
                    });
                  },
                  child: Text('Tuần hiện tại',
                      style: TextStyle(color: Colors.black)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _currentDate = picked;
        _selectedDropdownDate = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _changeWeek(int increment) {
    setState(() {
      _currentDate = _currentDate.add(Duration(days: increment * 7));
      _selectedDropdownDate = DateFormat('dd/MM/yyyy').format(_currentDate);
    });
  }

  void _goToCurrentWeek() {
    setState(() {
      _currentDate = _currentWeek;
      _selectedDropdownDate = DateFormat('dd/MM/yyyy').format(_currentDate);
    });
  }

  Widget _buildAddTaskButtons() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 3, 16, 2),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () => _showAddTaskModal(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Colors.white),
                SizedBox(width: 3),
                Text(
                  "Add task",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () => _showResourceManagementModal(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.manage_accounts, color: Colors.white),
                SizedBox(width: 3),
                Text(
                  "Quản lí tài nguyên",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateBoxes() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 12),
            DateBox(
              day: "Thứ 2",
              date: "19",
              isSelected: _selectedDate == "19",
              onTap: () => _selectDateBox("19"),
            ),
            SizedBox(width: 5),
            DateBox(
              day: "Thứ 3",
              date: "20",
              isSelected: _selectedDate == "20",
              onTap: () => _selectDateBox("20"),
            ),
            SizedBox(width: 5),
            DateBox(
              day: "Thứ 4",
              date: "21",
              isSelected: _selectedDate == "21",
              onTap: () => _selectDateBox("21"),
            ),
            SizedBox(width: 5),
            DateBox(
              day: "Thứ 5",
              date: "22",
              isSelected: _selectedDate == "22",
              onTap: () => _selectDateBox("22"),
            ),
            SizedBox(width: 5),
            DateBox(
              day: "Thứ 6",
              date: "23",
              isSelected: _selectedDate == "23",
              onTap: () => _selectDateBox("23"),
            ),
            SizedBox(width: 5),
            DateBox(
              day: "Thứ 7",
              date: "24",
              isSelected: _selectedDate == "24",
              onTap: () => _selectDateBox("24"),
            ),
            SizedBox(width: 5),
            DateBox(
              day: "Chủ nhật",
              date: "25",
              isSelected: _selectedDate == "25",
              onTap: () => _selectDateBox("25"),
            ),
            // ... Add more DateBox widgets for other days
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      indicatorColor: Colors.blue,
      labelColor: Colors.blue,
      unselectedLabelColor: Colors.grey,
      tabs: [
        Tab(text: 'Sáng'),
        Tab(text: 'Chiều'),
      ],
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        Center(child: TabContent()),
        Center(child: TabContent()),
      ],
    );
  }

  void _selectDateBox(String date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _showAddTaskModal(BuildContext context) {
    _navigateToAddTaskPage(context);
  }

  void _navigateToAddTaskPage(BuildContext context) {
    Navigator.of(context).push(SlideFromRightPageRoute(
      page: AddTaskPage(),
    ));
  }

  void _navigateToResourceManagementPage(BuildContext context) {
    Navigator.of(context).push(SlideFromRightPageRoute(
      page: ResourceManagementPage(),
    ));
  }

  void _showResourceManagementModal(BuildContext context) {
    _navigateToResourceManagementPage(context);
  }
}
