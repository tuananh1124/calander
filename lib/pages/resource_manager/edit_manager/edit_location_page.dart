import 'package:flutter/material.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/network/api_service.dart';
import 'package:flutter_calendar/pages/compoments/my_button.dart';
import 'package:flutter_calendar/pages/compoments/my_textfield.dart';


// edit_location_page.dart
class EditLocationPage extends StatefulWidget {
  final String id;
  final String name;
  final String description;

  EditLocationPage({
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  _EditLocationPageState createState() => _EditLocationPageState();
}

class _EditLocationPageState extends State<EditLocationPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  final ApiProvider _apiProvider = ApiProvider();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _descriptionController = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateLocation() async {
    if (_nameController.text.isEmpty) {
      setState(() {
        // Để hiển thị lỗi
      });
      return;
    }
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final result = await _apiProvider.updateEventResource(
          id: widget.id,
          name: _nameController.text,
          description: _descriptionController.text,
          token: User.token.toString(),
        );

        setState(() {
          _isLoading = false;
        });

        if (result != null) {
          Navigator.pop(context, true); // Trả về true để refresh list
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cập nhật thất bại')),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Có lỗi xảy ra: $e')),
        );
      }
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
              'Chỉnh sửa địa điểm',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: MyTextfield(
                          controller: _nameController,
                          placeHolder: 'Tên vị trí',
                          icon: Icons.not_listed_location_sharp,
                          errorMessage: _nameController.text.isEmpty
                              ? 'Vui lòng nhập tên địa điểm'
                              : null,
                          onChanged: (value) {
                            setState(() {
                              // Trigger rebuild để cập nhật errorMessage
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextfield(
                          controller: _descriptionController,
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
                          text: _isLoading ? 'Đang cập nhật...' : 'Cập nhật',
                          onTap: _isLoading ? null : _updateLocation,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
