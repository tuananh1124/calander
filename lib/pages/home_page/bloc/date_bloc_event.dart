part of 'date_bloc.dart';

sealed class DateBlocEvent extends Equatable {
  const DateBlocEvent();

  @override
  List<Object> get props => [];
}

class LoadData extends DateBlocEvent {
  final DateTime date;

  const LoadData(this.date);

  @override
  List<Object> get props => [date];
}
