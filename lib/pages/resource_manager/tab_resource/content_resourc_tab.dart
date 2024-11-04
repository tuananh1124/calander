import 'package:flutter/material.dart';
import 'package:flutter_calendar/models/list_event_resource_model.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/network/api_service.dart';

class TabContentResource extends StatefulWidget {
  @override
  _TabContentResourceState createState() => _TabContentResourceState();
}

class _TabContentResourceState extends State<TabContentResource>
    with AutomaticKeepAliveClientMixin {
  String? _selectedResource;
  List<Map<String, String>> _filteredDataListResource = [];
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
        _filteredDataListResource = ListEvent.where(
                (item) => item.group == 1) // Filter items where group == 0
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
                  itemCount: _filteredDataListResource.length,
                  itemBuilder: (context, index) {
                    final data = _filteredDataListResource[index];
                    final isSelected = data['name'] == _selectedResource;

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
                              onPressed: () {},
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedResource = null;
                                  } else {
                                    _selectedResource = data['description'];
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
                // Handle add button press
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
