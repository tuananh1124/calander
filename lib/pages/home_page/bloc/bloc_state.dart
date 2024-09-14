part of 'bloc.dart';

class Bloc_Date_State extends Equatable {
  final String dayOfWeek;
  final String dayMonth;
  final List<Map<String, String>> daysList; // Thêm daysList ở đây

  Bloc_Date_State({
    required this.dayOfWeek,
    required this.dayMonth,
    this.daysList = const [], // Khởi tạo daysList với giá trị mặc định
  });

  @override
  List<Object> get props => [dayOfWeek, dayMonth, daysList];

  Bloc_Date_State copyWith({
    String? dayOfWeek,
    String? dayMonth,
    List<Map<String, String>>? daysList,
  }) {
    return Bloc_Date_State(
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      dayMonth: dayMonth ?? this.dayMonth,
      daysList: daysList ?? this.daysList,
    );
  }
}
