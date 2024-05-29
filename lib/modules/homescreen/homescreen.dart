import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_gellary/modules/homescreen/cubit/home_cubit.dart';
import 'package:my_gellary/modules/loginscreen/cubit/login_cubit.dart';
import 'package:my_gellary/modules/loginscreen/loginscreen.dart';
import 'package:my_gellary/shared/components/components.dart';
import 'package:my_gellary/shared/components/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is ImagePickedSuccessState) {
          HomeCubit.get(context).uploadImage();
        }
        if (state is AddImagePickedSuccessState) {
          HomeCubit.get(context).isShowingPopup = false;
          showToast(
              text: 'Image uploaded successfully', state: ToastStates.success);
          HomeCubit.get(context).getData();
        }
      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/gellary.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned(
                top: 30,
                right: 35,
                child: Container(
                  width: 55,
                  height: 55,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.amber),
                  child: Image.asset('assets/images/person image.png'),
                ),
              ),
              Positioned(
                  top: 35,
                  left: 30,
                  child: Text(
                    'Welcome\n${cubit.firstName}',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.displayLarge,
                  )),
              Positioned(
                top: 130,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          defaultControlButton(context, onPressed: () {
                            token = '';
                            LoginCubit.get(context).userModel = null;
                            navigateAndFinish(context, const LoginScreen());
                          },
                              iconImage: 'assets/icons/arrowLeft.png',
                              text: 'Log Out'),
                          defaultControlButton(context, onPressed: () {
                            cubit.showPopUp(true);
                            showCustomPopup(context);
                          },
                              iconImage: 'assets/icons/arrowUp.png',
                              text: 'Upload'),
                        ],
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(seconds: 1),
                        switchInCurve: Curves.easeIn,
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: state is GetImageLoadingState
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blue[900],
                                ),
                              )
                            : showGridView(),
                      ),
                      const SizedBox(
                        height: 25,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
