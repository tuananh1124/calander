part of 'month_bloc.dart';

class MonthBlocState extends Equatable {
  final List<Map<String, String>> monthsList;
  final DateTime selectedDate;

  const MonthBlocState({
    required this.monthsList,
    required this.selectedDate,
  });

  @override
  List<Object> get props => [monthsList, selectedDate];

  MonthBlocState copyWith({
    List<Map<String, String>>? monthsList,
    DateTime? selectedDate,
  }) {
    return MonthBlocState(
      monthsList: monthsList ?? this.monthsList,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}
