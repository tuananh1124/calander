import 'package:flutter/material.dart';
import 'package:flutter_calendar/components/animation_page.dart';
import 'package:flutter_calendar/models/list_event_resource_model.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/network/api_service.dart';
import 'package:flutter_calendar/pages/resource_manager/add_page_manager/add_location_page.dart';
import 'package:flutter_calendar/pages/resource_manager/edit_manager/edit_location_page.dart';

class TabContentLocation extends StatefulWidget {
  final String calendarType;

  const TabContentLocation({
    Key? key,
    required this.calendarType,
  }) : super(key: key);
  @override
  _TabContentLocationState createState() => _TabContentLocationState();
}

class _TabContentLocationState extends State<TabContentLocation>
    with AutomaticKeepAliveClientMixin {
  String? _selectedLocation;
  List<Map<String, String>> _filteredDataListLocation = [];
  final ApiProvider _apiProvider = ApiProvider();

  @override
  void initState() {
    super.initState();
    ListEventResource();
  }

  Future<void> refreshList() async {
    await ListEventResource();
  }

  Future<void> ListEventResource() async {
    List<ListEventResourceModel>? ListEvent;
    String token = User.token.toString();

    try {
      // Fetch data based on calendar type
      ListEvent = widget.calendarType == 'organization'
          ? await _apiProvider.getListEventResource(token)
          : await _apiProvider.getListOfPersonalEventResource(token);

      if (ListEvent != null) {
        // Filter and process the data
        var filteredData =
            ListEvent.where((item) => item.group == 0).map((item) {
          return {
            'id': item.id ?? '',
            'name': item.name ?? '',
            'description': item.description ?? '',
          };
        }).toList();

        if (mounted) {
          setState(() {
            _filteredDataListLocation = filteredData;
          });
        }
      } else {
        // Handle null data case
        if (mounted) {
          _showErrorSnackBar('Không thể tải danh sách địa điểm');
        }
      }
    } catch (e) {
      // Handle error case
      if (mounted) {
        _showErrorSnackBar('Có lỗi xảy ra khi tải danh sách: $e');
        print('Error in ListEventResource: $e');
      }
    }
  }

  // Helper method to show error messages
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _deleteLocation(String id) async {
    try {
      bool success =
          await _apiProvider.deleteEventResource(id, User.token.toString());
      if (success) {
        // Nếu xóa thành công, cập nhật lại danh sách
        await refreshList();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xóa địa điểm thành công')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xóa địa điểm thất bại')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra: $e')),
      );
    }
  }

  void _showDeleteConfirmationDialog(String id, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa địa điểm "$name"?'),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Xóa'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteLocation(id);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: 70,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Chưa có địa điểm nào',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Nhấn nút + để thêm địa điểm mới',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _filteredDataListLocation.isEmpty
                    ? _buildEmptyState() // Hiển thị trạng thái trống
                    : ListView.builder(
                        itemCount: _filteredDataListLocation.length,
                        itemBuilder: (context, index) {
                          final data = _filteredDataListLocation[index];
                          final isSelected = data['name'] == _selectedLocation;

                          return Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${data['name']} - ${data['description']}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  // Trong TabContentLocation
                                  IconButton(
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        SlideFromRightPageRoute(
                                          page: EditLocationPage(
                                            id: data['id']!,
                                            name: data['name']!,
                                            description: data['description']!,
                                          ),
                                        ),
                                      );
                                      if (result == true) {
                                        // Refresh list nếu cập nhật thành công
                                        refreshList();
                                      }
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(
                                        data['id']!,
                                        data['name']!,
                                      );
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  SlideFromRightPageRoute(
                    page: AddLocationPage(
                      calendarType: widget.calendarType,
                    ),
                  ),
                );
                if (result == true) {
                  refreshList();
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(15),
                shape: CircleBorder(),
                backgroundColor: Colors.blue,
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
