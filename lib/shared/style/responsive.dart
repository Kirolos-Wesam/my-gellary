import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget ? mediumScreen;
  final Widget smallScreen;

  const ResponsiveLayout(
      {Key ? key,
        this.mediumScreen,
        required this.smallScreen,
      })
      : super(key: key);

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 500;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width > 499 &&
        MediaQuery.of(context).size.width < 1000;
  }
  

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
          if (constraints.maxWidth < 1000 && constraints.maxWidth > 499) {
          return mediumScreen!;
        } else {
          return smallScreen;
        }
      },
    );
  }
}
