import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar/models/login_model.dart';
import 'package:flutter_calendar/network/api_service.dart';
import 'package:flutter_calendar/pages/home_page/home_page.dart';
import 'package:flutter_calendar/pages/login/bloc/bloc/auth_bloc.dart';
import 'package:flutter_calendar/pages/login/compoments/my_button.dart';
import 'package:flutter_calendar/pages/login/compoments/my_textfield.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  final bool isBack;

  LoginPage({this.isBack = false});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = 'leminhhung';
    _passwordController.text = 'abc123';
  }

  void _onLoginButtonPressed(BuildContext context) {
    final String email = _emailController.text;
    final String password = _passwordController.text;
    // Implement login logic here
    BlocProvider.of<AuthBloc>(context).add(LoginRequested(email, password, ''));
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xe06f3cd7),
              ],
              stops: [0.66],
              begin: Alignment.topCenter,
            ),
          ),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthFailure) {
            print('login LoginError');
            EasyLoading.showError('Sai tài khoản hoặc mật khẩu');
          } else if (state is AuthLoading) {
            EasyLoading.show();
          } else if (state is AuthSuccess) {
            EasyLoading.dismiss();
            print('Login thành công');
            User.id = state.loginData.id!;
            User.email = state.loginData.email!;
            User.phone = state.loginData.phone!;
            User.username = state.loginData.username!;
            User.fullName = state.loginData.fullName!;
            User.token = state.loginData.token!;

            print('Token of id: ${User.id}');
            print('Token of email: ${User.email}');
            print('Token of phone: ${User.phone}');
            print('Token of username: ${User.username}');
            print('Token of fullName: ${User.fullName}');
            print('Token of token: ${User.token}');

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false);
          }
        },
        child: Stack(
          children: [
            // Background gradient
            Container(
              height: 250,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xe06f3cd7),
                    Color(0xe8cfb3f6),
                  ],
                  stops: [0.66, 1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Welcome message
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60),
                  Text(
                    'Hello!',
                    style: TextStyle(
                      color: Color(0xf2ffffff),
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      height: 2.0,
                      decoration: TextDecoration.none,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            // Main login form container
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              MyTextfield(
                                placeHolder: "Email",
                                controller: _emailController,
                              ),
                              const SizedBox(height: 20),
                              MyTextfield(
                                isPassword: true,
                                placeHolder: "Mật khẩu",
                                controller: _passwordController,
                              ),
                              const SizedBox(height: 20),
                              MyButton(
                                fontsize: 18,
                                paddingText: 16,
                                text: 'ĐĂNG NHẬP',
                                onTap: () => _onLoginButtonPressed(context),
                              ),
                              const SizedBox(height: 10),
                              _ForgotPassword(context),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Footer that disappears when keyboard is visible
            Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom == 0 ? 0 : -100,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          await ApiProvider();
                        },
                        icon: Image.asset(
                          'assets/images/logo_google.png',
                          width: 26,
                          height: 26,
                        ),
                        label: const Text(
                          'Google',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Xử lý đăng nhập Facebook
                        },
                        icon: Image.asset(
                          'assets/images/logo_facebook.png',
                          width: 23,
                          height: 23,
                        ),
                        label: const Text('Facebook'),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Chưa có tài khoản?'),
                        const SizedBox(width: 5),
                        InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              'Đăng ký',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0XFF6F3CD7),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ForgotPassword(BuildContext context) {
    return Row(
      children: [
        Expanded(
          // Đảm bảo nút chiếm toàn bộ chiều rộng
          child: TextButton(
            onPressed: () {
              // Điều hướng tới trang ForgotPage
            },
            style: TextButton.styleFrom(
              side: const BorderSide(
                color: Color(0xe06f3cd7), // Màu viền
                width: 1.0, // Độ dày viền
              ),
            ),
            child: const Text('Quên mật khẩu?'),
          ),
        ),
      ],
    );
  }
}
