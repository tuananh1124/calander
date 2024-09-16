import 'package:flutter/material.dart';

class SearchBarWithDropdown extends StatefulWidget {
  @override
  _SearchBarWithDropdownState createState() => _SearchBarWithDropdownState();
}

class _SearchBarWithDropdownState extends State<SearchBarWithDropdown> {
  String _selectedFilter = 'Theo tuần';
  String? _selectedUnit;
  List<Map<String, dynamic>> unitData = [
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

  List<String> getDropdownItems(List<Map<String, dynamic>> data) {
    List<String> items = [];

    for (var unit in data) {
      items.add(unit['department']);
      if (unit.containsKey('subgroups')) {
        var subgroups = unit['subgroups'];
        if (subgroups is List) {
          for (var subgroup in subgroups) {
            if (subgroup is String) {
              items.add(subgroup); // Hiển thị subgroups cấp con
            } else if (subgroup is Map<String, dynamic> &&
                subgroup.containsKey('name')) {
              items.add(subgroup['name']); // Hiển thị subgroup chính
              if (subgroup.containsKey('subgroups')) {
                var nestedSubgroups = subgroup['subgroups'];
                if (nestedSubgroups is List) {
                  for (var nestedSubgroup in nestedSubgroups) {
                    items.add(
                        nestedSubgroup); // Hiển thị subgroups con của subgroup
                  }
                }
              }
            }
          }
        }
      }
    }

    return items;
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
                    child: DropdownButtonFormField<String>(
                      value: _selectedUnit,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: _selectedUnit != null
                          ? SizedBox.shrink()
                          : Icon(Icons.arrow_drop_down),
                      items: unitItems.map((String value) {
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
                          _selectedUnit = newValue;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 2),
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
