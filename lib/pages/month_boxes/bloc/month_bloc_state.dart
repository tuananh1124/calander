part of 'month_bloc.dart';

class MonthBlocState extends Equatable {
  final List<Map<String, String>> monthsList;

  const MonthBlocState({
    required this.monthsList,
  });

  MonthBlocState copyWith({
    List<Map<String, String>>? monthsList,
  }) {
    return MonthBlocState(
      monthsList: monthsList ?? this.monthsList,
    );
  }

  @override
  List<Object> get props => [monthsList];
}
