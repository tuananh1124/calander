import 'package:flutter/material.dart';
import 'package:flutter_calendar/models/list_event_resource_model.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/network/api_service.dart';

class LocationList extends StatefulWidget {
  final Function(Map<String, String>?) onItemSelectedLocation;
  final String? selectedLocationId;
  final String calendarType; // Thêm property này

  const LocationList({
    Key? key,
    required this.onItemSelectedLocation,
    this.selectedLocationId,
    required this.calendarType, // Thêm parameter này
  }) : super(key: key);

  @override
  State<LocationList> createState() => _LocationListState();
}

class _LocationListState extends State<LocationList> {
  final List<Map<String, String>> dataListLocation = [];
  final ApiProvider _apiProvider = ApiProvider();
  String? _selectedLocationId;
  List<Map<String, String>> _filteredDataListLocation = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedLocationId = widget.selectedLocationId; // Khởi tạo với id đã chọn
    _filteredDataListLocation = dataListLocation;
    _searchController.addListener(_filterLocation);
    _fetchResourceData();
  }

  Future<void> _fetchResourceData() async {
    try {
      List<ListEventResourceModel>? listEvent;
      if (widget.calendarType == 'organization') {
        listEvent =
            await _apiProvider.getListEventResource(User.token.toString());
      } else {
        listEvent = await _apiProvider
            .getListOfPersonalEventResource(User.token.toString());
      }

      print('List Event: $listEvent'); // In ra để kiểm tra dữ liệu

      if (listEvent != null) {
        final filteredList = listEvent.where((item) {
          print(
              'Item group: ${item.group}'); // In ra giá trị group của từng item
          return item.group != null && item.group == 0;
        }).toList();

        print('Filtered List: $filteredList'); // In ra danh sách sau khi lọc

        setState(() {
          dataListLocation.clear();
          dataListLocation.addAll(
            filteredList
                .map((item) => {
                      'id': item.id ?? '',
                      'location': item.name ?? '',
                      'description': item.description ?? '',
                    })
                .toList(),
          );
          _filteredDataListLocation = List.from(dataListLocation);
        });
      }
    } catch (e) {
      print('Error in _fetchResourceData: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterLocation() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        // Nếu không có tìm kiếm, hiển thị toàn bộ danh sách
        _filteredDataListLocation = dataListLocation;
      } else {
        // Lọc danh sách dựa trên từ khóa tìm kiếm
        _filteredDataListLocation = dataListLocation.where((item) {
          final location = item['location']?.toLowerCase() ?? '';
          return location.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined, size: 16),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.calendarType == 'organization'
            ? 'Chọn địa điểm đơn vị'
            : 'Chọn địa điểm cá nhân'),
        backgroundColor: Colors.blue,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
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
                    _filterLocation(); // Cập nhật danh sách khi xóa tìm kiếm
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onChanged: (value) {
          _filterLocation(); // Cập nhật danh sách khi có thay đổi
        },
      ),
    );
  }

  Widget _buildLocationList() {
    return ListView.builder(
      itemCount: _filteredDataListLocation.length,
      itemBuilder: (context, index) {
        final data = _filteredDataListLocation[index];
        final isSelected = data['id'] == _selectedLocationId;

        return Card(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text(
              data['location'] ?? '',
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text(data['description'] ?? ''),
            trailing: ElevatedButton(
              onPressed: () {
                if (isSelected) {
                  // When canceling, call onItemSelectedLocation with null
                  widget.onItemSelectedLocation(null);
                  setState(() {
                    _selectedLocationId = null;
                  });
                  Navigator.of(context).pop();
                } else {
                  // Selecting new location
                  widget.onItemSelectedLocation({
                    'id': data['id'] ?? '',
                    'location': data['location'] ?? '',
                    'description': data['description'] ?? ''
                  });
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? Colors.red : Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 16),
              ),
              child: Text(
                isSelected ? 'Hủy' : 'Chọn',
                style: TextStyle(color: Colors.white),
              ),
            ),
            tileColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
          ),
        );
      },
    );
  }
}
