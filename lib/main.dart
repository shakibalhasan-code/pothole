import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jourapothole/core/utils/routes/app_pages.dart';
import 'package:jourapothole/core/utils/themes/app_theme.dart';
import 'package:jourapothole/core/utils/loading_controller.dart';
import 'package:jourapothole/core/config/app_constants.dart';
import 'package:jourapothole/firebase_options.dart';
import 'package:jourapothole/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions.currentPlatform, // Uses firebase_options.dart
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: AppConstants.appName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
          locale: Get.deviceLocale,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
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
                                  child: CupertinoActivityIndicator(
                                    animating: true,
                                  ),
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
