import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/network/api_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiProvider _apiProvider = ApiProvider();

  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      LoginModel? loginData =
          await ApiProvider().login(event.username, event.password, '');

      print('data: $loginData');

      if (loginData != null) {
        emit(AuthSuccess(loginData: loginData));
      } else {
        emit(AuthFailure(error: 'Invalid email or password'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}
