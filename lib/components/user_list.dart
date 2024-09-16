import 'package:flutter/material.dart';

class MyList extends StatefulWidget {
  final Function(String name, String position, String status) onItemSelected;

  MyList({required this.onItemSelected});

  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  Map<String, bool> _expansionState = {};
  final List<Map<String, dynamic>> dataList = [
    {
      'name': 'Nguyễn Tuấn Anh',
      'position': 'Developer',
      'status': 'Chưa xác nhận',
      'group': 'Phòng Công tác đảng và đoàn thể'
    },
    {
      'name': 'Trần Văn B',
      'position': 'Designer',
      'status': 'Chưa xác nhận',
      'group': 'Phòng Công tác đảng và đoàn thể'
    },
    {
      'name': 'Lê Văn C',
      'position': 'Tester',
      'status': 'Chưa xác nhận',
      'group': 'Phòng Cá'
    },
    {
      'name': 'Nguyễn A',
      'position': 'Developer',
      'status': 'Chưa xác nhận',
      'group': 'Phòng Cá'
    },
    {
      'name': 'Văn B',
      'position': 'Designer',
      'status': 'Chưa xác nhận',
      'group': 'Phòng Thi đua - Khen thưởng'
    },
    {
      'name': 'Lê C',
      'position': 'Tester',
      'status': 'Chưa xác nhận',
      'group': 'Nhóm A'
    },
    // ... (other items)
  ];

  final List<Map<String, dynamic>> departmentData = [
    {
      'department': 'Vụ Tổ Chức Cán Bộ',
      'subgroups': [
        {
          'name': 'Phòng Công tác đảng và đoàn thể',
          'subgroups': [
            'Nhóm 1',
            'Nhóm 2',
          ]
        },
        'Phòng Thi đua - Khen thưởng',
        'Phòng Tổ chức - Cán bộ'
      ]
    },
    {
      'department': 'Phòng Tổng hợp',
      'subgroups': ['Nhóm A', 'Nhóm B']
    },
    {'department': 'Phòng Cá'},
    // ... (other items)
  ];

