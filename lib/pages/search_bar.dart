import 'package:flutter/material.dart';

class SearchBarWithDropdown extends StatefulWidget {
  @override
  _SearchBarWithDropdownState createState() => _SearchBarWithDropdownState();
}

class _SearchBarWithDropdownState extends State<SearchBarWithDropdown> {
  String _selectedFilter = 'Theo tuần';
  String? _selectedUnit;
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

  List<String> getDropdownItems(List<Map<String, dynamic>> data) {
    return data.map((unit) => unit['department'] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<String> unitItems = getDropdownItems(unitData);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: PopupMenuButton<String>(
                      onSelected: (String newValue) {
                        setState(() {
                          _selectedUnit = newValue;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _selectedUnit ?? 'Chọn phòng ban',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                      itemBuilder: (BuildContext context) {
                        return unitItems.map((String value) {
                          return PopupMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _selectedFilter,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: _selectedFilter.isNotEmpty
                          ? SizedBox.shrink()
                          : Icon(Icons.arrow_drop_down),
                      items: <String>['Theo tuần', 'Theo tháng']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedFilter = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
