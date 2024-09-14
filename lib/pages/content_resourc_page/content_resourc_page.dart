import 'package:flutter/material.dart';

class TabContentResource extends StatefulWidget {
  @override
  _TabContentResourceState createState() => _TabContentResourceState();
}

class _TabContentResourceState extends State<TabContentResource>
    with AutomaticKeepAliveClientMixin {
  String? _selectedResource;
  List<Map<String, String>> _filteredDataListResource = [];
  final List<Map<String, String>> dataListResource = [
    {'resource': 'Cà phê'},
    {'resource': 'Trái cây'},
    {'resource': 'Trà sữa'},
    // Thêm các phần tử khác...
  ];

  @override
  void initState() {
    super.initState();
    _filteredDataListResource = dataListResource;
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
                    final isSelected = data['resource'] == _selectedResource;

                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey, // Màu xám cho viền dưới
                            width: 1.0, // Độ dày của viền
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
                                data['resource'] ?? '',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.edit, // Biểu tượng xóa
                                color: Colors.blue, // Màu của biểu tượng
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedResource = null;
                                  } else {
                                    _selectedResource = data['resource'];
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.delete, // Biểu tượng xóa
                                color: Colors.red, // Màu của biểu tượng
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
            // Căn giữa theo chiều ngang, nhưng ở phía dưới cùng
            child: ElevatedButton(
              onPressed: () {
                // Xử lý khi nhấn nút "Thêm"
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(15),
                shape: CircleBorder(), // Đặt hình dạng nút thành hình tròn
                backgroundColor: Colors.blue, // Màu nền của nút
              ),
              child: Icon(
                Icons.add, // Icon dấu cộng
                color: Colors.white, // Màu của biểu tượng
                size: 30, // Kích thước của biểu tượng
              ),
            ),
          ),
        ),
      ],
    );
  }
}
