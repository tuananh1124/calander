import 'package:flutter/material.dart';
import 'package:flutter_calendar/models/create_event_resource_model.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/network/api_service.dart';
import 'package:flutter_calendar/pages/login/compoments/my_button.dart';
import 'package:flutter_calendar/pages/login/compoments/my_textfield.dart';

class AddLocationPage extends StatefulWidget {
  final String calendarType; // Thêm tham số này

  const AddLocationPage({
    Key? key,
    required this.calendarType,
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
    // Chỉ cần dispose các controller
    diadiemController.dispose();
    ghichuController.dispose();
    super.dispose();
  }

  Future<void> createEventResource() async {
    if (!mounted) return;

    String name = diadiemController.text;
    String description = ghichuController.text;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập tên vị trí')),
      );
      return;
    }

    int group = 0;
    String type = widget.calendarType; // Sử dụng calendarType được truyền vào
    String organizationId = "605b064ad9b8222a8db47eb8";
    String token = User.token.toString();

    try {
      CreateEventResourceModel? result;

      // Kiểm tra loại lịch và gọi API tương ứng
      if (widget.calendarType == 'organization') {
        result = await _apiProvider.createEventResource(
            name, description, group, type, organizationId, token);
      } else {
        result = await _apiProvider.createEventResource_Personal(
            name, description, group, type, organizationId, token);
      }

      if (!mounted) return;

      if (result != null) {
        print("Tạo địa điểm thành công:");
        print("Tên: ${result.name}");
        print("Mô tả: ${result.description}");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tạo địa điểm thành công')),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tạo địa điểm thất bại')),
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
                  ? 'Thêm địa điểm đơn vị'
                  : 'Thêm địa điểm cá nhân',
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
                        controller: diadiemController,
                        placeHolder: 'Tên vị trí',
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
