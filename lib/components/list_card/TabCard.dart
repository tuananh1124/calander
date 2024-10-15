import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_calendar/models/list_of_user_personal_model.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/network/api_service.dart';

class ExpandableCard extends StatefulWidget {
  final String? creator;
  final String? createdTime;
  final String? updatedTime;
  final String? content;
  final String? notes;
  final String? color;
  final String? hosts;
  final String? attendeesRequired;
  final String? attendeesNoRequired;
  final String? resources;
  final String? attachments;

  const ExpandableCard({
    Key? key,
    this.creator,
    this.createdTime,
    this.updatedTime,
    this.content,
    this.notes,
    this.color,
    this.hosts,
    this.attendeesRequired,
    this.attendeesNoRequired,
    this.resources,
    this.attachments,
  }) : super(key: key);

  @override
  _ExpandableCardState createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _filteredDataUserorganization = [];
  final ApiProvider _apiProvider = ApiProvider();

  @override
  void initState() {
    super.initState();
    ListOfPersonalApi();
  }

  Future<void> ListOfPersonalApi() async {
    List<ListofpersonalModel>? modelList =
        await _apiProvider.getListOfPersonal(User.token.toString());
  }

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
        Flexible(
          child: AutoSizeText(
            widget.content!, // Thay đổi từ content sang widget.content
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            minFontSize: 14,
            textAlign: TextAlign.left,
          ),
        ),
        _buildDateInfo(context),
        _buildErrorIndicator(),
      ],
    );
  }

  Widget _buildErrorIndicator() {
    Color indicatorColor = Colors.green;
    if (widget.attachments == 1) {
      indicatorColor = Colors.yellow;
    } else if (widget.attachments == 2) {
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
            _buildPerson(context, widget.attendeesRequired!),
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
        Text(widget.createdTime!,
            style: TextStyle(color: Colors.grey, fontSize: textSize)),
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
        Text(widget.updatedTime!,
            style: TextStyle(color: Colors.grey, fontSize: textSize)),
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

  Widget _buildPerson(BuildContext context, String member) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.03;
    final textSize = screenWidth * 0.04;

    List<String> membersList = member.split(',').map((e) => e.trim()).toList();
    int numberOfMembers = membersList.length;

    String displayText = numberOfMembers > 1 ? "+$numberOfMembers" : "1";

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

  Widget _buildAttachment(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.03;
    final textSize = screenWidth * 0.04;

    return Row(
      children: [
        Icon(Icons.file_copy_rounded, color: Colors.grey, size: iconSize),
        Text(widget.color!,
            style: TextStyle(color: Colors.grey, fontSize: textSize)),
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

  void _showEditBottomSheet(BuildContext context) {}

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
                _buildDetailRow('Nội dung: ', widget.content!),
                _buildDetailRow('Thời gian: ', widget.createdTime!),
                _buildDetailRow('Ngày: ', widget.updatedTime!),
                _buildDetailRow('Người tạo sự kiện: ', widget.creator!),
                _buildDetailRow('Ghi chú: ', widget.notes!),
                _buildDetailRow('Đính kèm: ', widget.color!),
                _buildDetailRow('Cán bộ chủ trì: ', widget.hosts!),
                _buildDetailRow(
                    'Cán bộ tham dự bắt buộc: ', widget.attendeesRequired!),
                _buildDetailRow('Địa điểm: ', widget.attendeesNoRequired!),
                _buildDetailRow('Tài nguyên khác: ', widget.resources!),
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
          ],
        );
      },
    );
  }
}
