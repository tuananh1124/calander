part of 'bloc.dart';

class IncrementCount extends Bloc_Date_Event {}

sealed class Bloc_Date_Event extends Equatable {
  const Bloc_Date_Event();

  @override
  List<Object> get props => [];
}

class LoadData extends Bloc_Date_Event {
  const LoadData();

  @override
  List<Object> get props => [];
}
