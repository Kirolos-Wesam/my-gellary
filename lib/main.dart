import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_gellary/BlocObserver.dart';
import 'package:my_gellary/modules/homescreen/cubit/home_cubit.dart';
import 'package:my_gellary/modules/loginscreen/cubit/login_cubit.dart';
import 'package:my_gellary/modules/loginscreen/loginscreen.dart';
import 'package:my_gellary/shared/network/remote/diohelper.dart';
import 'package:my_gellary/shared/style/theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DioHelper.init();
  Bloc.observer = MyBlocObserver();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => HomeCubit())
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: false,
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: defaultTheme,
          home:  LoginScreen(),
        ),
      ),
    );
  }
}
