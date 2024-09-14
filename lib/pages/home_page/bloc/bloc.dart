import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
// Phần định nghĩa của state
part 'bloc_event.dart';
// Phần định nghĩa của event
part 'bloc_state.dart';

class Bloc_Date extends Bloc<Bloc_Date_Event, Bloc_Date_State> {
  Bloc_Date()
      : super(Bloc_Date_State(
          dayOfWeek: '',
          dayMonth: '',
        )) {
    on<LoadData>(_onLoadHomeData);
  }

  void _onLoadHomeData(LoadData event, Emitter<Bloc_Date_State> emit) {
    // Ví dụ về việc tạo daysList
    final now = DateTime.now();
    final startOfWeek =
        now.subtract(Duration(days: now.weekday - 1)); // Ngày đầu tuần

    final daysList = List.generate(7, (index) {
      final date = startOfWeek.add(Duration(days: index));
      return {
        'dayOfWeek': DateFormat('EEEE', 'vi_VN').format(date),
        'dayMonth': DateFormat('d/M').format(date),
      };
    });

    emit(Bloc_Date_State(
      dayOfWeek: DateFormat('EEEE', 'vi_VN').format(now),
      dayMonth: DateFormat('d/M').format(now),
      daysList: daysList, // Đảm bảo daysList được truyền vào state
    ));
  }
}
