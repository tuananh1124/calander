import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
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
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'NguyenTuanAnh',
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
          ListTile(
            title: Text('VĂN PHÒNG TRUNG ƯƠNG ĐẢNG'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Đăng xuất'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
