import 'package:flutter/material.dart';

class TabcardItem extends StatelessWidget {
  final String date;
  final String time;
  final String content;
  final String notes;
  final String hosts;
  final String attendeesRequired;
  final String attendeesNoRequired;
  final String resources;
  final String attachments;
  final String creator;

  const TabcardItem({
    Key? key,
    required this.date,
    required this.time,
    required this.content,
    required this.notes,
    required this.hosts,
    required this.attendeesRequired,
    required this.attendeesNoRequired,
    required this.resources,
    required this.attachments,
    required this.creator,
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
          title: _buildTitle(context),
          subtitle: _buildSubtitle(context),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDateInfo(context),
        _buildErrorIndicator(),
      ],
    );
  }

  Widget _buildErrorIndicator() {
    Color indicatorColor = Colors.green;

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
        SizedBox(height: 4),
        Text(content, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTimeInfo(context),
            _buildActionButtons(context),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildPerson(context),
            _buildAttachment(context),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeInfo(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.03;
    final textSize = screenWidth * 0.04;

    return Row(
      children: [
        Icon(Icons.timer_outlined, color: Colors.grey, size: iconSize),
        SizedBox(width: 4),
        Text(time, style: TextStyle(fontSize: textSize)),
      ],
    );
  }

  Widget _buildDateInfo(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.03;
    final textSize = screenWidth * 0.04;

    return Row(
      children: [
        Icon(Icons.date_range, color: Colors.grey, size: iconSize),
        SizedBox(width: 4),
        Text(date, style: TextStyle(fontSize: textSize)),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth * 0.06;

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

  Widget _buildPerson(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.03;
    final textSize = screenWidth * 0.04;

    int totalAttendees = _calculateTotalAttendees();

    String displayText = totalAttendees > 0 ? "+$totalAttendees" : "0";

    return Row(
      children: [
        Icon(Icons.person, color: Colors.grey, size: iconSize),
        SizedBox(width: 8),
        Text('Số lượng người: ',
            style: TextStyle(color: Colors.grey, fontSize: textSize)),
        Text(displayText,
            style: TextStyle(color: Colors.grey, fontSize: textSize)),
      ],
    );
  }

  int _calculateTotalAttendees() {
    int requiredAttendees =
        attendeesRequired.split(',').where((e) => e.trim().isNotEmpty).length;
    int nonRequiredAttendees =
        attendeesNoRequired.split(',').where((e) => e.trim().isNotEmpty).length;
    return requiredAttendees + nonRequiredAttendees;
  }

  Widget _buildAttachment(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.03;
    final textSize = screenWidth * 0.04;

    return Row(
      children: [
        Icon(Icons.file_copy_rounded, color: Colors.grey, size: iconSize),
        SizedBox(width: 4),
        Text(
            attachments.isNotEmpty
                ? 'Có tệp đính kèm'
                : 'Không có tệp đính kèm',
            style: TextStyle(fontSize: textSize)),
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
      borderRadius: BorderRadius.circular(size * 0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(size * 0.3),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size * 0.4, vertical: size * 0.2),
          child: Icon(icon, color: Colors.white, size: size * 0.7),
        ),
      ),
    );
  }

  void _showEditBottomSheet(BuildContext context) {
    // Implement edit functionality
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
                _buildDetailRow('Ngày:', date),
                _buildDetailRow('Thời gian:', time),
                _buildDetailRow('Nội dung:', content),
                _buildDetailRow('Ghi chú:', notes),
                _buildDetailRow('Chủ trì:', hosts),
                _buildDetailRow('Người tham dự bắt buộc:', attendeesRequired),
                _buildDetailRow(
                    'Người tham dự không bắt buộc:', attendeesNoRequired),
                _buildDetailRow('Tài nguyên:', resources),
                _buildDetailRow('Tệp đính kèm:', attachments),
                _buildDetailRow('Người tạo:', creator),
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
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          Expanded(
            child: Text(content, overflow: TextOverflow.visible),
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
          title: const Text('Thông báo'),
          content: const Text('Bạn có chắc chắn muốn xóa không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy bỏ'),
            ),
            TextButton(
              onPressed: () {
                // Implement delete functionality
                Navigator.of(context).pop();
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }
}
