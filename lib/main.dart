import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jourapothole/core/routes/app_pages.dart';
import 'package:jourapothole/core/themes/app_theme.dart';
import 'package:jourapothole/core/utils/loading_controller.dart';
import 'package:jourapothole/core/config/app_constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: AppConstants.appName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
          locale: const Locale('en'), 
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', ''), Locale('es', '')],
          debugShowCheckedModeBanner: false,
          builder: (context, widget) {
            return Stack(
              children: [
                widget!,
                GetX<LoadingController>(
                  init: LoadingController(),
                  builder:
                      (controller) =>
                          controller.isLoading.value
                              ? Container(
                                color: Colors.black.withValues(alpha: 0.5),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                              : const SizedBox.shrink(),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
