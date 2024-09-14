import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart'; // Import file_picker package

//TabContentAddTask
class TabContentAddTask extends StatefulWidget {
  @override
  _TabContentAddTaskState createState() => _TabContentAddTaskState();
}

class _TabContentAddTaskState extends State<TabContentAddTask>
    with AutomaticKeepAliveClientMixin {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  String _selectedPeriod = 'Chiều';
  String _selectedColor = 'green';
  String? _selectedFile; // Biến lưu tên tệp đã chọn

  @override
  bool get wantKeepAlive => true;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;

      setState(() {
        _selectedFile = file.name; // Lưu tên tệp đã chọn
      });

      print('File selected: ${file.name}');
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context)
              .unfocus(); // Tắt bàn phím khi bấm vào khoảng trắng
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                controller: _dateController,
                readOnly: true, // Ngăn bàn phím xuất hiện
                decoration: InputDecoration(
                  labelText: 'Ngày',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dateController.text =
                          DateFormat('dd/MM/yyyy').format(pickedDate);
                    });
                  }
                },
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: DropdownButtonFormField<String>(
                  value: _selectedPeriod,
                  decoration: InputDecoration(
                    labelText: 'Buổi',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPeriod = newValue!;
                    });
                  },
                  items: ['Sáng', 'Chiều']
                      .map((period) => DropdownMenuItem(
                            child: Text(period),
                            value: period,
                          ))
                      .toList(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _timeController,
                readOnly: true, // Ngăn bàn phím xuất hiện
                decoration: InputDecoration(
                  labelText: 'Giờ',
                  prefixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _timeController.text = pickedTime.format(context);
                    });
                  }
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: _contentController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Nội dung',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: 'Ghi chú',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Màu sắc:'),
                  SizedBox(width: 10),
                  ...['green', 'red', 'blue', 'purple', 'brown']
                      .map(
                        (color) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColor = color;
                            });
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: Colors.primaries[[
                                'green',
                                'red',
                                'blue',
                                'purple',
                                'brown'
                              ].indexOf(color)],
                              border: _selectedColor == color
                                  ? Border.all(color: Colors.black, width: 2)
                                  : null,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _pickFile, // Chọn tệp khi nhấn vào nút
                      child: Text(
                        'Chọn tệp',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _selectedFile != null
                          ? 'Đã chọn: $_selectedFile'
                          : 'Chưa chọn tệp',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        // Handle submit
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Lưu',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
