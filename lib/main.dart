import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar/pages/login/bloc/bloc/auth_bloc.dart';
import 'package:flutter_calendar/pages/month_boxes/bloc/month_bloc.dart';
import 'package:flutter_calendar/pages/month_boxes/calanderToMonth.dart';
import 'package:flutter_calendar/pages/home_page/bloc/date_bloc.dart';
import 'package:flutter_calendar/pages/home_page/home_page.dart';
import 'package:flutter_calendar/components/search_bar.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<DateBloc>(
          create: (context) => DateBloc(),
        ),
        BlocProvider<MonthBloc>(
          create: (context) => MonthBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
