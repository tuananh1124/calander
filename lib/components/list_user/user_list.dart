import 'package:flutter/material.dart';
import 'package:flutter_calendar/models/list_root_organization_model.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/models/organization_model.dart';
import 'package:flutter_calendar/models/user_organization_model.dart';
import 'package:flutter_calendar/network/api_service.dart';

class MyList extends StatefulWidget {
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(() {
      if (_tabController!.index == 1) {}
    });
    UserorganizationlApi();
    listSubOrganizations();
  }

  Future<void> UserorganizationlApi() async {
    List<UserorganizationModel>? userList =
        await _apiProvider.getUserOrganization(User.token.toString());

    if (userList != null) {
      setState(() {
        _filteredDataListUserorganization = userList.map((user) {
          return {
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
      });
    } else {
      print('Failed to fetch organizations or users.');
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _searchEmployee.dispose();
    _searchorganizationName.dispose();
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
        _buildSearchBar(_searchEmployee, 'Tìm kiếm nhân viên'),
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
        onChanged: (value) {
          if (controller == _searchorganizationName) {
          } else if (controller == _searchEmployee) {}
        },
      ),
    );
  }

  Widget _buildDepartmentTree() {
    return ListView(
      children: _organizationTree.map((node) => _buildTreeNode(node)).toList(),
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
                  setState(() {
                    _currentEmployeeList = node.users;
                    _tabController?.animateTo(1); // Chuyển sang tab nhân viên
                  });
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
          key: ValueKey(_currentEmployeeList.length), // Thêm key này
          itemCount: _currentEmployeeList.length,
          itemBuilder: (context, index) {
            final data = _currentEmployeeList[index];
            bool isSelected = false; // Có thể thêm logic chọn/xóa ở đây

            return ListTile(
              title: Text(data['fullName'] ?? ''),
              subtitle: Text(data['jobTitle'] ?? ''),
              trailing: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isSelected = !isSelected;
                  });
                },
                child: Text(isSelected ? 'Xóa' : 'Chọn'),
              ),
            );
          },
        );
      },
    );
  }
}
