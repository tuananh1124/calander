import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar/components/list_card/TabCard_list.dart';
import 'package:flutter_calendar/pages/month_boxes/bloc/month_bloc.dart';
import 'package:flutter_calendar/pages/month_boxes/calanderToMonth.dart';
import 'package:flutter_calendar/pages/add_task_page/add_task_page.dart';
import 'package:flutter_calendar/pages/home_page/bloc/date_bloc.dart';
import 'package:flutter_calendar/pages/menu_drawer/menu_drawer.dart';
import 'package:flutter_calendar/pages/content_resourc_page/resource_mana_page.dart';
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
  bool _hasChangedMonth = false;
  late DateBloc _dateBloc;
  late MonthBloc _monthBloc;
  String _selectedFilter = 'Theo tuần';
  int morningCount = 0;
  int afternoonCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _dateBloc = DateBloc();
    _monthBloc = MonthBloc();
    _dateBloc.add(LoadData(_currentDate));
    _monthBloc.add(LoadDataToMonth(_currentDate));
    _fetchEventCounts();
    //context.read<MonthBloc>().add(LoadDataToMonth(DateTime.now()));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _dateBloc.close(); // Đóng Bloc khi không còn sử dụng
    _monthBloc.close();
    super.dispose();
  }

  Future<void> _fetchEventCounts() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DateBloc>(
          create: (context) => _dateBloc,
        ),
        BlocProvider<MonthBloc>(
          create: (context) => _monthBloc,
        ),
      ],
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
    return Container(
      margin: EdgeInsets.only(right: 8), // Thêm margin bên phải
      child: DropdownButtonFormField<String>(
        value: _selectedFilter,
        items: ['Theo tuần', 'Theo tháng']
            .map((filter) =>
                DropdownMenuItem(value: filter, child: Text(filter)))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedFilter = value ?? 'Theo tuần';
            if (_selectedFilter == 'Theo tuần') {
              _dateBloc.add(LoadData(_currentDate));
            } else {
              _monthBloc.add(LoadDataToMonth(_currentDate));
            }
          });
        },
        decoration: InputDecoration(
          fillColor: Colors.white, // Màu nền của ô dropdown
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey), // Màu viền
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
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
            BlocBuilder<MonthBloc, MonthBlocState>(
              builder: (context, state) {
                return CalendarWidget(selectedDate: state.selectedDate);
              },
            ),
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

  void _updateSelectedDate(DateTime newDate) {
    setState(() {
      _currentDate = newDate;
      _updateSelectedMonthAndDayOfWeek(newDate);
      _dateBloc.add(LoadData(newDate));
      _monthBloc.add(LoadDataToMonth(newDate));
      _fetchEventCounts();
    });
  }

  bool _isCurrentWeekVisible = false; // Biến trạng thái cho tuần hiện tại
  bool _isCurrentMonthVisible = false; // Biến trạng thái cho tháng hiện tại

  Widget _buildDateDropdown() {
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: () {
              if (_selectedFilter == 'Theo tuần') {
                _changeWeek(-1);
              } else {
                _changeMonth(-1);
                context.read<MonthBloc>().add(ChangeMonth(-1));
              }
            },
          ),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Text(
              _selectedFilter == 'Theo tuần'
                  ? DateFormat('dd/MM/yyyy').format(_currentDate)
                  : 'Tháng ${DateFormat('MM/yyyy', 'vi_VN').format(_currentDate)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: () {
              if (_selectedFilter == 'Theo tuần') {
                _changeWeek(1);
              } else {
                _changeMonth(1);
                context.read<MonthBloc>().add(ChangeMonth(1));
              }
            },
          ),
          if (_hasChangedWeek || _hasChangedMonth)
            TextButton(
              onPressed: () {
                if (_selectedFilter == 'Theo tuần') {
                  _goToCurrentWeek();
                } else {
                  _goToCurrentMonth();
                }
                context.read<MonthBloc>().add(LoadDataToMonth(_currentDate));
              },
              child: Text(
                _selectedFilter == 'Theo tuần'
                    ? 'Tuần hiện tại'
                    : 'Tháng hiện tại',
                style: TextStyle(color: Colors.black),
              ),
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
        context.read<MonthBloc>().add(LoadDataToMonth(picked));
      });
    }
  }

  void _changeWeek(int increment) {
    setState(() {
      _currentDate = _currentDate.add(Duration(days: increment * 7));
      _updateSelectedMonthAndDayOfWeek(_currentDate);
      _dateBloc.add(LoadData(_currentDate));
      _hasChangedWeek = true;
      _fetchEventCounts();
    });
  }

  void _goToCurrentWeek() {
    setState(() {
      _currentDate = DateTime.now();
      _updateSelectedMonthAndDayOfWeek(_currentDate);
      _dateBloc.add(LoadData(_currentDate));
      _hasChangedWeek = false;
      _fetchEventCounts();
    });
  }

  void _changeMonth(int increment) {
    setState(() {
      int newMonth = _currentDate.month + increment;
      int newYear = _currentDate.year;
      if (newMonth > 12) {
        newMonth = 1;
        newYear++;
      } else if (newMonth < 1) {
        newMonth = 12;
        newYear--;
      }
      _currentDate = DateTime(newYear, newMonth, 1);
      _selectedMonth = DateFormat('MMMM', 'vi_VN').format(_currentDate);
      _updateSelectedMonthAndDayOfWeek(_currentDate);
      _monthBloc.add(LoadDataToMonth(_currentDate));
      _hasChangedMonth = true;
      _fetchEventCounts();
    });
  }

  void _goToCurrentMonth() {
    setState(() {
      _currentDate = DateTime.now();
      _selectedMonth = DateFormat('MMMM').format(_currentDate);
      _updateSelectedMonthAndDayOfWeek(_currentDate);
      _monthBloc.add(LoadDataToMonth(_currentDate));
      _hasChangedMonth = false; // Đặt trạng thái trở về
      _fetchEventCounts();
    });
  }

  void _updateSelectedMonthAndDayOfWeek(DateTime date) {
    _selectedDayOfWeek = DateFormat('EEEE').format(date);
    _selectedMonth = DateFormat('MMMM').format(date);
  }

  void updateCounts(int morningCount, int afternoonCount) {
    setState(() {
      // Cập nhật số lượng cho buổi sáng và chiều
      this.morningCount = morningCount; // Giả sử bạn có morningCount
      this.afternoonCount = afternoonCount; // Giả sử bạn có afternoonCount
    });
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
      padding: const EdgeInsets.all(8.0),
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
                final date = DateFormat('dd/MM/yyyy').parse(day['date']!);
                final isToday = day['date'] ==
                    DateFormat('dd/MM/yyyy').format(DateTime.now());
                final isSelected = date == _currentDate;
                return GestureDetector(
                  onTap: () => _updateSelectedDate(date),
                  child: Container(
                    width: itemWidth,
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

          final currentMonth =
              DateFormat('MMMM', 'vi_VN').format(DateTime.now());
          final selectedMonth =
              DateFormat('MMMM', 'vi_VN').format(state.selectedDate);

          // Find index of the selected month
          int selectedMonthIndex = state.monthsList
              .indexWhere((m) => m['monthName'] == selectedMonth);
          if (selectedMonthIndex == -1) {
            selectedMonthIndex = state.monthsList
                .indexWhere((m) => m['monthName'] == currentMonth);
          }

          final monthsToShow = List.generate(5, (index) {
            int monthIndex = (selectedMonthIndex - 2 + index + 12) % 12;
            return state.monthsList[monthIndex];
          });

          final screenWidth = MediaQuery.of(context).size.width;
          final itemWidth = (screenWidth - 32 - 4 * 4) / 5;

          return GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! < 0) {
                context.read<MonthBloc>().add(ChangeMonth(1));
              } else if (details.primaryVelocity! > 0) {
                context.read<MonthBloc>().add(ChangeMonth(-1));
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: monthsToShow.map((month) {
                final isSelected = month['monthName'] == selectedMonth;
                final isCurrentMonth = month['monthName'] == currentMonth;
                final adjustedItemWidth =
                    isCurrentMonth ? itemWidth * 1.2 : itemWidth;

                return Padding(
                  padding: const EdgeInsets.only(right: 2.0),
                  child: GestureDetector(
                    onTap: () {
                      final newDate = DateTime(state.selectedDate.year,
                          state.monthsList.indexOf(month) + 1, 1);
                      context.read<MonthBloc>().add(LoadDataToMonth(newDate));
                    },
                    child: Container(
                      width: adjustedItemWidth,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isCurrentMonth
                            ? Colors.yellow
                            : (isSelected ? Colors.blue : Colors.white),
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            month['monthOfYear']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isCurrentMonth ? 16 : 14,
                              color: isCurrentMonth
                                  ? Colors.black
                                  : (isSelected ? Colors.white : Colors.black),
                            ),
                          ),
                        ],
                      ),
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
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Sáng'),
              SizedBox(width: 5),
              Container(
                padding: EdgeInsets.all(2),
                child: Text(
                  '($morningCount)',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Chiều'),
              SizedBox(width: 5),
              Container(
                padding: EdgeInsets.all(2),
                child: Text(
                  '($afternoonCount)',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        TabcardList(
          isMorning: true,
          onEventCountChanged: (count) => setState(() => morningCount = count),
          selectedDate: _currentDate,
        ),
        TabcardList(
          isMorning: false,
          onEventCountChanged: (count) =>
              setState(() => afternoonCount = count),
          selectedDate: _currentDate,
        ),
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
