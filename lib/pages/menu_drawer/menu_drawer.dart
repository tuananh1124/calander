import 'package:flutter/material.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/models/type_calendar_model.dart';
import 'package:flutter_calendar/network/api_service.dart';
import 'package:flutter_calendar/pages/login/logintab.dart';

class CustomDrawer extends StatefulWidget {
  static String selectedCalendarType = 'unit';
  final Function(String) onCalendarTypeChanged;

  const CustomDrawer({Key? key, required this.onCalendarTypeChanged})
      : super(key: key);
// Thêm biến static
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final ApiProvider _apiProvider = ApiProvider();
  List<TypeCalendarModel>?
      _typeCalendarList; // Thêm biến lưu trữ danh sách loại lịch

  @override
  void initState() {
    super.initState();
    getTypeCalendarAPI();
  }

  Future<void> getTypeCalendarAPI() async {
    _typeCalendarList = await _apiProvider.getType(User.token.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white, // Thêm màu nền trắng cho Drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Drawer Header with User Info
            Container(
              constraints: BoxConstraints(
                minHeight: 140,
              ),
              color: Colors.blue,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            AssetImage('assets/images/profile.png'),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '${User.fullName ?? 'Chưa đăng nhập'}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Drawer ListTiles
            Column(
              children: [
                ListTile(
                  leading: Icon(Icons.calendar_today, color: Colors.blue),
                  title: Text(
                    'Lịch công tác',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  tileColor: Colors.blue[100],
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                if (_typeCalendarList != null && _typeCalendarList!.isNotEmpty)
                  ListTile(
                    leading: Icon(Icons.apartment, color: Colors.blue),
                    title: Text(
                      _typeCalendarList![0].name ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                    tileColor: Colors.white,
                    onTap: () {
                      widget.onCalendarTypeChanged('unit');
                      Navigator.pop(context);
                    },
                  ),
                if (_typeCalendarList != null && _typeCalendarList!.isNotEmpty)
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.blue),
                    title: Text(
                      _typeCalendarList![1].name ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                    tileColor: Colors.white,
                    onTap: () {
                      widget.onCalendarTypeChanged('personal');
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),

            // Login/Logout Tile
            ListTile(
              title: Text(
                User.fullName == null ? 'Đăng nhập' : 'Đăng xuất',
                style: TextStyle(color: Colors.black),
              ),
              tileColor: Colors.white,
              onTap: () {
                if (User.fullName == null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                } else {
                  User.fullName = null; // Clear the user information
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
