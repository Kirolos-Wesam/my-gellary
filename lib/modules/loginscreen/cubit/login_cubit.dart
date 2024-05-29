import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_gellary/models/usermodel.dart';
import 'package:my_gellary/shared/network/endpoints.dart';
import 'package:my_gellary/shared/network/remote/diohelper.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  UserModel? userModel;

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void loginUser({required String email, required String password}){
    emit(LoginLoadingState());

    DioHelper.postData(url: login, data: {'email': email, 'password':password}).then((value) async{
      userModel = UserModel.fromJson(value.data);
      emit(LoginSuccessState(userModel!.token!));
    }).catchError((onError) {
      emit(LoginErrorState());
    });
  }

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ChangePasswordVisibilityState());
  }
}
