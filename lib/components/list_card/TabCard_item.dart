import 'package:flutter/material.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/network/api_service.dart';

class TabcardItem extends StatefulWidget {
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
  final String? color;
  final VoidCallback? onDeleteSuccess;
  final String id;
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
    required this.id,
    this.color,
    this.onDeleteSuccess,
  }) : super(key: key);

  @override
  _TabcardItemState createState() => _TabcardItemState();
}

class _TabcardItemState extends State<TabcardItem> {
  final ApiProvider _apiProvider = ApiProvider();

  @override
  void initState() {
    super.initState();
  }

  Color get _getColor {
    return widget.color != null
        ? Color(int.parse(widget.color!.replaceAll('#', '0xFF')))
        : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _getColor,
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _getColor,
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
        Text(widget.content, style: TextStyle(fontWeight: FontWeight.bold)),
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
        Text(widget.time, style: TextStyle(fontSize: textSize)),
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
        Text(widget.date, style: TextStyle(fontSize: textSize)),
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
    int requiredAttendees = widget.attendeesRequired
        .split(',')
        .where((e) => e.trim().isNotEmpty)
        .length;
    int nonRequiredAttendees = widget.attendeesNoRequired
        .split(',')
        .where((e) => e.trim().isNotEmpty)
        .length;
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
            widget.attachments.isNotEmpty
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
                _buildDetailRow('Ngày:', widget.date),
                _buildDetailRow('Thời gian:', widget.time),
                _buildDetailRow('Nội dung:', widget.content),
                _buildDetailRow('Ghi chú:', widget.notes),
                _buildDetailRow('Chủ trì:', widget.hosts),
                _buildDetailRow(
                    'Người tham dự bắt buộc:', widget.attendeesRequired),
                _buildDetailRow('Người tham dự không bắt buộc:',
                    widget.attendeesNoRequired),
                _buildDetailRow('Tài nguyên:', widget.resources),
                _buildDetailRow('Tệp đính kèm:', widget.attachments),
                _buildDetailRow('Người tạo:', widget.creator),
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
          content: const Text('Bạn có muốn xóa không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                // Gọi API xóa
                bool success = await _apiProvider.deleteEventCalendar(
                  widget.id, // Thêm id vào TabcardItem
                  User.token.toString(),
                );

                Navigator.of(context).pop(); // Đóng dialog

                if (success) {
                  // Hiển thị thông báo thành công
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Xóa thành công')),
                  );

                  // Gọi callback để refresh
                  if (widget.onDeleteSuccess != null) {
                    widget.onDeleteSuccess!();
                  }
                } else {
                  // Hiển thị thông báo lỗi
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Xóa thất bại')),
                  );
                }
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }
}
