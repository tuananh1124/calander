import 'package:flutter/material.dart';
import 'package:flutter_calendar/models/list_root_organization_model.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/models/organization_model.dart';
import 'package:flutter_calendar/models/user_organization_model.dart';
import 'package:flutter_calendar/network/api_service.dart';

class MyList extends StatefulWidget {
  final Function(List<Map<String, String>>) onEmployeesSelected;

  const MyList({Key? key, required this.onEmployeesSelected}) : super(key: key);

  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final ApiProvider _apiProvider = ApiProvider();
  List<Map<String, dynamic>> _filteredDataListUserorganization = [];
  List<OrganizationNode> _organizationTree = [];
  final TextEditingController _searchorganizationName = TextEditingController();
  final TextEditingController _searchEmployee = TextEditingController();
  List<Map<String, String>> _currentEmployeeList = [];
  List<Map<String, String>> _filteredEmployeeList = [];
  List<OrganizationNode> _filteredOrganizationTree = [];
  Map<String, Map<String, bool>> _selectedEmployees = {};
  int _selectedEmployeeCount = 0;
  final ScrollController _employeeListScrollController = ScrollController();
  String _currentOrganizationId = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(() {
      if (_tabController!.index == 1) {}
    });
    UserorganizationlApi();
    listSubOrganizations();
    _filteredOrganizationTree = _organizationTree;
  }

  Future<void> UserorganizationlApi() async {
    List<UserorganizationModel>? userList =
        await _apiProvider.getUserOrganization(User.token.toString());

    if (userList != null) {
      setState(() {
        _filteredDataListUserorganization = userList.map((user) {
          return {
            'id': user.id ?? '', // Thêm ID vào đây
            'organizationId': user.organizationId ?? '',
            'fullName': user.fullName ?? '',
            'jobTitle': user.jobTitle ?? '',
          };
        }).toList();
      });
    }
  }

  Future<void> listSubOrganizations() async {
    List<ListRootOrganizationModel>? userListSubOrganizations =
        await _apiProvider.getListRootOrganization(User.token.toString());
    List<UserorganizationModel>? userList =
        await _apiProvider.getUserOrganization(User.token.toString());

    if (userListSubOrganizations != null && userList != null) {
      List<OrganizationNode> rootNodes = [];

      OrganizationNode createNode(
          dynamic org, bool isRoot, String? parentId, int level) {
        List<Map<String, String>> orgUsers = userList
            .where((user) => user.organizationId == org.id)
            .map((user) => {
                  'id': user.id ?? '', // Thêm ID vào đây
                  'fullName': user.fullName ?? '',
                  'jobTitle': user.jobTitle ?? '',
                })
            .toList();

        return OrganizationNode(
          name: org.name,
          id: org.id,
          isRoot: isRoot,
          parentId: parentId,
          level: level,
          children: org.subOrganizations
                  ?.map<OrganizationNode>(
                      (subOrg) => createNode(subOrg, false, org.id, level + 1))
                  ?.toList() ??
              [],
          users: orgUsers,
        );
      }

      for (var organization in userListSubOrganizations) {
        rootNodes.add(createNode(organization, true, null, 0));
      }

      setState(() {
        _organizationTree = rootNodes;
        _filteredOrganizationTree = rootNodes; // Initialize filtered list
      });
    } else {
      print('Failed to fetch organizations or users.');
    }
  }

  List<OrganizationNode> _filterOrganizations(
      String query, List<OrganizationNode> organizations) {
    if (query.isEmpty) return organizations;
    List<OrganizationNode> filteredOrganizations = [];
    for (var node in organizations) {
      bool matches = node.name.toLowerCase().contains(query.toLowerCase());
      List<OrganizationNode> filteredChildren =
          _filterOrganizations(query, node.children);
      if (matches || filteredChildren.isNotEmpty) {
        filteredOrganizations.add(OrganizationNode(
          name: node.name,
          id: node.id,
          isRoot: node.isRoot,
          parentId: node.parentId,
          level: node.level,
          children: filteredChildren, // Include only the matching children
          users: node.users,
        ));
      }
    }

    return filteredOrganizations;
  }

  void _filterEmployees(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredEmployeeList = _currentEmployeeList;
      } else {
        _filteredEmployeeList = _currentEmployeeList
            .where((employee) => employee['fullName']!
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _updateSelectedEmployeeCount() {
    int count = 0;
    _selectedEmployees.forEach((orgId, employees) {
      count += employees.values.where((isSelected) => isSelected).length;
    });
    setState(() {
      _selectedEmployeeCount = count;
    });
  }

  void _showSelectedEmployees() {
    List<Widget> employeeWidgets = [];
    _organizationTree.forEach((org) {
      _addEmployeesToList(org, employeeWidgets);
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nhân viên đã chọn'),
          content: SingleChildScrollView(
            child: ListBody(
              children: employeeWidgets,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addEmployeesToList(OrganizationNode org, List<Widget> employeeWidgets) {
    if (_selectedEmployees.containsKey(org.id)) {
      bool hasSelectedEmployees = false;
      List<Widget> orgEmployees = [];
      _selectedEmployees[org.id]!.forEach((employeeId, isSelected) {
        if (isSelected) {
          hasSelectedEmployees = true;
          var employee = org.users.firstWhere((e) => e['id'] == employeeId);
          orgEmployees.add(
            InkWell(
              onTap: () {
                Navigator.of(context).pop(); // Đóng dialog
                _navigateToEmployee(org.id, employeeId);
              },
              child: ListTile(
                title: Text(employee['fullName'] ?? ''),
                subtitle: Text(employee['jobTitle'] ?? ''),
              ),
            ),
          );
        }
      });
      if (hasSelectedEmployees) {
        employeeWidgets.add(ExpansionTile(
          title: Text(org.name),
          children: orgEmployees,
        ));
      }
    }
    org.children
        .forEach((child) => _addEmployeesToList(child, employeeWidgets));
  }

  void _navigateToEmployee(String organizationId, String employeeId) {
    // Chuyển đến tab nhân viên
    _tabController?.animateTo(1);

    // Cập nhật danh sách nhân viên nếu cần
    if (_currentOrganizationId != organizationId) {
      _updateCurrentEmployeeList(organizationId);
    }

    // Tìm index của nhân viên trong danh sách
    int employeeIndex = _currentEmployeeList.indexWhere((employee) =>
        employee['id'] == employeeId &&
        employee['organizationId'] == organizationId);

    if (employeeIndex != -1) {
      // Scroll đến vị trí của nhân viên
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_employeeListScrollController.hasClients) {
          _employeeListScrollController.animateTo(
            employeeIndex * 56.0, // Giả sử mỗi ListTile cao 56 pixel
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void _updateCurrentEmployeeList(String organizationId) {
    OrganizationNode? org = _findOrganizationById(organizationId);
    if (org != null) {
      setState(() {
        _currentEmployeeList = org.users
            .map((user) => {
                  ...user,
                  'organizationId': org.id,
                })
            .toList();
        _filteredEmployeeList = _currentEmployeeList;
        _currentOrganizationId = organizationId;
      });
    }
  }

  OrganizationNode? _findOrganizationById(String id) {
    OrganizationNode? findNode(OrganizationNode node) {
      if (node.id == id) return node;
      for (var child in node.children) {
        var result = findNode(child);
        if (result != null) return result;
      }
      return null;
    }

    for (var node in _organizationTree) {
      var result = findNode(node);
      if (result != null) return result;
    }
    return null;
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _searchEmployee.dispose();
    _searchorganizationName.dispose();
    super.dispose();
  }

  List<Map<String, String>> _getSelectedEmployees() {
    List<Map<String, String>> selectedEmployees = [];
    _selectedEmployees.forEach((orgId, employees) {
      employees.forEach((employeeId, isSelected) {
        if (isSelected) {
          var org = _findOrganizationById(orgId);
          var employee = org?.users.firstWhere((e) => e['id'] == employeeId);
          if (employee != null) {
            selectedEmployees.add({
              'fullName': employee['fullName'] ?? '',
              'jobTitle': employee['jobTitle'] ?? '',
            });
          }
        }
      });
    });
    return selectedEmployees;
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
            List<Map<String, String>> selectedEmployees =
                _getSelectedEmployees();
            widget.onEmployeesSelected(selectedEmployees);
            Navigator.of(context).pop();
          },
        ),
        title:
            Text('Chọn người tham dự', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          GestureDetector(
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
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: _showSelectedEmployees,
              child: _selectedEmployeeCount > 0
                  ? Text('$_selectedEmployeeCount')
                  : Icon(Icons.menu),
              backgroundColor: Colors.blue,
            ),
          ),
        ],
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
        _buildSearchBar(_searchorganizationName, 'Tìm kiếm đơn vị'),
        Expanded(
          child: _buildDepartmentTree(),
        ),
      ],
    );
  }

  Widget _buildEmployeeTab() {
    return Column(
      children: [
        _buildSearchBar(_searchEmployee, 'Tìm kiếm nhân viên',
            isEmployeeSearch: true),
        Expanded(
          child: _buildEmployeeList(),
        ),
      ],
    );
  }

  Widget _buildSearchBar(TextEditingController controller, String hintText,
      {bool isEmployeeSearch = false}) {
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
        onChanged: (value) {
          if (isEmployeeSearch) {
            _filterEmployees(value);
          } else {
            setState(() {
              _filteredOrganizationTree =
                  _filterOrganizations(value, _organizationTree);
            });
          }
        },
      ),
    );
  }

  Widget _buildDepartmentTree() {
    return ListView(
      children: _filteredOrganizationTree
          .map((node) => _buildTreeNode(node))
          .toList(),
    );
  }

  Widget _buildTreeNode(OrganizationNode node) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              node.isExpanded = !node.isExpanded;
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Row(
              children: [
                SizedBox(width: node.level * 20.0),
                Icon(
                  node.isRoot
                      ? Icons.account_balance
                      : Icons.subdirectory_arrow_right,
                  size: node.isRoot ? 28 : 24,
                  color: Colors.blue,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${node.name} (${node.users.length})',
                    style: TextStyle(
                      fontSize: node.isRoot ? 18 : 16,
                      fontWeight:
                          node.isRoot ? FontWeight.bold : FontWeight.normal,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (node.children.isNotEmpty || node.users.isNotEmpty)
                  Icon(
                    node.isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 24,
                    color: Colors.blue,
                  ),
              ],
            ),
          ),
        ),
        if (node.isExpanded) ...[
          if (node.users.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: (node.level + 1) * 20.0),
              child: ElevatedButton(
                onPressed: () {
                  _updateCurrentEmployeeList(node.id);
                  _tabController?.animateTo(1);
                },
                child: Text('Xem ${node.users.length} nhân viên'),
              ),
            ),
          ...node.children.map((childNode) => _buildTreeNode(childNode)),
        ],
      ],
    );
  }

  Widget _buildEmployeeList() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return ListView.builder(
          controller: _employeeListScrollController,
          key: ValueKey(_filteredEmployeeList.length),
          itemCount: _filteredEmployeeList.length,
          itemBuilder: (context, index) {
            final data = _filteredEmployeeList[index];
            final employeeId = data['id'] ?? '';
            final organizationId = data['organizationId'] ?? '';

            bool isSelected =
                _selectedEmployees[organizationId]?[employeeId] ?? false;

            return ListTile(
              title: Text(data['fullName'] ?? ''),
              subtitle: Text(data['jobTitle'] ?? ''),
              trailing: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (_selectedEmployees[organizationId] == null) {
                      _selectedEmployees[organizationId] = {};
                    }
                    _selectedEmployees[organizationId]![employeeId] =
                        !isSelected;
                    _updateSelectedEmployeeCount();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? Colors.red : null,
                ),
                child: Text(isSelected ? 'Hủy' : 'Chọn'),
              ),
            );
          },
        );
      },
    );
  }
}
