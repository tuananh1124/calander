import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/components/animation_page.dart';
import 'package:flutter_calendar/components/resource/resource_list.dart';

class ResourceItem extends StatefulWidget {
  final String resource;
  final String calendarType;
  final Function(List<Map<String, String>>)? onResourcesSelected;

  const ResourceItem({
    super.key,
    required this.resource,
    required this.calendarType,
    this.onResourcesSelected,
  });

  @override
  State<ResourceItem> createState() => _ResourceItemState();
}

class _ResourceItemState extends State<ResourceItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isExpanded = false;
  List<Map<String, String>> _selectedResources = [];

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

  void _onItemSelectedResource(List<Map<String, String>> resources) {
    setState(() {
      _selectedResources = resources;
    });

    // Chuyển đổi format dữ liệu trước khi gửi lên
    List<Map<String, String>> formattedResources = resources
        .map((resource) => {
              'id': resource['id'] ?? '',
              'resource': resource['resource'] ?? '',
              'description': resource['description'] ?? ''
            })
        .toList();

    // Notify parent through callback
    if (widget.onResourcesSelected != null) {
      widget.onResourcesSelected!(formattedResources);
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
                              child: AutoSizeText(
                                widget.resource,
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
                                    _buildSelectedResources(),
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
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ResourceList(
                                                      onItemSelectedResource:
                                                          _onItemSelectedResource,
                                                      selectedResourceIds:
                                                          _selectedResources
                                                              .map((resource) =>
                                                                  resource[
                                                                      'id'] ??
                                                                  '')
                                                              .toList(),
                                                      calendarType: widget
                                                          .calendarType, // Sử dụng widget.calendarType
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
                  child: IconButton(
                    icon: Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.blue,
                    ),
                    onPressed: _toggleExpansion,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Thay thế hàm _buildSelectedResources() cũ bằng hàm mới này:

  Widget _buildSelectedResources() {
    if (_selectedResources.isEmpty) {
      return Text(
        'Chưa chọn tài nguyên',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _selectedResources.map((resource) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: buildDetailRow(
              "${resource['resource'] ?? ''} ${resource['description']?.isNotEmpty ?? false ? "- ${resource['description']}" : ''}"),
        );
      }).toList(),
    );
  }

  Widget buildDetailRow(String resource) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.inventory_2, size: 16, color: Colors.blue),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              resource,
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
