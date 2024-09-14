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
import 'package:flutter_calendar/pages/home_page/bloc/date_bloc.dart';
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
  String _selectedDate = DateFormat('dd').format(DateTime.now());
  String _selectedDropdownDate =
      DateFormat('dd/MM/yyyy').format(DateTime.now());
  DateTime _currentDate = DateTime.now();
  bool _hasChangedWeek = false;
  late DateBloc _dateBloc;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _dateBloc = DateBloc();
    _dateBloc.add(LoadData(_currentDate));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _dateBloc.close(); // Đóng Bloc khi không còn sử dụng
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DateBloc>(
      create: (context) => _dateBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.format_list_bulleted,
                  color: Colors.white, size: 24),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: Text("Lịch công tác đơn vị",
              style: TextStyle(color: Colors.white)),
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
        // Gửi ngày mới đến Bloc
        context.read<DateBloc>().add(LoadData(picked));
      });
    }
  }

  void _changeWeek(int increment) {
    setState(() {
      _currentDate = _currentDate.add(Duration(days: increment * 7));
      _selectedDropdownDate = DateFormat('dd/MM/yyyy').format(_currentDate);
      _dateBloc.add(LoadData(_currentDate));
    });
  }

  void _goToCurrentWeek() {
    setState(() {
      _currentDate = DateTime.now();
      _selectedDropdownDate = DateFormat('dd/MM/yyyy').format(_currentDate);
      _dateBloc.add(LoadData(_currentDate));
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
      padding: EdgeInsets.fromLTRB(16, 3, 16, 2),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: BlocBuilder<DateBloc, DateBlocState>(
          builder: (context, state) {
            if (state.daysList.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: state.daysList.map((day) {
                final isToday = day['date'] ==
                    DateFormat('dd/MM/yyyy').format(DateTime.now());
                final isSelected = day['dayMonth'] == _selectedDate;
                return GestureDetector(
                  onTap: () => _selectDateBox(day['dayMonth']!),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.blue
                            : (isToday ? Colors.yellow : Colors.white),
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(day['dayOfWeek']!,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(day['dayMonth']!),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
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
