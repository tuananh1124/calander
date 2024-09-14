import 'package:flutter/material.dart';

class LocationList extends StatefulWidget {
  final Function(String location) onItemSelectedLocation;
  LocationList({required this.onItemSelectedLocation});

  @override
  State<LocationList> createState() => _LocationListState();
}

class _LocationListState extends State<LocationList> {
  final List<Map<String, String>> dataListLocation = [
    {'location': '37 Bình Thạnh'},
    {'location': '36 Gò Vấp'},
    {'location': '38 Phú Nhuận'},
    // Thêm các phần tử khác...
  ];

  String? _selectedLocation;
  List<Map<String, String>> _filteredDataListLocation = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredDataListLocation = dataListLocation;
    _searchController.addListener(_filterLocation);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterLocation() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDataListLocation = dataListLocation.where((item) {
        final location = item['location']?.toLowerCase() ?? '';
        return location.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined, size: 16),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Chọn địa điểm'),
        backgroundColor: Colors.blue,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss the keyboard
        },
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(child: _buildLocationList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm địa điểm',
          prefixIcon: Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterLocation(); // Show the entire list
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationList() {
    return ListView.builder(
      itemCount: _filteredDataListLocation.length,
      itemBuilder: (context, index) {
        final data = _filteredDataListLocation[index];
        final isSelected = data['location'] == _selectedLocation;

        return ListTile(
          title: Text(data['location'] ?? ''),
          trailing: ElevatedButton(
            onPressed: () {
              setState(() {
                if (isSelected) {
                  _selectedLocation = null;
                } else {
                  _selectedLocation = data['location'];
                  widget.onItemSelectedLocation(data['location'] ?? '');
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? Colors.red : Colors.blue,
            ),
            child: Text(isSelected ? 'Xóa' : 'Chọn'),
          ),
        );
      },
    );
  }
}
