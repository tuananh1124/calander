part of 'month_bloc.dart';

abstract class MonthBlocEvent extends Equatable {
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

class ChangeMonth extends MonthBlocEvent {
  final int increment;

  const ChangeMonth(this.increment);

  @override
  List<Object> get props => [increment];
}
