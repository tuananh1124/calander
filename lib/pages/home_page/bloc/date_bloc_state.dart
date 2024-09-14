part of 'date_bloc.dart';

class DateBlocState extends Equatable {
  final List<Map<String, String>> daysList;

  DateBlocState({required this.daysList});

  // Thêm phương thức copyWith
  DateBlocState copyWith({List<Map<String, String>>? daysList}) {
    return DateBlocState(
      daysList: daysList ?? this.daysList,
    );
  }

  @override
  List<Object> get props => [daysList];
}
