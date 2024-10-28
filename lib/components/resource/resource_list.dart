import 'package:flutter/material.dart';
import 'package:flutter_calendar/models/list_event_resource_model.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/network/api_service.dart';

class ResourceList extends StatefulWidget {
  final Function(String resource) onItemSelectedResource;

  ResourceList({required this.onItemSelectedResource});

  @override
  State<ResourceList> createState() => _ResourceListState();
}

class _ResourceListState extends State<ResourceList> {
  final List<Map<String, String>> dataListResource = [];
  String? _selectedGroup;
  String? _selectedResource;
  List<Map<String, String>> _filteredDataListResource = [];
  final TextEditingController _searchController = TextEditingController();
  final ApiProvider _apiProvider = ApiProvider();

  @override
  void initState() {
    super.initState();
    _filteredDataListResource = dataListResource;
    _searchController.addListener(_filterResource);
    _fetchResourceData(); // Fetch data when the widget initializes
  }

  Future<void> _fetchResourceData() async {
    List<ListEventResourceModel>? listEvent =
        await _apiProvider.getListEventResource(User.token.toString());

    if (listEvent != null) {
      setState(() {
        _filteredDataListResource =
            listEvent.where((item) => item.group == 1).map((item) {
          return {
            'id': item.id ?? '',
            'resource': item.name ?? '',
            'description': item.description ?? '',
          };
        }).toList();
      });
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
      _filteredDataListResource = dataListResource.where((item) {
        final resource = item['resource']?.toLowerCase() ?? '';
        return resource.contains(query) &&
            (_selectedGroup == null ||
                item['group']?.toLowerCase() == _selectedGroup?.toLowerCase());
      }).toList();
    });
  }

  void _onGroupSelected(String? group) {
    setState(() {
      _selectedGroup = group;
      _filterResource();
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
        title: Text('Chọn tài nguyên'),
        backgroundColor: Colors.blue,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss the keyboard
        },
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildResourceList() {
    return ListView.builder(
      itemCount: _filteredDataListResource.length,
      itemBuilder: (context, index) {
        final data = _filteredDataListResource[index];
        final isSelected = data['resource'] == _selectedResource;

        return ListTile(
          title: Text(data['resource'] ?? ''),
          trailing: ElevatedButton(
            onPressed: () {
              setState(() {
                if (isSelected) {
                  _selectedResource = null;
                } else {
                  _selectedResource = data['resource'];
                  widget.onItemSelectedResource(data['resource'] ?? '');
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
