import 'package:flutter/material.dart';
import 'package:flutter_calendar/config/ngn_constant.dart';
import 'package:flutter_calendar/models/list_root_organization_model.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/models/userorganization_model.dart';
import 'package:flutter_calendar/network/api_service.dart';

class MyList extends StatefulWidget {
  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  final ApiProvider _apiProvider = ApiProvider();

  List<Map<String, dynamic>> _filteredDataListUserorganization = [];
  List<Map<String, dynamic>> _filteredDataListSubOrganizations = [];

  final TextEditingController _searchorganizationName = TextEditingController();
  final TextEditingController _searchEmployee = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
            'fullName': user.fullName,
            'jobTitle': user.jobTitle,
          };
        }).toList();
      });
    }
  }

  Future<void> listSubOrganizations() async {
    List<ListRootOrganizationModel>? userListSubOrganizations =
        await _apiProvider.getListRootOrganization(User.token.toString());

    if (userListSubOrganizations != null) {
      List<Map<String, dynamic>> tempList = [];

      void addOrganizationAndSubOrgs(
          dynamic org, bool isRoot, String? parentId, int level) {
        tempList.add({
          'name': org.name,
          'isRoot': isRoot,
          'parentId': parentId,
          'level': level,
        });

        if (org.subOrganizations != null) {
          for (var subOrg in org.subOrganizations) {
            addOrganizationAndSubOrgs(subOrg, false, org.id, level + 1);
          }
        }
      }

      for (var organization in userListSubOrganizations) {
        addOrganizationAndSubOrgs(organization, true, null, 0);
      }

      setState(() {
        _filteredDataListSubOrganizations = tempList;
      });
    } else {
      print('The userListSubOrganizations is null.');
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
          child: _buildDepartmentList(),
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
          // Cập nhật danh sách khi người dùng nhập tìm kiếm
          if (controller == _searchorganizationName) {
          } else if (controller == _searchEmployee) {}
        },
      ),
    );
  }

  Widget _buildDepartmentList() {
    return ListView.builder(
      itemCount: _filteredDataListSubOrganizations.length,
      itemBuilder: (context, index) {
        final data = _filteredDataListSubOrganizations[index];

        return Padding(
          padding: EdgeInsets.only(left: data['level'] * 20.0),
          child: ListTile(
            leading: Icon(
              data['isRoot']
                  ? Icons.account_balance
                  : Icons.subdirectory_arrow_right,
              size: data['isRoot'] ? 24 : 20,
            ),
            title: Text(
              data['name'] ?? '',
              style: TextStyle(
                fontWeight:
                    data['isRoot'] ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            onTap: () {
              // Xử lý khi người dùng nhấn vào một tổ chức
            },
          ),
        );
      },
    );
  }

  Widget _buildEmployeeList() {
    return ListView.builder(
      itemCount: _filteredDataListUserorganization.length,
      itemBuilder: (context, index) {
        final data = _filteredDataListUserorganization[index];
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
  }
}
