import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar/components/TabCard_list.dart';
import 'package:flutter_calendar/pages/month_boxes/bloc/month_bloc.dart';
import 'package:flutter_calendar/pages/month_boxes/calanderToMonth.dart';
import 'package:flutter_calendar/pages/add_task_page.dart';
import 'package:flutter_calendar/pages/home_page/bloc/date_bloc.dart';
import 'package:flutter_calendar/pages/menu_drawer.dart';
import 'package:flutter_calendar/pages/resource_mana_page.dart';
import 'package:flutter_calendar/components/search_bar.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedDayOfWeek =
      DateFormat('EEEE').format(DateTime.now()); // Lưu trữ thứ trong tuần
  String _selectedMonth =
      DateFormat('MMMM').format(DateTime.now()); // Lưu trữ tên tháng hiện tại

  DateTime _currentDate = DateTime.now();
  bool _hasChangedWeek = false;
  late DateBloc _dateBloc;
  String _selectedFilter = 'Theo tuần'; // Giá trị mặc định

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _dateBloc = DateBloc();
    _dateBloc.add(LoadData(_currentDate));
    context.read<MonthBloc>().add(LoadDataToMonth(DateTime.now()));
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
        appBar: _buildAppBar(),
        drawer: CustomDrawer(),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blue,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.format_list_bulleted, color: Colors.white, size: 24),
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
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildDateDropdown(),
        Row(
          children: [
            Expanded(child: SearchBarWithDropdown()),
            Expanded(child: buildDropdownButtonFormField()),
          ],
        ),
        _buildAddTaskButtons(),
        if (_selectedFilter == 'Theo tháng')
          _buildMonthBoxes() // Show month boxes when "Theo tháng" is selected
        else
          _buildDateBoxes(), // Show date boxes when "Theo tuần" is selected
        if (_selectedFilter == 'Theo tháng')
          Expanded(
              child:
                  _buildMonthCalendar()) // Show month calendar when "Theo tháng" is selected
        else ...[
          _buildTabBar(), // Show tab bar when "Theo tuần" is selected
          Expanded(child: _buildTabBarView()),
        ],
      ],
    );
  }

  Widget buildDropdownButtonFormField() {
    return DropdownButtonFormField<String>(
      value: _selectedFilter,
      decoration: buildInputDecoration(),
      items: ['Theo tuần', 'Theo tháng']
          .map((filter) => DropdownMenuItem(value: filter, child: Text(filter)))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedFilter = value ?? 'Theo tuần';
        });
      },
    );
  }

  InputDecoration buildInputDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.black),
      ),
    );
  }

  Widget _buildMonthCalendar() {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CalendarWidget(), // Hiển thị lịch tháng
          ],
        ),
      ),
    );
  }

  Widget _buildDateDrop() {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton<String>(
            value: _selectedFilter,
            onChanged: (String? newValue) {
              setState(() {
                _selectedFilter = newValue!;
              });
            },
            items: <String>['Theo tuần', 'Theo tháng']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
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
            onPressed: () => _changeWeek(-1),
          ),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Text(
              DateFormat('dd/MM/yyyy').format(_currentDate),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: () => _changeWeek(1),
          ),
          if (_hasChangedWeek)
            TextButton(
              onPressed: _goToCurrentWeek,
              child:
                  Text('Tuần hiện tại', style: TextStyle(color: Colors.black)),
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
        _updateSelectedMonthAndDayOfWeek(picked);
        context.read<DateBloc>().add(LoadData(picked));
      });
    }
  }

  void _changeWeek(int increment) {
    setState(() {
      _currentDate = _currentDate.add(Duration(days: increment * 7));
      _updateSelectedMonthAndDayOfWeek(_currentDate);
      _dateBloc.add(LoadData(_currentDate));
      _hasChangedWeek = true;
    });
  }

  void _goToCurrentWeek() {
    setState(() {
      _currentDate = DateTime.now();
      _updateSelectedMonthAndDayOfWeek(_currentDate);
      _dateBloc.add(LoadData(_currentDate));
      _hasChangedWeek = false;
    });
  }

  void _updateSelectedMonthAndDayOfWeek(DateTime date) {
    _selectedDayOfWeek = DateFormat('EEEE').format(date);
    _selectedMonth = DateFormat('MMMM').format(date);
  }

  Widget _buildAddTaskButtons() {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () => _navigateToAddTaskPage(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Colors.white),
                Text("Add task", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () => _navigateToResourceManagementPage(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.manage_accounts, color: Colors.white),
                Text("Quản lí tài nguyên",
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateBoxes() {
    return Padding(
      padding: const EdgeInsets.all(8.0), // Padding 8
      child: BlocBuilder<DateBloc, DateBlocState>(
        builder: (context, state) {
          if (state.daysList.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          final screenWidth = MediaQuery.of(context).size.width;
          final itemWidth = (screenWidth - 32) / state.daysList.length;
          return GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! < 0) {
                _changeWeek(1);
              } else if (details.primaryVelocity! > 0) {
                _changeWeek(-1);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: state.daysList.map((day) {
                final isToday = day['date'] ==
                    DateFormat('dd/MM/yyyy').format(DateTime.now());
                final isSelected = day['dayOfWeek'] == _selectedDayOfWeek;
                return GestureDetector(
                  onTap: () => _selectDateBox(day['dayOfWeek']!),
                  child: Container(
                    width: itemWidth, // Thiết lập chiều rộng của mỗi item
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
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonthBoxes() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<MonthBloc, MonthBlocState>(
        builder: (context, state) {
          if (state.monthsList.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          // Xác định tháng hiện tại
          final currentMonthIndex = state.monthsList
              .indexWhere((month) => month['monthOfYear'] == _selectedMonth);
          final startIndex = currentMonthIndex > 2
              ? currentMonthIndex - 2
              : 0; // Giới hạn không cho chỉ số âm
          final endIndex = currentMonthIndex + 3 < state.monthsList.length
              ? currentMonthIndex + 3
              : state.monthsList
                  .length; // Giới hạn không vượt quá chiều dài danh sách

          final visibleMonths = state.monthsList.sublist(startIndex, endIndex);
          final currentMonth = DateFormat('MMMM').format(DateTime.now());

          final screenWidth = MediaQuery.of(context).size.width;
          final itemWidth = (screenWidth - 32) / visibleMonths.length;

          return GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.velocity.pixelsPerSecond.dx > 0) {
                // Vuốt sang trái
                if (currentMonthIndex > 0) {
                  setState(() {
                    _selectedMonth =
                        state.monthsList[currentMonthIndex - 1]['monthOfYear']!;
                  });
                }
              } else if (details.velocity.pixelsPerSecond.dx < 0) {
                // Vuốt sang phải
                if (currentMonthIndex < state.monthsList.length - 1) {
                  setState(() {
                    _selectedMonth =
                        state.monthsList[currentMonthIndex + 1]['monthOfYear']!;
                  });
                }
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: visibleMonths.map((month) {
                final isSelected = month['monthOfYear'] == _selectedMonth;
                final isCurrentMonth = month['monthOfYear'] == currentMonth;
                return GestureDetector(
                  onTap: () => _selectMonthBox(month['monthOfYear']!),
                  child: Container(
                    width: itemWidth,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: isCurrentMonth
                          ? [BoxShadow(color: Colors.yellow, blurRadius: 10)]
                          : [], // Thêm hiệu ứng bóng cho tháng hiện tại
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          month['monthOfYear']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isSelected
                                ? 20
                                : 16, // Tăng kích thước chữ khi được chọn
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
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

  void _navigateToAddTaskPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskPage()),
    );
  }

  void _navigateToResourceManagementPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResourceManagementPage()),
    );
  }

  void _selectDateBox(String dayOfWeek) {
    setState(() {
      _selectedDayOfWeek = dayOfWeek;
    });
  }

  void _selectMonthBox(String monthOfYear) {
    setState(() {
      _selectedMonth = monthOfYear;
    });
  }
}
