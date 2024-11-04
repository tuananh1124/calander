import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/components/animation_page.dart';
import 'package:flutter_calendar/components/list_user/user_list.dart';

class UserItem extends StatefulWidget {
  final String title;

  const UserItem({super.key, required this.title});

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isExpanded = false;

  List<Map<String, String>> _items = []; // Danh sách các mục
  List<Map<String, String>> _selectedEmployees = [];
  Map<String, Map<String, bool>> _selectedEmployeesState = {};
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

  void _showMyList() {
    Navigator.of(context)
        .push(
      SlideFromRightPageRoute(
        page: UserList(
          onEmployeesSelected: (employees) {
            setState(() {
              _selectedEmployees = employees;
              _items = employees;
            });
          },
          initialSelectedEmployees: _selectedEmployeesState,
          previouslySelectedEmployees:
              _items, // Truyền danh sách đã chọn trước đó
        ),
      ),
    )
        .then((value) {
      setState(() {});
    });
  }

  void _updateSelectedState(Map<String, Map<String, bool>> newState) {
    setState(() {
      _selectedEmployeesState = newState;
    });
  }

  // Hàm để hiển thị danh sách chi tiết
  void _showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Danh sách người đã thêm'),
          content: _items.isEmpty
              ? Text('Chưa có người nào được thêm vào.') // Nếu danh sách rỗng
              : Container(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _items.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = _items[index];
                      return ListTile(
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${item['fullName']} ',
                              style: TextStyle(
                                  fontSize: 14), // Giảm kích thước chữ
                            ),
                            // Thêm khoảng cách giữa các mục
                          ],
                        ),
                      );
                    },
                  ),
                ),
          actions: [
            TextButton(
              child: Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                                          widget.title,
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
                                    // Hiển thị danh sách các mục hoặc thông báo không có người tham dự
                                    if (_selectedEmployees.isEmpty)
                                      Text(
                                        'Không có người tham dự',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      )
                                    else ...[
                                      ..._selectedEmployees.take(3).map(
                                          (employee) => buildDetailRow(
                                              employee['fullName'] ?? '')),
                                      if (_selectedEmployees.length > 3)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              '${_selectedEmployees.length - 3}+',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                    ],
                                    SizedBox(height: 20),
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
                                              onTap:
                                                  _showMyList, // Use the new method here
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.add,
                                                        color: Colors.white,
                                                        size: 15),
                                                    Text('Thêm',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Material(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              onTap: () {
                                                _showDetailsDialog(
                                                    context); // Hiển thị chi tiết
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
                                                      Icons.remove_red_eye,
                                                      color: Colors.white,
                                                      size: 15,
                                                    ),
                                                    Text(
                                                      'Xem',
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

  Widget buildDetailRow(String fullName) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$fullName',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
