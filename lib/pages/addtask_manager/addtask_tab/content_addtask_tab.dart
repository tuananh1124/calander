import 'package:flutter/material.dart';
import 'package:flutter_calendar/models/color_model.dart';
import 'package:flutter_calendar/models/create_event_calendar_model.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/network/api_service.dart';
import 'package:flutter_calendar/pages/addtask_manager/addtask_tab/time_picker.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart'; // Import file_picker package
import 'package:flutter/material.dart';

class TabContentAddTask extends StatefulWidget {
  final List<Map<String, String>> selectedHosts;
  final List<Map<String, String>> selectedAttendees;
  final List<Map<String, String>> selectedRequiredAttendees;
  final Map<String, String> selectedLocation;
  final List<Map<String, String>> selectedResources;
  final bool isOrganization;
  final VoidCallback? onEventCreated; // Thêm callbac
  const TabContentAddTask({
    Key? key,
    required this.selectedHosts,
    required this.selectedAttendees,
    required this.selectedRequiredAttendees,
    required this.selectedLocation,
    required this.selectedResources,
    required this.isOrganization,
    this.onEventCreated, // Thêm parameter này
  }) : super(key: key);

  @override
  _TabContentAddTaskState createState() => _TabContentAddTaskState();
}

class _TabContentAddTaskState extends State<TabContentAddTask>
    with AutomaticKeepAliveClientMixin {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeStartController = TextEditingController();
  TextEditingController _timeEndController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  String _selectedPeriod = 'Chiều';
  String? _selectedColor;
  String? _selectedFile;
  final ApiProvider _apiProvider = ApiProvider();
  ColorModel? colorModelList;

  @override
  void initState() {
    super.initState();
    colorsAPI();
  }

  void _handleSave() async {
    List<String> allResources = [];
    if (widget.selectedLocation.isNotEmpty &&
        widget.selectedLocation['id'] != null) {
      allResources.add(widget.selectedLocation['id']!);
    }

    allResources.addAll(widget.selectedResources
        .where((resource) => resource['id'] != null)
        .map((resource) => resource['id']!));

    int? fromTimestamp;
    int? toTimestamp;

    if (_dateController.text.isNotEmpty) {
      DateTime selectedDate =
          DateFormat('dd/MM/yyyy').parse(_dateController.text);

      if (_timeStartController.text.isNotEmpty) {
        TimeOfDay startTime = TimeOfDay.fromDateTime(
            DateFormat('hh:mm a').parse(_timeStartController.text));
        DateTime startDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          startTime.hour,
          startTime.minute,
        );
        fromTimestamp = startDateTime.millisecondsSinceEpoch;
      } else {
        fromTimestamp = selectedDate.millisecondsSinceEpoch;
      }

      if (_timeEndController.text.isNotEmpty) {
        TimeOfDay endTime = TimeOfDay.fromDateTime(
            DateFormat('hh:mm a').parse(_timeEndController.text));
        DateTime endDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          endTime.hour,
          endTime.minute,
        );
        toTimestamp = endDateTime.millisecondsSinceEpoch;
      }
    }

    CreateEventCalendarModel eventModel = CreateEventCalendarModel(
      from: fromTimestamp,
      to: toTimestamp,
      type: widget.isOrganization ? 'organization' : 'personal',
      content: _contentController.text,
      notes: _noteController.text.isNotEmpty ? _noteController.text : null,
      color: _selectedColor,
      organizationId: "605b064ad9b8222a8db47eb8",
      resources: allResources,
      attachments: _selectedFile != null ? [_selectedFile!] : [],
      hosts: widget.selectedHosts
          .map((host) => AttendeeModel(
                userId: host['userId'] ?? '', // Đảm bảo userId không trống
                fullName: host['fullName'] ?? '',
                jobTitle: host['jobTitle'] ?? '',
                organizationId:
                    host['organizationId'] ?? '605b064ad9b8222a8db47eb8',
                organizationName:
                    host['organizationName'] ?? 'VĂN PHÒNG TRUNG ƯƠNG ĐẢNG',
              ))
          .toList(),
      attendeesRequired: widget.selectedRequiredAttendees
          .map((attendee) => AttendeeModel(
                userId: attendee['userId'] ?? '', // Đảm bảo userId không trống
                fullName: attendee['fullName'] ?? '',
                jobTitle: attendee['jobTitle'] ?? '',
                organizationId:
                    attendee['organizationId'] ?? '605b064ad9b8222a8db47eb8',
                organizationName:
                    attendee['organizationName'] ?? 'VĂN PHÒNG TRUNG ƯƠNG ĐẢNG',
              ))
          .toList(),
      attendeesNoRequired: widget.selectedAttendees
          .map((attendee) => AttendeeModel(
                userId: attendee['userId'] ?? '', // Đảm bảo userId không trống
                fullName: attendee['fullName'] ?? '',
                jobTitle: attendee['jobTitle'] ?? '',
                organizationId:
                    attendee['organizationId'] ?? '605b064ad9b8222a8db47eb8',
                organizationName:
                    attendee['organizationName'] ?? 'VĂN PHÒNG TRUNG ƯƠNG ĐẢNG',
              ))
          .toList(),
    );

    // In ra để debug
    print('Event Model Data:');
    // print(eventModel.toJson());

    try {
      final result = widget.isOrganization
          ? await _apiProvider.createEventCalendar(
              User.token.toString(), eventModel)
          : await _apiProvider.createEventCalendarForPersonal(
              User.token.toString(), eventModel);

      if (result != null) {
        // Gọi callback trước khi đóng dialog
        if (widget.onEventCreated != null) {
          widget.onEventCreated!();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tạo lịch thành công')),
        );

        Navigator.pop(context, true); // Trả về true để báo tạo thành công
      }
    } catch (e) {
      print('Error creating event: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra: $e')),
      );
    }
  }

  Future<void> colorsAPI() async {
    ColorModel? fetchedColorModel =
        await _apiProvider.getColor(User.token.toString());
    setState(() {
      colorModelList = fetchedColorModel;
    });
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        _selectedFile = file.name; // Lưu tên file
      });
      print('File selected: ${file.name}');
    }
  }

  List<String> getColorsFromModel(ColorModel colorModel) {
    List<String> colorList = [];
    if (colorModel.color1 != null) colorList.add(colorModel.color1!);
    if (colorModel.color2 != null) colorList.add(colorModel.color2!);
    if (colorModel.color3 != null) colorList.add(colorModel.color3!);
    if (colorModel.color4 != null) colorList.add(colorModel.color4!);
    if (colorModel.color5 != null) colorList.add(colorModel.color5!);
    if (colorModel.color6 != null) colorList.add(colorModel.color6!);
    return colorList;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss keyboard on tap
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                controller: _dateController,
                readOnly: true, // Prevent keyboard from appearing
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
                controller: _timeStartController,
                readOnly: true, // Prevent keyboard from appearing
                decoration: InputDecoration(
                  labelText: 'Giờ bắt đầu',
                  prefixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CustomTimePicker(
                        initialTime: TimeOfDay.now(), // Pass current time
                        onTimeSelected: (TimeOfDay selectedTime) {
                          setState(() {
                            _timeStartController.text =
                                selectedTime.format(context);
                          });
                        },
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _timeEndController,
                readOnly: true, // Prevent keyboard from appearing
                decoration: InputDecoration(
                  labelText: 'Giờ kết thúc',
                  prefixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CustomTimePicker(
                        initialTime: TimeOfDay.now(), // Pass current time
                        onTimeSelected: (TimeOfDay selectedTime) {
                          setState(() {
                            _timeEndController.text =
                                selectedTime.format(context);
                          });
                        },
                      );
                    },
                  );
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
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (colorModelList != null) ...[
                            ...List.generate(
                              getColorsFromModel(colorModelList!).length,
                              (index) {
                                final colorHex =
                                    getColorsFromModel(colorModelList!)[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 1.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(
                                        int.parse(
                                            colorHex.replaceAll('#', '0xff')),
                                      ),
                                      shape: CircleBorder(
                                        side: BorderSide(),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _selectedColor = colorHex;
                                      });
                                    },
                                    child: null,
                                  ),
                                );
                              },
                            ),
                          ] else ...[
                            SizedBox.shrink(),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _pickFile, // Choose file on button press
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
                      onPressed: _handleSave,
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
