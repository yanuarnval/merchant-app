import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merchant_app/bloc/event/login_event.dart';
import 'package:merchant_app/bloc/login_bloc.dart';
import 'package:merchant_app/bloc/state/login_state.dart';
import 'package:merchant_app/screen/home/home_page.dart';
import 'package:merchant_app/screen/mainScreen/mainScreen.dart';
import 'package:merchant_app/screen/register/register_page.dart';
import 'package:merchant_app/shared/colors_value.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(),
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoadingLoginState) {
                _isLoading = true;
              }
              if (state is SuccesLoginState) {
                _isLoading = false;
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContextc) => MainScreen()));
              }
              if(state is FailureLoginState){
                _isLoading=false;
              }
            },
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 40.0, right: 40.0, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/login_img.png',
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.height * 0.4,
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              'mari kita masuk.',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500, fontSize: 30),
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: TextFormField(
                            cursorColor: ColorsWeplant.colorPrimary,
                            controller: _emailController,
                            style: GoogleFonts.poppins(
                                color: Colors.black, fontSize: 16),
                            validator: (value) {},
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: ColorsWeplant.colorTextfield,
                              filled: true,
                              hintText: "Email",
                              hintStyle: GoogleFonts.poppins(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: TextFormField(
                            cursorColor: ColorsWeplant.colorPrimary,
                            controller: _passwordController,
                            style: GoogleFonts.poppins(
                                color: Colors.black, fontSize: 16),
                            validator: (value) {},
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: ColorsWeplant.colorTextfield,
                              filled: true,
                              hintText: "Password",
                              hintStyle: GoogleFonts.poppins(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 19,
                        ),
                        const Text(
                          'Forgot password?',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: ColorsWeplant.colorPrimary),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        _buildButtonLogin()
                      ],
                    ),
                  ),
                ),
                (_isLoading)
                    ? Container(
                        color: Colors.grey.withOpacity(0.2),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _showMyDialog(String error, BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: Text('Error code $error'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('oke'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Column _buildButtonLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
          return ElevatedButton(
              onPressed: () {
                if (_emailController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty) {
                  context.read<LoginBloc>().add(PostLogin(
                      _emailController.text, _passwordController.text));
                }
              },
              child: const Text(
                'Login',
                style: TextStyle(),
              ));
        }),
        TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext c) => const Registerpage()));
          },
          child: RichText(
            text: TextSpan(
              text: 'Don’t have an account?',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400, color: Colors.grey),
              children: [
                TextSpan(
                    text: ' sign up',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        color: ColorsWeplant.colorPrimary)),
              ],
            ),
          ),
        )
      ],
    );
  }
}
