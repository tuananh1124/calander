import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

part 'month_bloc_state.dart';
part 'month_bloc_event.dart';

class MonthBloc extends Bloc<MonthBlocEvent, MonthBlocState> {
  MonthBloc() : super(MonthBlocState(monthsList: [])) {
    on<LoadDataToMonth>(_onLoadData);
  }

  void _onLoadData(LoadDataToMonth event, Emitter<MonthBlocState> emit) async {
    await initializeDateFormatting('vi_VN', null);
    final inputDate = event.date;
    List<Map<String, String>> monthsList = [];

    for (int i = 0; i < 12; i++) {
      final month = DateTime(inputDate.year, i + 1, 1);
      monthsList.add({
        'monthOfYear': 'T${i + 1}', // Concise format
        'formattedDate': DateFormat('MM/yyyy').format(month),
      });
    }

    emit(MonthBlocState(monthsList: monthsList));
  }
}
