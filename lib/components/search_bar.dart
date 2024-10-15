import 'package:flutter/material.dart';
import 'package:flutter_calendar/models/list_sub_organization_model.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/network/api_service.dart';
import 'package:flutter_calendar/pages/month_boxes/calanderToMonth.dart';
import 'package:table_calendar/table_calendar.dart';

class SearchBarWithDropdown extends StatefulWidget {
  @override
  _SearchBarWithDropdownState createState() => _SearchBarWithDropdownState();
}

class _SearchBarWithDropdownState extends State<SearchBarWithDropdown> {
  String _selectedFilter = 'Theo tuần';
  String? _selectedUnit;
  String _searchQuery = '';
  bool _isSearching = false;
  final ApiProvider _apiProvider = ApiProvider();
  List<ListSubOrganizationModel> unitData = [];

  @override
  void initState() {
    super.initState();
    ListSubOrganizationApi();
  }

  Future<void> ListSubOrganizationApi() async {
    // List<ListSubOrganizationModel>? userList =
    //     await _apiProvider.getListSubOrganization(
    //         '605b064ad9b8222a8db47eb8', User.token.toString());
    // if (userList != null) {
    //   setState(() {
    //     unitData = userList;
    //   });
    // }
  }

  // Cập nhật truy vấn tìm kiếm để sử dụng `unit.name`
  List<String> getFilteredDropdownItems() {
    if (_isSearching) {
      return unitData
          .where((unit) =>
              unit.name!.toLowerCase().contains(_searchQuery.toLowerCase()))
          .map((unit) => unit.name!)
          .toList();
    } else {
      return _selectedUnit != null ? [_selectedUnit!] : [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(child: buildSearchBar()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return GestureDetector(
      onTap: _showUnitDropdown,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: buildBoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _selectedUnit ?? 'Đơn vị hiển thị',
                style: TextStyle(color: Colors.black),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.search),
          ],
        ),
      ),
    );
  }

  BoxDecoration buildBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey),
    );
  }

  void _showUnitDropdown() {
    _isSearching = true;
    _searchQuery = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                children: [
                  buildSearchField(setModalState),
                  SizedBox(height: 16),
                  Expanded(child: buildUnitList()),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget buildSearchField(StateSetter setModalState) {
    return TextField(
      onChanged: (value) {
        setModalState(() {
          _searchQuery = value;
        });
      },
      decoration: InputDecoration(
        labelText: 'Tìm kiếm đơn vị',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: Icon(Icons.search),
      ),
    );
  }

  Widget buildUnitList() {
    return ListView(
      children: getFilteredDropdownItems().map((unit) {
        return ListTile(
          title: Text(
            unit,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: _selectedUnit == unit
              ? Icon(Icons.check, color: Colors.green)
              : null,
          onTap: () {
            setState(() {
              _selectedUnit = unit;
              _isSearching = false;
            });
            Navigator.pop(context);
          },
        );
      }).toList(),
    );
  }
}
