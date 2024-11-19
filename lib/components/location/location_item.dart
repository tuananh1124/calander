import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/components/animation_page.dart';
import 'package:flutter_calendar/components/location/location_list.dart';

class LocationItem extends StatefulWidget {
  final String location;
  final String calendarType;
  final Function(Map<String, String>)? onLocationSelected;

  const LocationItem({
    super.key,
    required this.location,
    required this.calendarType,
    this.onLocationSelected,
  });

  @override
  State<LocationItem> createState() => _LocationItemState();
}

class _LocationItemState extends State<LocationItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isExpanded = false;

  Map<String, String> _selectedLocation = {};
  List<Map<String, String>> _itemsLocation = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _onItemSelectedLocation(Map<String, String>? locationData) {
    setState(() {
      if (locationData == null) {
        _selectedLocation = {};
        _itemsLocation = [];
      } else {
        _selectedLocation = locationData;
        _itemsLocation = [locationData];
      }
    });

    // Debug print để kiểm tra dữ liệu địa điểm
    print('Selected Location Data: $_selectedLocation');

    // Notify parent through callback
    if (widget.onLocationSelected != null && locationData != null) {
      widget.onLocationSelected!(locationData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _isExpanded
              ? Colors.blue.withOpacity(1)
              : Colors.blue.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: GestureDetector(
        onTap: _toggleExpansion,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Card(
                margin: EdgeInsets.zero,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: _isExpanded ? Color(0XFC4DFF6FF) : Colors.white,
                      child: ListTile(
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        title: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: AutoSizeText(
                                          widget.location,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 5,
                                          minFontSize: 14,
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            SizeTransition(
                              sizeFactor: _animation,
                              axisAlignment: -1.0,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (_itemsLocation.isEmpty)
                                      Text(
                                        'Chưa chọn địa điểm',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      )
                                    else
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          buildDetailRow(
                                              "${_selectedLocation['location'] ?? ''} ${_selectedLocation['description']?.isNotEmpty ?? false ? "- ${_selectedLocation['description']}" : ''}"),
                                        ],
                                      ),
                                    SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Material(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  SlideFromRightPageRoute(
                                                    page: LocationList(
                                                      onItemSelectedLocation:
                                                          _onItemSelectedLocation,
                                                      selectedLocationId:
                                                          _selectedLocation[
                                                              'id'],
                                                      calendarType: widget
                                                          .calendarType, // Truyền calendarType
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                      size: 15,
                                                    ),
                                                    Text(
                                                      'Thêm',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

// Define this method to handle location updates
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: -15,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: IconButton(
                      icon: Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.blue,
                      ),
                      onPressed: _toggleExpansion,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDetailRow(String location) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.location_on, size: 16, color: Colors.blue),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              location,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
