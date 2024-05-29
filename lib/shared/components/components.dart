import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_gellary/modules/homescreen/cubit/home_cubit.dart';
import 'package:my_gellary/shared/style/responsive.dart';

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => widget), (route) => false);

Widget defaultTextFormField({
  required TextEditingController controller,
  required String hintText,
  bool isPassword = false,
  IconData? suffix,
  Function? suffixPressed,
}) =>
    TextFormField(
      controller: controller,
      obscureText: isPassword,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff988F8C)),
        filled: true,
        fillColor: const Color(0xffF7F7F7),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: () {
                  suffixPressed!();
                },
                icon: Icon(suffix))
            : null,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
        border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(15))),
      ),
    );
Widget defaultControlButton(context,
        {required Function onPressed,
        required String iconImage,
        required String text}) =>
    SizedBox(
        width: 153,
        height: 39.85,
        child: ElevatedButton(
            onPressed: () {
              onPressed();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFFFFF)),
            child: Row(
              children: [
                Image.asset(
                  iconImage,
                  width: 32.22,
                  height: 28.83,
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  text,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            )));

void showCustomPopup(BuildContext context) {
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        if (!cubit.isShowingPopup) {
          overlayEntry.remove();
        }
        return GestureDetector(
          onTap: () {
            overlayEntry.remove();
            cubit.showPopUp(false);
          },
          child: Stack(
            children: [
              Container(
                color: Colors.black.withOpacity(0.1),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.4,
                left: MediaQuery.of(context).size.width * 0.1,
                child: Material(
                  color: Colors.transparent,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            border: Border.all(color: const Color(0xFFFFFFFF)),
                            color: Colors.white.withOpacity(.2)),
                        child: Center(
                            child: AnimatedSwitcher(
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          duration: const Duration(seconds: 1),
                          child: state is AddImagePickedLoadingState
                              ? CircularProgressIndicator(
                                  color: Colors.blue[900],
                                )
                              : Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 180,
                                      height: 65,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFFEFD8F9)),
                                          onPressed: () {
                                            cubit.pickImageFromGallery();
                                          },
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/icons/gallery.png',
                                                width: 32.28,
                                                height: 33.57,
                                              ),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                'Gallery',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall,
                                              )
                                            ],
                                          )),
                                    ),
                                    SizedBox(
                                      width: 180,
                                      height: 65,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFFEBF6FF)),
                                          onPressed: () {
                                            cubit.pickImageFromCamera();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/icons/camera.png',
                                                width: 30,
                                                height: 58.21,
                                              ),
                                              Text(
                                                'Camera',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall,
                                              )
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                        )),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
  Overlay.of(context).insert(overlayEntry);
}

Widget showGridView() => BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: ResponsiveLayout.isMobile(context) ? 3 : 4,
            crossAxisSpacing: ResponsiveLayout.isMobile(context) ? 15 : 25,
            mainAxisSpacing: ResponsiveLayout.isMobile(context) ? 25 : 35,
            childAspectRatio: 1,
            children: List.generate(
                cubit.imageModel!.data!.images!.length,
                (index) => ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: CachedNetworkImage(
                        imageUrl: cubit.imageModel!.data!.images![index],
                        width: 108,
                        height: 108,
                        fit: BoxFit.cover,
                      ),
                    )));
      },
    );

enum ToastStates { success, error, waring }

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.success:
      color = Colors.green;
      break;
    case ToastStates.error:
      color = Colors.red;
      break;
    case ToastStates.waring:
      color = Colors.yellow;
      break;
  }
  return color;
}

void showToast({required String text, required ToastStates state}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);
