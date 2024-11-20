import 'package:flutter/material.dart';
import 'package:flutter_calendar/models/color_model.dart';
import 'package:flutter_calendar/pages/addtask_manager/addtask_tab/content_addtask_tab.dart';
import 'package:intl/intl.dart';
import 'package:flutter_calendar/components/list_card/TabCard_item.dart';
import 'package:flutter_calendar/models/list_event_calendar_model.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/network/api_service.dart';

class TabcardList extends StatefulWidget {
  final bool isMorning;
  final Function(int) onEventCountChanged;
  final DateTime selectedDate;
  final String calendarType; // Thêm tham số này
  final Function? onRefresh; // Thêm callback để refresh
  final VoidCallback? onRefreshComplete; // Thêm callback này
  TabcardList({
    Key? key,
    required this.isMorning,
    required this.onEventCountChanged,
    required this.selectedDate,
    required this.calendarType, // Thêm vào constructor
    this.onRefresh, // Thêm parameter này
    this.onRefreshComplete,
  }) : super(key: key);

  @override
  TabcardListState createState() => TabcardListState();
}

class TabcardListState extends State<TabcardList>
    with AutomaticKeepAliveClientMixin {
  bool _isLoading = true;
  final ApiProvider _apiProvider = ApiProvider();
  List<ListEventcalendarModel> _events = [];
  ColorModel? _colors;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> refresh() async {
    await fetchListEveneCalendar();
  }

  Future<void> _loadData() async {
    await fetchListEveneCalendar();
    await fetchColors();
  }

  Future<void> fetchColors() async {
    try {
      final colors = await _apiProvider.getColor(User.token.toString());
      setState(() {
        _colors = colors;
      });
    } catch (e) {
      print('Error fetching colors: $e');
    }
  }

  @override
  void didUpdateWidget(TabcardList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate ||
        oldWidget.calendarType != widget.calendarType) {
      fetchListEveneCalendar();
    }
  }

  void _updateEventCount() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onEventCountChanged(_events.length);
      });
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> fetchListEveneCalendar() async {
    if (!mounted) return;

    try {
      setState(() {
        _isLoading = true;
      });

      List<ListEventcalendarModel>? modelList;
      if (widget.calendarType == 'organization') {
        modelList =
            await _apiProvider.getListEveneCalendar(User.token.toString());
      } else {
        modelList = await _apiProvider
            .getListOfPersonalEveneCalendar(User.token.toString());
      }

      if (mounted) {
        final filteredEvents = _filterAndSortEvents(modelList ?? []);
        setState(() {
          _events = filteredEvents;
          _isLoading = false;
        });

        widget.onEventCountChanged?.call(filteredEvents.length);
        widget.onRefreshComplete?.call();
      }
    } catch (e) {
      print('Error fetching event list: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<ListEventcalendarModel> _filterAndSortEvents(
      List<ListEventcalendarModel> events) {
    List<ListEventcalendarModel> filteredEvents = events.where((event) {
      if (event.from != null) {
        DateTime eventTime = DateTime.fromMillisecondsSinceEpoch(event.from!);
        bool isSameDay = eventTime.year == widget.selectedDate.year &&
            eventTime.month == widget.selectedDate.month &&
            eventTime.day == widget.selectedDate.day;
        bool isCorrectTimeOfDay =
            widget.isMorning ? eventTime.hour < 12 : eventTime.hour >= 12;
        return isSameDay && isCorrectTimeOfDay;
      }
      return false;
    }).toList();

    filteredEvents.sort((a, b) => (a.from ?? 0).compareTo(b.from ?? 0));
    return filteredEvents;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return _buildEventList(_events);
  }

  Widget _buildEventList(List<ListEventcalendarModel> events) {
    if (events.isEmpty) {
      return Center(child: Text("Không có dữ liệu"));
    }

    return ListView.builder(
      key: ValueKey('${widget.calendarType}_${widget.selectedDate}'),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Column(
          children: [
            if (index == 0 || _shouldShowTimeDivider(events[index - 1], event))
              _buildTimeDivider(event),
            TabcardItem(
              id: event.id ?? '',
              onDeleteSuccess: () {
                fetchListEveneCalendar();
              },
              date: _formatDate(event.from ?? 0),
              time: _formatTime(event.from ?? 0),
              to: (event.to != null && event.to != 0)
                  ? _formatTime(event.to!)
                  : null,
              content: event.content ?? '',
              notes: event.notes ?? '',
              hosts: _formatHosts(event.hosts),
              attendeesRequired: _formatAttendees(event.attendeesRequired),
              attendeesNoRequired: _formatAttendees(event.attendeesNoRequired),
              resources: event.resources?.join(', ') ?? '',
              attachments: _formatFile(event.attachments),
              creator: event.creator?.fullName ?? '',
              color: event.color,
            ),
          ],
        );
      },
    );
  }

  bool _shouldShowTimeDivider(
      ListEventcalendarModel prevEvent, ListEventcalendarModel currentEvent) {
    if (prevEvent.from == null || currentEvent.from == null) return false;
    DateTime prevTime = DateTime.fromMillisecondsSinceEpoch(prevEvent.from!);
    DateTime currentTime =
        DateTime.fromMillisecondsSinceEpoch(currentEvent.from!);
    return prevTime.hour != currentTime.hour;
  }

  Widget _buildTimeDivider(ListEventcalendarModel event) {
    return Container();
  }

  String _formatDate(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _formatTime(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('HH:mm').format(date);
  }

  String _formatHosts(List<Host>? hosts) {
    return hosts?.map((host) => host.fullName ?? '').join(', ') ?? '';
  }

  String _formatAttendees(List<dynamic>? attendees) {
    return attendees?.map((a) => a['fullName'] ?? '').join(', ') ?? '';
  }

  String _formatFile(List<dynamic>? attendees) {
    return attendees?.map((a) => a['fileName'] ?? '').join(', ') ?? '';
  }

  @override
  bool get wantKeepAlive => true;
}
