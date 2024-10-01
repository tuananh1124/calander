import 'package:flutter/material.dart';

class MyList extends StatefulWidget {
  final Function(String name, String position, String status) onItemSelected;

  MyList({required this.onItemSelected});

  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> with SingleTickerProviderStateMixin {
  TabController? _tabController;
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
    _tabController = TabController(length: 2, vsync: this);
    _filteredDataList = dataList;
    _filteredDepartmentData = departmentData;
    _allDepartmentItems = _flattenDepartmentData(departmentData);
    _searchEmployeeController.addListener(_filterEmployees);
    _searchDepartmentController.addListener(_filterDepartments);
    _initExpansionState(departmentData);
    _initExpansionState(dataList);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _searchEmployeeController.dispose();
    _searchDepartmentController.dispose();
    super.dispose();
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
        child: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDepartmentTab(),
                  _buildEmployeeTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 50,
      color: Colors.blue,
      child: TabBar(
        controller: _tabController,
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

  Widget _buildDepartmentTab() {
    return Column(
      children: [
        _buildSearchBar(_searchDepartmentController, 'Tìm kiếm đơn vị'),
        Expanded(
          child: _buildDepartmentList(),
        ),
      ],
    );
  }

  Widget _buildEmployeeTab() {
    return Column(
      children: [
        _buildSearchBar(_searchEmployeeController, 'Tìm kiếm nhân viên'),
        Expanded(
          child: _buildEmployeeList(),
        ),
      ],
    );
  }

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

  Widget _buildDepartmentList() {
    return ListView.builder(
      itemCount: _filteredDepartmentData.length,
      itemBuilder: (context, index) {
        final department = _filteredDepartmentData[index];
        final departmentName = department['department'];
        final subgroups = department['subgroups'] as List<dynamic>?;

        final mainDepartmentEmployeeCount =
            dataList.where((data) => data['group'] == departmentName).length;
        final mainDepartmentEmployeeCountText = mainDepartmentEmployeeCount > 0
            ? ' ($mainDepartmentEmployeeCount)'
            : '';

        return subgroups != null && subgroups.isNotEmpty
            ? _buildExpandableSubgroup(departmentName, subgroups)
            : ListTile(
                title: Text(
                  '$departmentName$mainDepartmentEmployeeCountText',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                onTap: () => _onGroupSelected(departmentName),
              );
      },
    );
  }

  Widget _buildEmployeeList() {
    return ListView.builder(
      itemCount: _filteredDataList.length,
      itemBuilder: (context, index) {
        if (index >= _filteredDataList.length) {
          return SizedBox.shrink();
        }

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

  void _initExpansionState(List<Map<String, dynamic>> departments) {
    for (var dept in departments) {
      _expansionState[dept['department'] ?? ''] = false;
      if (dept['subgroups'] != null) {
        _initSubgroupExpansionState(dept['subgroups']);
      }
    }
  }

  void _initSubgroupExpansionState(List<dynamic> subgroups) {
    for (var subgroup in subgroups) {
      if (subgroup is Map<String, dynamic>) {
        _expansionState[subgroup['name'] ?? ''] = false;
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
            flatten(item['subgroups']);
          }
        } else if (item is String) {
          result.add(item);
        }
      }
    }

    for (var dept in departmentData) {
      result.add(dept['department'] ?? '');
      if (dept['subgroups'] != null) {
        flatten(dept['subgroups']);
      }
    }
    return result;
  }

  Widget _buildExpandableSubgroup(
      String departmentName, List<dynamic> subgroups) {
    return ExpansionTile(
      title: Text(departmentName),
      initiallyExpanded: _expansionState[departmentName] ?? false,
      onExpansionChanged: (isExpanded) {
        setState(() {
          _expansionState[departmentName] = isExpanded;
        });
      },
      children: subgroups.map<Widget>((subgroup) {
        String subgroupName;
        if (subgroup is Map) {
          subgroupName = subgroup['name'] ?? '';
        } else if (subgroup is String) {
          subgroupName = subgroup;
        } else {
          return SizedBox.shrink();
        }

        final subgroupEmployeeCount =
            dataList.where((data) => data['group'] == subgroupName).length;
        final subgroupEmployeeCountText =
            subgroupEmployeeCount > 0 ? ' ($subgroupEmployeeCount)' : '';

        return ListTile(
          title: Text(
            '$subgroupName$subgroupEmployeeCountText',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ),
          onTap: () => _onGroupSelected(subgroupName),
        );
      }).toList(),
    );
  }

  void _filterDepartments() {
    final query = _searchDepartmentController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredDepartmentData = departmentData;
      } else {
        _filteredDepartmentData = departmentData.where((department) {
          final departmentMatches =
              department['department'].toLowerCase().contains(query);
          bool subgroupMatches(dynamic subgroup) {
            if (subgroup is String) {
              return subgroup.toLowerCase().contains(query);
            } else if (subgroup is Map<String, dynamic>) {
              final nameMatches =
                  subgroup['name'].toLowerCase().contains(query);
              final nestedSubgroupMatches =
                  (subgroup['subgroups'] as List<dynamic>?)
                          ?.any(subgroupMatches) ??
                      false;
              return nameMatches || nestedSubgroupMatches;
            }
            return false;
          }

          final subgroups = department['subgroups'] as List<dynamic>?;
          final anySubgroupMatches = subgroups?.any(subgroupMatches) ?? false;

          return departmentMatches || anySubgroupMatches;
        }).toList();
      }
    });
  }

  void _filterEmployees() {
    final query = _searchEmployeeController.text.toLowerCase();

    setState(() {
      _filteredDataList = dataList
          .where((data) =>
              data['group'] == _selectedGroup &&
              ((data['name']?.toLowerCase().contains(query) ?? false) ||
                  (data['position']?.toLowerCase().contains(query) ?? false)))
          .toList();
    });
  }

  void _onGroupSelected(String group) {
    setState(() {
      _selectedGroup = group;
      _filteredDataList =
          dataList.where((data) => data['group'] == group).toList();
      _searchEmployeeController.clear();

      if (_filteredDataList.isNotEmpty) {
        _tabController?.animateTo(1);
      }
    });
  }
}
