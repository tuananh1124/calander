import 'package:flutter/material.dart';

class CustomTimePicker extends StatefulWidget {
  final Function(TimeOfDay) onTimeSelected;
  final TimeOfDay initialTime;

  CustomTimePicker({required this.onTimeSelected, required this.initialTime});

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late int _hour;
  late int _minute;
  late String _period;

  final List<int> _validMinutes = List.generate(12, (index) => index * 5);

  @override
  void initState() {
    super.initState();
    _hour = widget.initialTime.hour;
    _minute = _validMinutes.contains(widget.initialTime.minute)
        ? widget.initialTime.minute
        : _validMinutes.reduce((curr, next) =>
            (next - widget.initialTime.minute).abs() <
                    (curr - widget.initialTime.minute).abs()
                ? next
                : curr);
    _updatePeriod();
  }

  void _updatePeriod() {
    _period = _hour < 12 ? 'AM' : 'PM';
    _hour = _hour % 12;
    if (_hour == 0) _hour = 12;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Chọn giờ'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<int>(
                value: _hour,
                items: List.generate(12, (index) => index + 1)
                    .map((hour) => DropdownMenuItem(
                          value: hour,
                          child: Text(hour.toString()),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _hour = value!;
                    if (_hour == 12) {
                      _period = _period == 'AM' ? 'PM' : 'AM';
                    }
                  });
                },
              ),
              Text(':'),
              DropdownButton<int>(
                value: _minute,
                items: _validMinutes
                    .map((minute) => DropdownMenuItem(
                          value: minute,
                          child: Text(minute.toString().padLeft(2, '0')),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _minute = value!;
                  });
                },
              ),
              DropdownButton<String>(
                value: _period,
                items: ['AM', 'PM']
                    .map((period) => DropdownMenuItem(
                          value: period,
                          child: Text(period),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _period = value!;
                    if (_hour == 12) {
                      _hour = _hour % 12;
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            int finalHour = _hour % 12 + (_period == 'PM' ? 12 : 0);
            if (finalHour == 24) finalHour = 0;
            widget.onTimeSelected(TimeOfDay(hour: finalHour, minute: _minute));
            Navigator.of(context).pop();
          },
          child: Text('Chọn'),
        ),
      ],
    );
  }
}
