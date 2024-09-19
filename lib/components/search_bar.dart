import 'package:flutter/material.dart';

class SearchBarWithDropdown extends StatefulWidget {
  @override
  _SearchBarWithDropdownState createState() => _SearchBarWithDropdownState();
}

class _SearchBarWithDropdownState extends State<SearchBarWithDropdown> {
  String _selectedFilter = 'Theo tuần';
  String? _selectedUnit; // Chỉ một phòng ban được chọn
  String _searchQuery = '';

  List<Map<String, dynamic>> unitData = [
    {'department': 'Vụ Tổ Chức Cán Bộ'},
    {'department': 'Phòng Tổng hợp'},
    {'department': 'Phòng Cá'},
    {'department': 'Vụ Quản lý Dự án'},
    {'department': 'Phòng Hành chính'},
    {'department': 'Phòng Kế toán'},
    {'department': 'Vụ Phát triển Kinh doanh'},
    {'department': 'Phòng Nhân sự'},
    {'department': 'Phòng Dịch vụ Khách hàng'},
    {'department': 'Vụ Chiến lược'},
    {'department': 'Phòng Marketing'},
    {'department': 'Phòng Kỹ thuật'},
    {'department': 'Vụ Đào tạo'},
    {'department': 'Phòng IT'},
    {'department': 'Phòng Quản lý Chất lượng'},
    {'department': 'Vụ Nghiên cứu và Phát triển'},
    {'department': 'Phòng Hỗ trợ Kỹ thuật'},
    {'department': 'Phòng Quản lý Hợp đồng'},
    {'department': 'Vụ Tài chính'},
    {'department': 'Phòng Xây dựng'},
    {'department': 'Phòng Kiểm toán'},
    // ... thêm các phòng ban khác nếu cần
  ];

  List<String> getFilteredDropdownItems() {
    List<String> items = unitData
        .where((unit) => unit['department']
            .toString()
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .map((unit) => unit['department'] as String)
        .toList();
    items.sort(); // Sắp xếp danh sách theo thứ tự A-Z
    return items;
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
                    Expanded(
                      child: buildSearchBar(),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: buildDropdownButtonFormField(),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: _selectedFilter == 'Theo tháng',
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildDecoratedContainer('Theo tháng'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return GestureDetector(
      onTap: () {
        _showUnitDropdown();
      },
      child: Container(
        padding: EdgeInsets.all(11.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _selectedUnit ?? 'Tìm kiếm phòng ban',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            Icon(Icons.search),
          ],
        ),
      ),
    );
  }

  void _showUnitDropdown() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Tìm kiếm phòng ban',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: getFilteredDropdownItems().map((unit) {
                    return ListTile(
                      title: Text(unit),
                      trailing: _selectedUnit == unit
                          ? Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedUnit = unit;
                        });
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildDropdownButtonFormField() {
    return DropdownButtonFormField<String>(
      value: _selectedFilter,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      items: <String>['Theo tuần', 'Theo tháng'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontSize: 14), // Điều chỉnh kích thước font
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedFilter = newValue!;
        });
      },
    );
  }

  Widget buildDecoratedContainer(String text) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text),
    );
  }
}
