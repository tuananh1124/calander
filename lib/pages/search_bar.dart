import 'package:flutter/material.dart';

class SearchBarWithDropdown extends StatefulWidget {
  @override
  _SearchBarWithDropdownState createState() => _SearchBarWithDropdownState();
}

class _SearchBarWithDropdownState extends State<SearchBarWithDropdown> {
  final TextEditingController _controller = TextEditingController();
  bool _showSuggestions = false;
  String _selectedFilter = 'Theo tuần';

  final List<Map<String, dynamic>> unitData = [
    {
      'department': 'Vụ Tổ Chức Cán Bộ',
      'subgroups': [
        {
          'name': 'Phòng Công tác đảng và đoàn thể',
          'subgroups': ['Nhóm 1', 'Nhóm 2'],
        },
        'Phòng Thi đua - Khen thưởng',
        'Phòng Tổ chức - Cán bộ',
      ],
    },
    {
      'department': 'Phòng Tổng hợp',
      'subgroups': ['Nhóm A', 'Nhóm B'],
    },
    {
      'department': 'Phòng Cá',
    },
    // ... (các mục khác)
  ];

  List<Map<String, dynamic>> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _filteredData = unitData;
  }

  void _filterSuggestions(String query) {
    setState(() {
      _filteredData = unitData.where((department) {
        final departmentName = department['department']?.toLowerCase() ?? '';
        final queryLower = query.toLowerCase();

        // Kiểm tra nếu tên đơn vị chứa truy vấn
        bool matchesDepartment = departmentName.contains(queryLower);

        // Kiểm tra nếu nhóm phụ có chứa truy vấn
        final subgroups = department['subgroups'] as List<dynamic>?;

        bool matchesSubgroups = subgroups?.any((subgroup) {
              if (subgroup is String) {
                return subgroup.toLowerCase().contains(queryLower);
              } else if (subgroup is Map<String, dynamic>) {
                final subgroupName = subgroup['name']?.toLowerCase() ?? '';
                bool matchesSubgroupName = subgroupName.contains(queryLower);

                final subgroupList = subgroup['subgroups'] as List<dynamic>?;

                bool matchesSubgroupList = subgroupList?.any((subItem) {
                      if (subItem is String) {
                        return subItem.toLowerCase().contains(queryLower);
                      }
                      return false;
                    }) ??
                    false;

                return matchesSubgroupName || matchesSubgroupList;
              }
              return false;
            }) ??
            false;

        return matchesDepartment || matchesSubgroups;
      }).toList();
    });
  }

  String _shortenText(String text) {
    return text.length > 30 ? text.substring(0, 27) + '...' : text;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              Flexible(
                flex: 2,
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Đơn vị hiện tại',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showSuggestions
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                      ),
                      onPressed: () {
                        setState(() {
                          _showSuggestions = !_showSuggestions;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    _filterSuggestions(value);
                  },
                  onTap: () {
                    setState(() {
                      _showSuggestions = true;
                    });
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
                  items:
                      <String>['Theo tuần', 'Theo tháng'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFilter = newValue!;
                      // Logic to handle content based on the selected filter
                    });
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
