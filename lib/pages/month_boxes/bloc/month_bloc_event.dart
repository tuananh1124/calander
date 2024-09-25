part of 'month_bloc.dart';

sealed class MonthBlocEvent extends Equatable {
  const MonthBlocEvent();

  @override
  List<Object> get props => [];
}

class LoadDataToMonth extends MonthBlocEvent {
  final DateTime date;

  const LoadDataToMonth(this.date);

  @override
  List<Object> get props => [date];
}
