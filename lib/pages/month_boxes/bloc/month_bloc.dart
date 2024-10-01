import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

part 'month_bloc_state.dart';
part 'month_bloc_event.dart';

class MonthBloc extends Bloc<MonthBlocEvent, MonthBlocState> {
  MonthBloc()
      : super(MonthBlocState(monthsList: [], selectedDate: DateTime.now())) {
    on<LoadDataToMonth>(_onLoadData);
    on<ChangeMonth>(_onChangeMonth);
  }

  void _onLoadData(LoadDataToMonth event, Emitter<MonthBlocState> emit) async {
    await initializeDateFormatting('vi_VN', null);
    final inputDate = event.date;

    List<Map<String, String>> monthsList = List.generate(12, (i) {
      final month = DateTime(inputDate.year, i + 1, 1);
      final monthName = DateFormat('MMMM', 'vi_VN').format(month);
      return {
        'monthOfYear': 'T${i + 1}',
        'monthName': monthName,
        'formattedDate': DateFormat('MM/yyyy').format(month),
      };
    });

    emit(MonthBlocState(monthsList: monthsList, selectedDate: inputDate));
  }

  void _onChangeMonth(ChangeMonth event, Emitter<MonthBlocState> emit) {
    int newMonth = state.selectedDate.month + event.increment;
    int newYear = state.selectedDate.year;

    if (newMonth > 12) {
      newMonth = 1;
      newYear++;
    } else if (newMonth < 1) {
      newMonth = 12;
      newYear--;
    }
    final newDate = DateTime(newYear, newMonth, 1);
    add(LoadDataToMonth(newDate)); // Load data for the new month
  }
}
