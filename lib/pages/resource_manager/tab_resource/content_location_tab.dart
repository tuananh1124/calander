import 'package:flutter/material.dart';
import 'package:flutter_calendar/components/animation_page.dart';
import 'package:flutter_calendar/models/list_event_resource_model.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/network/api_service.dart';
import 'package:flutter_calendar/pages/resource_manager/add_page_location/add_location_page.dart';

class TabContentLocation extends StatefulWidget {
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

  Future<void> ListEventResource() async {
    List<ListEventResourceModel>? ListEvent =
        await _apiProvider.getListEventResource(User.token.toString());

    if (ListEvent != null) {
      setState(() {
        _filteredDataListLocation = ListEvent.where(
                (item) => item.group == 0) // Filter items where group == 0
            .map((item) {
          return {
            'name': item.name ?? '',
            'description': item.description ?? '',
          };
        }).toList();
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

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
                child: ListView.builder(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${data['name']} - ${data['description']}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // Handle edit action
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedLocation = null;
                                  } else {
                                    _selectedLocation = data['description'];
                                  }
                                });
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
              onPressed: () {
                Navigator.push(
                  context,
                  SlideFromRightPageRoute(
                    page:
                        AddLocationPage(), // Thay editPage() bằng trang cần chuyển tới
                  ),
                );
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
