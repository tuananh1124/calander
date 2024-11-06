import 'package:flutter/material.dart';
import 'package:flutter_calendar/models/create_event_resource_model.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/network/api_service.dart';
import 'package:flutter_calendar/pages/login/compoments/my_button.dart';
import 'package:flutter_calendar/pages/login/compoments/my_textfield.dart';

class AddResourcePage extends StatefulWidget {
  final String calendarType; // Add calendar type parameter

  const AddResourcePage({
    Key? key,
    required this.calendarType, // Make it required
  }) : super(key: key);

  @override
  State<AddResourcePage> createState() => _AddResourcePageState();
}

class _AddResourcePageState extends State<AddResourcePage> {
  TextEditingController tainguyenController = TextEditingController();
  TextEditingController ghichuController = TextEditingController();
  final ApiProvider _apiProvider = ApiProvider();

  @override
  void dispose() {
    tainguyenController.dispose();
    ghichuController.dispose();
    super.dispose();
  }

  Future<void> createEventResource() async {
    if (!mounted) return;

    String name = tainguyenController.text;
    String description = ghichuController.text;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập tên tài nguyên')),
      );
      return;
    }

    int group = 1;
    String type = widget.calendarType; // Use the calendar type from widget
    String organizationId = "605b064ad9b8222a8db47eb8";
    String token = User.token.toString();

    try {
      CreateEventResourceModel? result;

      // Check calendar type and call appropriate API
      if (widget.calendarType == 'organization') {
        result = await _apiProvider.createEventResource(
          name,
          description,
          group,
          type,
          organizationId,
          token,
        );
      } else {
        result = await _apiProvider.createEventResource_Personal(
          name,
          description,
          group,
          type,
          organizationId,
          token,
        );
      }

      if (!mounted) return;

      if (result != null) {
        print("Tạo tài nguyên thành công:");
        print("Tên: ${result.name}");
        print("Mô tả: ${result.description}");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tạo tài nguyên thành công')),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tạo tài nguyên thất bại')),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra: $e')),
      );
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
            title: Text(
              widget.calendarType == 'organization'
                  ? 'Thêm tài nguyên đơn vị'
                  : 'Thêm tài nguyên cá nhân',
              style: TextStyle(color: Colors.white, fontSize: 20),
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
                        controller: tainguyenController,
                        placeHolder: 'Tên tài nguyên',
                        icon: Icons.not_listed_location_sharp,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
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
                        onTap: createEventResource,
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
