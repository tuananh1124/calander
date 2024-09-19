import 'package:flutter/material.dart';

class SearchBarWithDropdown extends StatefulWidget {
  @override
  _SearchBarWithDropdownState createState() => _SearchBarWithDropdownState();
}

class _SearchBarWithDropdownState extends State<SearchBarWithDropdown> {
  String _selectedFilter = 'Theo tuần';
  String? _selectedUnit; // Chỉ một phòng ban được chọn
  String _searchQuery = '';
  bool _isSearching = false;

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
    if (_isSearching) {
      return unitData
          .where((unit) => unit['department']!
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .map((unit) => unit['department'] as String)
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
                    Expanded(
                      child: buildSearchBar(),
                    ),
                    SizedBox(width: 3), // Adjust spacing between the widgets
                    Expanded(
                      child: buildDropdownButtonFormField(),
                    ),
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
      onTap: () {
        _showUnitDropdown();
      },
      child: Container(
        padding: EdgeInsets.all(12),
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
                style: TextStyle(color: Colors.black),
                maxLines: 1, // Ensure text appears on a single line
                overflow:
                    TextOverflow.ellipsis, // Add ellipsis if text overflows
              ),
            ),
            Icon(Icons.search),
          ],
        ),
      ),
    );
  }

  Widget buildDropdownButtonFormField() {
    return DropdownButtonFormField<String>(
      value: _selectedFilter,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black), // Border màu đen
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Colors.black), // Border màu đen khi focus
        ),
      ),
      items: [
        DropdownMenuItem(
          value: 'Theo tuần',
          child: Text('Theo tuần'),
        ),
        DropdownMenuItem(
          value: 'Theo tháng',
          child: Text('Theo tháng'),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _selectedFilter = value ?? 'Theo tuần'; // Cập nhật giá trị bộ lọc
        });
      },
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
                  TextField(
                    onChanged: (value) {
                      setModalState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Tìm kiếm phòng ban',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: getFilteredDropdownItems().map((unit) {
                        return ListTile(
                          title: Text(
                            unit,
                            maxLines: 1, // Ensure text appears on a single line
                            overflow: TextOverflow
                                .ellipsis, // Add ellipsis if text overflows
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
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
