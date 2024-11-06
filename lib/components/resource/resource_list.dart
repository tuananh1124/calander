import 'package:flutter/material.dart';
import 'package:flutter_calendar/models/list_event_resource_model.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/network/api_service.dart';

class ResourceList extends StatefulWidget {
  final Function(List<Map<String, String>>) onItemSelectedResource;
  final List<String> selectedResourceIds;
  final String calendarType; // Thêm property này

  const ResourceList({
    Key? key,
    required this.onItemSelectedResource,
    required this.selectedResourceIds,
    required this.calendarType, // Thêm parameter này
  }) : super(key: key);

  @override
  State<ResourceList> createState() => _ResourceListState();
}

class _ResourceListState extends State<ResourceList> {
  final List<Map<String, String>> dataListResource = [];
  final ApiProvider _apiProvider = ApiProvider();
  List<String> _selectedResourceIds = [];
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

      print('List Event: $listEvent'); // Debug print

      if (listEvent != null) {
        final filteredList = listEvent.where((item) {
          print('Item group: ${item.group}'); // Debug print
          return item.group != null && item.group == 1;
        }).toList();

        print('Filtered List: $filteredList'); // Debug print

        setState(() {
          dataListResource.clear();
          dataListResource.addAll(
            filteredList
                .map((item) => {
                      'id': item.id ?? '',
                      'resource': item.name ?? '',
                      'description': item.description ?? '',
                    })
                .toList(),
          );
          _filteredDataListResource = List.from(dataListResource);
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
            List<Map<String, String>> selectedItems = _filteredDataListResource
                .where((item) => _selectedResourceIds.contains(item['id']))
                .toList();
            widget.onItemSelectedResource(selectedItems);
            Navigator.of(context).pop();
          },
        ),
        title: Text(widget.calendarType == 'organization'
            ? 'Chọn tài nguyên đơn vị'
            : 'Chọn tài nguyên cá nhân'),
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
                    _selectedResourceIds.remove(data['id']);
                  } else {
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
