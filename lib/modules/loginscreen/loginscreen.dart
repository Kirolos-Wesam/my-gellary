import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_gellary/modules/homescreen/cubit/home_cubit.dart';
import 'package:my_gellary/modules/homescreen/homescreen.dart';
import 'package:my_gellary/modules/loginscreen/cubit/login_cubit.dart';
import 'package:my_gellary/shared/components/components.dart';
import 'package:my_gellary/shared/components/constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          token = state.token;
          HomeCubit.get(context).getData();
          HomeCubit.get(context).firstName = HomeCubit.get(context)
              .getFirstName(LoginCubit.get(context).userModel!.user!.name!);
          navigateAndFinish(context, HomeScreen());
        }
        if(state is LoginErrorState){
          showToast(text: 'Email Or Password Wrong', state: ToastStates.error);
        }
      },
      builder: (context, state) {
        var cubit = LoginCubit.get(context);
        return Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/log in.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('My\nGellary',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center),
                      const SizedBox(
                        height: 25,
                      ),
                      ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35),
                              child: Container(
                                width: double.infinity,
                                height: 360,
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(25))),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'Log In'.toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                      defaultTextFormField(
                                          controller: cubit.emailController,
                                          hintText: 'User Name'),
                                      defaultTextFormField(
                                          controller: cubit.passwordController,
                                          hintText: 'Password',
                                          isPassword: cubit.isPassword, 
                                          suffix: cubit.suffix,
                                          suffixPressed: (){cubit.changePasswordVisibility();},
                                          ),
                                      MaterialButton(
                                        onPressed: () {
                                          cubit.loginUser(
                                              email: cubit.emailController.text,
                                              password: cubit
                                                  .passwordController.text);
                                        },
                                        minWidth: 282.42,
                                        height: 46.11,
                                        color: const Color(0xFF7BB3FF),
                                        shape: const BeveledRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: state is LoginLoadingState
                                            ? CircularProgressIndicator(
                                                color: Color(0xFFFFFFFF),
                                              )
                                            : Text(
                                                'Submit'.toUpperCase(),
                                                style: const TextStyle(
                                                    color: Color(0xFFFFFFFF),
                                                    fontFamily: 'Segoe UI',
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
