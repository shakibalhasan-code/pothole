import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jourapothole/features/home/controllers/home_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.homeTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.welcomeMessage,
              style: TextStyle(fontSize: 20.sp),
            ),
            Obx(
              () => Text(
                AppLocalizations.of(
                  context,
                )!.count(controller.count.value.toString()),
                style: TextStyle(fontSize: 24.sp),
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: controller.increment,
              child: Text(AppLocalizations.of(context)!.increment),
            ),
          ],
        ),
      ),
    );
  }
}
