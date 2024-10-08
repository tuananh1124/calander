import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
// Phần định nghĩa của state
part 'date_bloc_event.dart';
// Phần định nghĩa của event
part 'date_bloc_state.dart';

class DateBloc extends Bloc<DateBlocEvent, DateBlocState> {
  DateBloc() : super(DateBlocState(daysList: [])) {
    on<LoadData>(_onLoadData);
  }

  void _onLoadData(LoadData event, Emitter<DateBlocState> emit) async {
    print("Đã vào BloC thứ");
    await initializeDateFormatting('vi_VN', null);

    // Ngày truyền vào
    final inputDate = event.date;

    // Tính ngày của tuần hiện tại từ ngày truyền vào
    final firstDayOfWeek =
        inputDate.subtract(Duration(days: inputDate.weekday - 1));
    final lastDayOfWeek = firstDayOfWeek.add(Duration(days: 6));

    // Tạo danh sách chứa ngày và thứ trong tuần
    List<Map<String, String>> daysList = [];

    // Bản đồ rút gọn tên thứ
    final Map<String, String> shortDayMap = {
      'Thứ Hai': 'T2',
      'Thứ Ba': 'T3',
      'Thứ Tư': 'T4',
      'Thứ Năm': 'T5',
      'Thứ Sáu': 'T6',
      'Thứ Bảy': 'T7',
      'Chủ Nhật': 'CN',
    };

    for (int i = 0; i < 7; i++) {
      // Tính ngày của tuần
      final date = firstDayOfWeek.add(Duration(days: i));

      // Định dạng thứ trong tuần (vi_VN là ngôn ngữ Tiếng Việt)
      final dayOfWeek = DateFormat('EEEE', 'vi_VN').format(date);

      // Rút gọn tên thứ bằng cách sử dụng shortDayMap
      final shortDayOfWeek = shortDayMap[dayOfWeek] ?? dayOfWeek;

      // Định dạng ngày tháng theo kiểu d/M
      final dayMonth = DateFormat('d').format(date);

      // Thêm vào danh sách
      daysList.add({
        'dayOfWeek': shortDayOfWeek,
        'dayMonth': dayMonth,
        'date': DateFormat('dd/MM/yyyy').format(date),
      });
    }

    // In ra danh sách các ngày và thứ trong tuần
    daysList.forEach((day) {
      print("Ngày: ${day['dayMonth']}, Thứ: ${day['dayOfWeek']}");
    });

    // Cập nhật trạng thái với danh sách ngày và thứ trong tuần
    emit(DateBlocState(daysList: daysList));
  }
}
