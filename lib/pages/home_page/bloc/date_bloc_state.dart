part of 'date_bloc.dart';

class DateBlocState extends Equatable {
  final List<Map<String, String>> daysList;

  const DateBlocState({
    required this.daysList,
  });
  DateBlocState copyWith({
    List<Map<String, String>>? daysList,
  }) {
    return DateBlocState(
      daysList: daysList ?? this.daysList,
    );
  }

  @override
  List<Object> get props => [daysList];
}