  String? _selectedGroup;
  String? _selectedName;
  List<Map<String, dynamic>> _filteredDataList = [];
  List<Map<String, dynamic>> _filteredDepartmentData = [];
  List<String> _allDepartmentItems = [];
  final TextEditingController _searchDepartmentController =
      TextEditingController();
  final TextEditingController _searchEmployeeController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredDataList = dataList;
    _filteredDepartmentData = departmentData;
    _allDepartmentItems = _flattenDepartmentData(departmentData);
    _searchEmployeeController.addListener(_filterEmployees);
    _searchDepartmentController.addListener(_filterDepartments);
    _initExpansionState(departmentData);
  }

  @override
  void dispose() {
    _searchEmployeeController.dispose();
    _searchDepartmentController.dispose();
    super.dispose();
  }

  void _initExpansionState(List<Map<String, dynamic>> departments) {
    for (var dept in departments) {
      _expansionState[dept['department']] = false;
      if (dept['subgroups'] != null) {
        _initSubgroupExpansionState(dept['subgroups']);
      }
    }
  }

  void _initSubgroupExpansionState(List<dynamic> subgroups) {
    for (var subgroup in subgroups) {
      if (subgroup is Map<String, dynamic>) {
        _expansionState[subgroup['name']] = false;
        if (subgroup['subgroups'] != null) {
          _initSubgroupExpansionState(subgroup['subgroups']);
        }
      }
    }
  }

  List<String> _flattenDepartmentData(
      List<Map<String, dynamic>> departmentData) {
    List<String> result = [];

    void flatten(List<dynamic> items) {
      for (var item in items) {
        if (item is Map<String, dynamic>) {
          result.add(item['name'] ?? '');
          if (item['subgroups'] != null) {
            flatten(item['subgroups'] as List<dynamic>);
          }
        } else {
          result.add(item);
        }
      }
    }

    for (var department in departmentData) {
      result.add(department['department'] ?? '');
      if (department['subgroups'] != null) {
        flatten(department['subgroups'] as List<dynamic>);
      }
    }

    return result;
  }

  void _filterDepartments() {
    final query = _searchDepartmentController.text.toLowerCase();
    setState(() {
      _filteredDepartmentData = departmentData.where((dept) {
        final departmentName = dept['department']?.toLowerCase() ?? '';
        final subgroups = dept['subgroups'] as List<dynamic>? ?? [];

        // Check if department or any of its subgroups match the query
        return departmentName.contains(query) ||
            _searchInSubgroups(subgroups, query);
      }).toList();
    });
  }

  bool _searchInSubgroups(List<dynamic> subgroups, String query) {
    for (var subgroup in subgroups) {
      if (subgroup is Map<String, dynamic>) {
        final name = subgroup['name']?.toLowerCase() ?? '';
        final subSubgroups = subgroup['subgroups'] as List<dynamic>? ?? [];
        if (name.contains(query) || _searchInSubgroups(subSubgroups, query)) {
          return true;
        }
      } else if (subgroup.toString().toLowerCase().contains(query)) {
        return true;
      }
    }
    return false;
  }

  void _filterEmployees() {
    final query = _searchEmployeeController.text.toLowerCase();
    setState(() {
      _filteredDataList = dataList.where((item) {
        final name = item['name']?.toLowerCase() ?? '';
        final position = item['position']?.toLowerCase() ?? '';
        final group = item['group']?.toLowerCase() ?? '';
        return (name.contains(query) || position.contains(query)) &&
            (_selectedGroup == null ||
                group.toLowerCase() == _selectedGroup!.toLowerCase());
      }).toList();
    });
  }

  void _onGroupSelected(String? value) {
    setState(() {
      _selectedGroup = value;
      _filterEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined,
              color: Colors.white, size: 16),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title:
            Text('Chọn người tham dự', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  children: [
                    // Department Tab
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildSearchBar(
                              _searchDepartmentController, 'Tìm kiếm đơn vị'),
                          _buildDepartmentList(),
                        ],
                      ),
                    ),
                    // Employee Tab
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildSearchBar(
                              _searchEmployeeController, 'Tìm kiếm nhân viên'),
                          Container(
                            height: MediaQuery.of(context).size.height - 150,
                            child: _buildEmployeeList(),
                          ),
                        ],
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

  // Widget for Tab Bar
  Widget _buildTabBar() {
    return Container(
      height: 50,
      color: Colors.blue,
      child: TabBar(
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
        tabs: [
          Tab(text: 'Đơn vị'),
          Tab(text: 'Nhân viên'),
        ],
      ),
    );
  }

  // Widget for building the search bar
  Widget _buildSearchBar(TextEditingController controller, String hintText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  // Widget for building the expandable department list
  Widget _buildDepartmentList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _filteredDepartmentData.length,
      itemBuilder: (context, index) {
        final department = _filteredDepartmentData[index];
        final departmentName = department['department'];
        final subgroups = department['subgroups'] as List<dynamic>?;

        if (subgroups != null && subgroups.isNotEmpty) {
          return _buildExpandableSubgroup(departmentName, subgroups);
        } else {
          return ListTile(
            title: Text(departmentName,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            onTap: () => _onGroupSelected(departmentName),
          );
        }
      },
    );
  }

  Widget _buildExpandableSubgroup(String name, List<dynamic> subgroups) {
    return ExpansionTile(
      key: Key(name), // Thêm key để Flutter có thể theo dõi trạng thái
      initiallyExpanded: _expansionState[name] ?? false,
      onExpansionChanged: (isExpanded) {
        setState(() {
          _expansionState[name] = isExpanded;
        });
      },
      title: Text(name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
      children: subgroups.map<Widget>((subgroup) {
        if (subgroup is Map<String, dynamic>) {
          return _buildExpandableSubgroup(
              subgroup['name'], subgroup['subgroups'] ?? []);
        } else {
          return ListTile(
            title: Text(subgroup),
            onTap: () => _onGroupSelected(subgroup),
          );
        }
      }).toList(),
    );
  }

  // Widget for building subgroups
  List<Widget> _buildSubgroupWidgets(List<dynamic> subgroups) {
    return subgroups.map<Widget>((subgroup) {
      if (subgroup is Map<String, dynamic>) {
        return ExpansionTile(
          title: Text(subgroup['name']),
          children: _buildSubgroupWidgets(subgroup['subgroups'] ?? []),
        );
      } else {
        return ListTile(
          title: Text(subgroup),
          onTap: () => _onGroupSelected(subgroup),
        );
      }
    }).toList();
  }

  // Widget for building the list of employees
  Widget _buildEmployeeList() {
    return ListView.builder(
      itemCount: _filteredDataList.length,
      itemBuilder: (context, index) {
        final data = _filteredDataList[index];
        final isSelected = data['name'] == _selectedName;
        return ListTile(
          title: Text(data['name'] ?? ''),
          subtitle: Text(data['position'] ?? ''),
          trailing: ElevatedButton(
            onPressed: () {
              setState(() {
                if (isSelected) {
                  _selectedName = null;
                  widget.onItemSelected('', '', '');
                } else {
                  _selectedName = data['name'];
                  widget.onItemSelected(
                    data['name'] ?? '',
                    data['position'] ?? '',
                    data['status'] ?? '',
                  );
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? Colors.red : Colors.blue,
            ),
            child: Text(isSelected ? 'Xóa' : 'Chọn'),
          ),
        );
      },
    );
  }
}
