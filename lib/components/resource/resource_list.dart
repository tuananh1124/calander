import 'package:flutter/material.dart';

class ResourceList extends StatefulWidget {
  final Function(String resource) onItemSelectedResource;
  ResourceList({required this.onItemSelectedResource});

  @override
  State<ResourceList> createState() => _ResourceListState();
}

class _ResourceListState extends State<ResourceList> {
  final List<Map<String, dynamic>> dataListResource = [
    {'resource': 'Cà phê', 'group': 'Nhóm A'},
    {'resource': 'Trái cây', 'group': 'Nhóm A'},
    {'resource': 'Trà sữa', 'group': 'Nhóm B'},
    {'resource': 'Nước ngọt', 'group': 'Nhóm B'},
    // Thêm các phần tử khác...
  ];

  String? _selectedGroup;
  String? _selectedResource;
  List<Map<String, dynamic>> _filteredDataListResource = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredDataListResource = dataListResource;

    _searchController.addListener(_filterResource);
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
