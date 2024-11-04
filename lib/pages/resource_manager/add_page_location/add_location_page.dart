import 'package:flutter/material.dart';
import 'package:flutter_calendar/models/create_event_resource_model.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/network/api_service.dart';
import 'package:flutter_calendar/pages/login/compoments/my_button.dart';
import 'package:flutter_calendar/pages/login/compoments/my_textfield.dart';

class AddLocationPage extends StatefulWidget {
  const AddLocationPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  TextEditingController diadiemController = TextEditingController();
  TextEditingController ghichuController = TextEditingController();
  final ApiProvider _apiProvider = ApiProvider();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    createEventResource();
  }

  Future<void> createEventResource() async {
    String name = "abc";
    String description = "abc";
    int group = 0;
    String type = ""; // Giá trị cho trường type
    String organizationId = ""; // Giá trị cho trường organizationId

    String token = User.token.toString();

    CreateEventResourceModel? createEvent =
        await _apiProvider.createEventResource(
      name,
      description,
      group,
      type,
      organizationId,
      token,
    );

    if (createEvent != null) {
      print("Event created successfully: ${createEvent.name}");
    } else {
      print("Failed to create event");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_outlined,
                  color: Colors.white, size: 16),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Container(
              child: Text(
                'Thêm địa điểm',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: MyTextfield(
                        controller: diadiemController,
                        placeHolder: 'Tên vị trí',
                        icon: Icons.not_listed_location_sharp,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10), // Thêm khoảng cách giữa các ô nhập
                Row(
                  children: [
                    Expanded(
                      child: MyTextfield(
                        controller: ghichuController,
                        placeHolder: 'Ghi chú',
                        icon: Icons.info_outline_rounded,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: MyButton(
                        fontsize: 20,
                        paddingText: 10,
                        text: 'Lưu',
                        onTap: () {}, // Gọi hàm _submitShift
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
