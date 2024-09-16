import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ExpandableCard extends StatelessWidget {
  final String nameCreate;
  final String date;
  final String time;
  final String content;
  final String note;
  final String file;
  final String preside;
  final String member;
  final String location;
  final String resources;
  final int? error;
  final VoidCallback onDelete;

  const ExpandableCard({
    Key? key,
    required this.nameCreate,
    required this.date,
    required this.time,
    required this.content,
    required this.note,
    required this.file,
    required this.preside,
    required this.member,
    required this.location,
    required this.resources,
    this.error,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.blue,
        ),
      ),
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.white,
        child: ListTile(
          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          title: _buildTitle(),
          subtitle: _buildSubtitle(context),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: AutoSizeText(
            content,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            minFontSize: 14,
            textAlign: TextAlign.left,
          ),
        ),
        _buildErrorIndicator(),
      ],
    );
  }

  Widget _buildErrorIndicator() {
    Color indicatorColor = Colors.green;
    if (error == 1) {
      indicatorColor = Colors.yellow;
    } else if (error == 2) {
      indicatorColor = Colors.red;
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: indicatorColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(2),
        child: SizedBox(width: 10, height: 10),
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTimeInfo(context),
            _buildDateInfo(context),
            _buildActionButtons(context),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeInfo(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.03; // Tỉ lệ kích thước icon
    final textSize = screenWidth * 0.03; // Tỉ lệ kích thước chữ

    return Row(
      children: [
        Icon(Icons.timer_outlined, color: Colors.grey, size: iconSize),
        // Khoảng cách giữa icon và text
        Text(time, style: TextStyle(color: Colors.grey, fontSize: textSize)),
      ],
    );
  }

  Widget _buildDateInfo(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.03; // Tỉ lệ kích thước icon
    final textSize = screenWidth * 0.03; // Tỉ lệ kích thước chữ

    return Row(
      children: [
        Icon(Icons.date_range, color: Colors.grey, size: iconSize),
        // Khoảng cách giữa icon và text
        Text(date, style: TextStyle(color: Colors.grey, fontSize: textSize)),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth * 0.05; // Tỉ lệ kích thước nút

    return Row(
      children: [
        _buildActionButton(
          color: Colors.blue,
          icon: Icons.edit,
          onTap: () => _showEditBottomSheet(context),
          size: buttonSize,
        ),
        SizedBox(width: 3),
        _buildActionButton(
          color: Colors.green,
          icon: Icons.info,
          onTap: () => _showDetailDialog(context),
          size: buttonSize,
        ),
        SizedBox(width: 3),
        _buildActionButton(
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _showDeleteConfirmation(context),
          size: buttonSize,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
    required double size,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(size * 0.3), // Tỉ lệ bo góc
      child: InkWell(
        borderRadius: BorderRadius.circular(size * 0.3),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size * 0.4, vertical: size * 0.2),
          child: Icon(icon,
              color: Colors.white, size: size * 0.6), // Tỉ lệ kích thước icon
        ),
      ),
    );
  }

  void _showEditBottomSheet(BuildContext context) {
    // Implement your edit bottom sheet logic here
  }

  void _showDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chi tiết'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Nội dung: ', content),
                _buildDetailRow('Thời gian: ', time),
                _buildDetailRow('Ngày: ', date),
                _buildDetailRow('Người tạo sự kiện: ', nameCreate),
                _buildDetailRow('Ghi chú: ', note),
                _buildDetailRow('Đính kèm: ', file),
                _buildDetailRow('Cán bộ chủ trì: ', preside),
                _buildDetailRow('Cán bộ tham dự: ', member),
                _buildDetailRow('Địa điểm: ', location),
                _buildDetailRow('Tài nguyên khác: ', resources),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            // Sử dụng Expanded để nội dung không bị giới hạn
            child: Text(content, overflow: TextOverflow.visible), // Bỏ ellipsis
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông báo!'),
          content: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Bạn có muốn ',
                  style: DefaultTextStyle.of(context).style,
                ),
                const TextSpan(
                  text: 'xóa ghi chú',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                TextSpan(
                  text: ' này?',
                  style: DefaultTextStyle.of(context).style,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () async {
                EasyLoading.show();
                await Future.delayed(const Duration(milliseconds: 200));
                EasyLoading.dismiss();
                Navigator.of(context).pop();
                onDelete();
              },
              child: const Text(
                'Xóa',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
