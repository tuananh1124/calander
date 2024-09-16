import 'package:flutter/material.dart';

class SearchBarWithDropdown extends StatefulWidget {
  @override
  _SearchBarWithDropdownState createState() => _SearchBarWithDropdownState();
}

class _SearchBarWithDropdownState extends State<SearchBarWithDropdown> {
  String _selectedFilter = 'Theo tuần';
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

  List<String> _searchResults = [];
  bool _isExpanded = false;
  final TextEditingController _searchController = TextEditingController();

  void _updateSearchResults(String query) {
    List<String> results = [];

    if (query.isNotEmpty) {
      for (var department in unitData) {
        if (department.containsKey('subgroups')) {
          var subgroups = department['subgroups'] as List<dynamic>;
          for (var subgroup in subgroups) {
            if (subgroup is Map<String, dynamic>) {
              var name = subgroup['name'] as String;
              if (name.toLowerCase().contains(query.toLowerCase())) {
                results.add(name);
              }
              var subgroupItems = subgroup['subgroups'] as List<dynamic>;
              for (var item in subgroupItems) {
                if (item.toLowerCase().contains(query.toLowerCase())) {
                  results.add(item);
                }
              }
            } else if (subgroup.toLowerCase().contains(query.toLowerCase())) {
              results.add(subgroup);
            }
          }
        }

        if (department['department']!
            .toLowerCase()
            .contains(query.toLowerCase())) {
          results.add(department['department']!);
        }
      }
    }

    setState(() {
      _searchResults = results;
      _isExpanded = results.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Flexible(
                  //   flex: 2,
                  //   child: TextField(
                  //     controller: _searchController,
                  //     onChanged: _updateSearchResults,
                  //     decoration: InputDecoration(
                  //       hintText: 'Tìm kiếm...',
                  //       prefixIcon: Icon(Icons.search),
                  //       suffixIcon: IconButton(
                  //         icon: Icon(_isExpanded
                  //             ? Icons.expand_less
                  //             : Icons.expand_more),
                  //         onPressed: () {
                  //           setState(() {
                  //             _isExpanded = !_isExpanded;
                  //           });
                  //         },
                  //       ),
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Flexible(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: _selectedFilter,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: <String>['Theo tuần', 'Theo tháng']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedFilter = newValue!;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 3),
                  Flexible(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _selectedFilter,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: <String>['Theo tuần', 'Theo tháng']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
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
            if (_isExpanded)
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.isEmpty
                      ? unitData.length
                      : _searchResults.length,
                  itemBuilder: (context, index) {
                    if (_searchResults.isEmpty) {
                      return ListTile(
                        title: Text(unitData[index]['department']),
                        onTap: () {
                          setState(() {
                            _searchController.text =
                                unitData[index]['department'];
                            _isExpanded = false;
                          });
                        },
                      );
                    } else {
                      return ListTile(
                        title: Text(_searchResults[index]),
                        onTap: () {
                          setState(() {
                            _searchController.text = _searchResults[index];
                            _isExpanded = false;
                          });
                        },
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
