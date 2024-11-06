import 'package:flutter/material.dart';
import 'package:flutter_calendar/models/list_event_resource_model.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/network/api_service.dart';

class ResourceList extends StatefulWidget {
  final Function(List<Map<String, String>>) onItemSelectedResource;
  final List<String> selectedResourceIds;

  const ResourceList({
    Key? key,
    required this.onItemSelectedResource,
    required this.selectedResourceIds,
  }) : super(key: key);

  @override
  State<ResourceList> createState() => _ResourceListState();
}

class _ResourceListState extends State<ResourceList> {
  final List<Map<String, String>> dataListResource = [];
  final ApiProvider _apiProvider = ApiProvider();
  List<String> _selectedResourceIds = []; // Thay đổi thành list
  List<Map<String, String>> _filteredDataListResource = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedResourceIds = List.from(widget.selectedResourceIds);
    _filteredDataListResource = dataListResource;
    _searchController.addListener(_filterResource);
    _fetchResourceData();
  }

  // Lấy dữ liệu tài nguyên từ API
  Future<void> _fetchResourceData() async {
    List<ListEventResourceModel>? listEvent =
        await _apiProvider.getListEventResource(User.token.toString());

    if (listEvent != null) {
      setState(() {
        dataListResource.clear();
        // Lọc và chuyển đổi dữ liệu cho tài nguyên (group == 1)
        dataListResource
            .addAll(listEvent.where((item) => item.group == 1).map((item) {
          return {
            'id': item.id.toString(),
            'resource': item.name ?? '',
            'description': item.description ?? '',
          };
        }).toList());
        _filteredDataListResource = List.from(dataListResource);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Lọc tài nguyên theo từ khóa tìm kiếm
  void _filterResource() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredDataListResource = dataListResource;
      } else {
        _filteredDataListResource = dataListResource.where((item) {
          final resource = item['resource']?.toLowerCase() ?? '';
          return resource.contains(query);
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
          onPressed: () {
            // Trả về danh sách các item đã chọn
            List<Map<String, String>> selectedItems = _filteredDataListResource
                .where((item) => _selectedResourceIds.contains(item['id']))
                .toList();
            widget.onItemSelectedResource(selectedItems);
            Navigator.of(context).pop();
          },
        ),
        title: Text('Chọn tài nguyên'),
        backgroundColor: Colors.blue,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(child: _buildResourceList()),
          ],
        ),
      ),
    );
  }

  // Widget thanh tìm kiếm
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm tài nguyên',
          prefixIcon: Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterResource();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onChanged: (value) => _filterResource(),
      ),
    );
  }

  // Widget danh sách tài nguyên
  Widget _buildResourceList() {
    return ListView.builder(
      itemCount: _filteredDataListResource.length,
      itemBuilder: (context, index) {
        final data = _filteredDataListResource[index];
        final isSelected = _selectedResourceIds.contains(data['id']);

        return Card(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text(
              data['resource'] ?? '',
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text(data['description'] ?? ''),
            trailing: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (isSelected) {
                    // Hủy chọn
                    _selectedResourceIds.remove(data['id']);
                  } else {
                    // Chọn mới
                    _selectedResourceIds.add(data['id'] ?? '');
                  }
                });
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
